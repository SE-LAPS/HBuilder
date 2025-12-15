import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

/// Service to handle IOT device communication via Bluetooth
/// Specifically designed for Arduino-based LED control
class IotService {
  static final IotService _instance = IotService._internal();
  factory IotService() => _instance;
  IotService._internal();

  // Bluetooth state
  BluetoothDevice? _connectedDevice;
  BluetoothCharacteristic? _controlCharacteristic;
  StreamSubscription? _scanSubscription;
  StreamSubscription? _connectionStateSubscription;

  // Status streams
  final _connectionStatusController = StreamController<bool>.broadcast();
  final _scanResultsController = StreamController<List<ScanResult>>.broadcast();
  
  Stream<bool> get connectionStatus => _connectionStatusController.stream;
  Stream<List<ScanResult>> get scanResults => _scanResultsController.stream;

  bool get isConnected => _connectedDevice != null && _controlCharacteristic != null;
  BluetoothDevice? get connectedDevice => _connectedDevice;

  // UUID for HC-05/HC-06 Bluetooth modules (Standard Serial Port Profile)
  // These are commonly used with Arduino
  static const String serviceUUID = "00001101-0000-1000-8000-00805f9b34fb";
  static const String characteristicUUID = "00001101-0000-1000-8000-00805f9b34fb";

  /// Request necessary Bluetooth permissions
  Future<bool> requestPermissions() async {
    try {
      if (defaultTargetPlatform == TargetPlatform.android) {
        Map<Permission, PermissionStatus> statuses = await [
          Permission.bluetoothScan,
          Permission.bluetoothConnect,
          Permission.location,
        ].request();

        return statuses.values.every((status) => status.isGranted);
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        var status = await Permission.bluetooth.request();
        return status.isGranted;
      }
      return false;
    } catch (e) {
      debugPrint('Permission request error: $e');
      return false;
    }
  }

  /// Check if Bluetooth is available and turned on
  Future<bool> isBluetoothAvailable() async {
    try {
      var adapterState = await FlutterBluePlus.adapterState.first;
      return adapterState == BluetoothAdapterState.on;
    } catch (e) {
      debugPrint('Bluetooth availability check error: $e');
      return false;
    }
  }

  /// Start scanning for Bluetooth devices
  Future<void> startScan({Duration timeout = const Duration(seconds: 10)}) async {
    try {
      // Check if Bluetooth is on
      if (!await isBluetoothAvailable()) {
        throw Exception('Bluetooth is not turned on');
      }

      // Stop any existing scan
      await FlutterBluePlus.stopScan();

      // Clear previous results
      _scanResultsController.add([]);

      List<ScanResult> results = [];

      // Listen to scan results
      _scanSubscription?.cancel();
      _scanSubscription = FlutterBluePlus.scanResults.listen((scanResults) {
        results = scanResults;
        _scanResultsController.add(results);
      });

      // Start scanning
      await FlutterBluePlus.startScan(
        timeout: timeout,
        androidUsesFineLocation: true,
      );

      debugPrint('Bluetooth scan started');
    } catch (e) {
      debugPrint('Scan error: $e');
      rethrow;
    }
  }

  /// Stop scanning for devices
  Future<void> stopScan() async {
    try {
      await FlutterBluePlus.stopScan();
      _scanSubscription?.cancel();
      debugPrint('Bluetooth scan stopped');
    } catch (e) {
      debugPrint('Stop scan error: $e');
    }
  }

  /// Connect to a Bluetooth device
  Future<bool> connectToDevice(BluetoothDevice device) async {
    try {
      debugPrint('Attempting to connect to ${device.platformName}');

      // Disconnect from any existing device
      await disconnect();

      // Connect to the new device
      await device.connect(
        timeout: const Duration(seconds: 15),
        autoConnect: false,
      );

      debugPrint('Connected to ${device.platformName}');

      // Listen for connection state changes
      _connectionStateSubscription?.cancel();
      _connectionStateSubscription = device.connectionState.listen((state) {
        if (state == BluetoothConnectionState.disconnected) {
          _handleDisconnection();
        }
      });

      // Discover services
      List<BluetoothService> services = await device.discoverServices();
      debugPrint('Discovered ${services.length} services');

      // For HC-05/HC-06, we need to find the Serial Port service
      // Some modules might use different UUIDs, so we'll try to find any writable characteristic
      BluetoothCharacteristic? targetCharacteristic;

      for (var service in services) {
        debugPrint('Service UUID: ${service.uuid}');
        for (var characteristic in service.characteristics) {
          debugPrint('  Characteristic UUID: ${characteristic.uuid}');
          debugPrint('  Properties: Write=${characteristic.properties.write}, WriteWithoutResponse=${characteristic.properties.writeWithoutResponse}');
          
          // Check if this characteristic is writable
          if (characteristic.properties.write || 
              characteristic.properties.writeWithoutResponse) {
            targetCharacteristic = characteristic;
            debugPrint('  ✓ Found writable characteristic!');
            break;
          }
        }
        if (targetCharacteristic != null) break;
      }

      if (targetCharacteristic == null) {
        throw Exception('No writable characteristic found on device');
      }

      _connectedDevice = device;
      _controlCharacteristic = targetCharacteristic;
      _connectionStatusController.add(true);

      debugPrint('Successfully configured characteristic');
      return true;
    } catch (e) {
      debugPrint('Connection error: $e');
      await disconnect();
      return false;
    }
  }

  /// Send command to turn LED ON
  Future<bool> turnLedOn() async {
    return await _sendCommand('1');
  }

  /// Send command to turn LED OFF
  Future<bool> turnLedOff() async {
    return await _sendCommand('0');
  }

  /// Send a custom command to the Arduino
  Future<bool> _sendCommand(String command) async {
    try {
      if (!isConnected) {
        throw Exception('Not connected to any device');
      }

      debugPrint('Sending command: $command');

      // Convert command to bytes
      List<int> bytes = command.codeUnits;

      // Write to characteristic
      await _controlCharacteristic!.write(
        bytes,
        withoutResponse: _controlCharacteristic!.properties.writeWithoutResponse,
      );

      debugPrint('Command sent successfully');
      return true;
    } catch (e) {
      debugPrint('Send command error: $e');
      return false;
    }
  }

  /// Handle disconnection
  void _handleDisconnection() {
    debugPrint('Device disconnected');
    _connectedDevice = null;
    _controlCharacteristic = null;
    _connectionStatusController.add(false);
  }

  /// Disconnect from the current device
  Future<void> disconnect() async {
    try {
      if (_connectedDevice != null) {
        await _connectedDevice!.disconnect();
        _handleDisconnection();
      }
      _connectionStateSubscription?.cancel();
    } catch (e) {
      debugPrint('Disconnect error: $e');
    }
  }

  /// Clean up resources
  void dispose() {
    _scanSubscription?.cancel();
    _connectionStateSubscription?.cancel();
    _connectionStatusController.close();
    _scanResultsController.close();
    disconnect();
  }
}
