import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../config/theme.dart';
import '../../services/iot_service.dart';

class IotControlScreen extends StatefulWidget {
  const IotControlScreen({super.key});

  @override
  State<IotControlScreen> createState() => _IotControlScreenState();
}

class _IotControlScreenState extends State<IotControlScreen> {
  final IotService _iotService = IotService();
  bool _isScanning = false;
  bool _isConnected = false;
  bool _ledState = false;
  List<ScanResult> _scanResults = [];
  String? _statusMessage;

  @override
  void initState() {
    super.initState();
    _initializeIot();
  }

  Future<void> _initializeIot() async {
    // Listen to connection status
    _iotService.connectionStatus.listen((connected) {
      if (mounted) {
        setState(() {
          _isConnected = connected;
          if (!connected) {
            _ledState = false;
            _statusMessage = 'Disconnected from device';
          } else {
            _statusMessage = 'Connected successfully';
          }
        });
      }
    });

    // Listen to scan results
    _iotService.scanResults.listen((results) {
      if (mounted) {
        setState(() {
          _scanResults = results;
        });
      }
    });

    // Check Bluetooth availability
    bool available = await _iotService.isBluetoothAvailable();
    if (!available && mounted) {
      _showMessage('Please turn on Bluetooth', isError: true);
    }
  }

  Future<void> _startScan() async {
    // Request permissions first
    bool granted = await _iotService.requestPermissions();
    if (!granted) {
      _showMessage('Bluetooth permissions required', isError: true);
      return;
    }

    // Check if Bluetooth is on
    bool available = await _iotService.isBluetoothAvailable();
    if (!available) {
      _showMessage('Please turn on Bluetooth', isError: true);
      return;
    }

    setState(() {
      _isScanning = true;
      _scanResults = [];
      _statusMessage = 'Scanning for devices...';
    });

    try {
      await _iotService.startScan(timeout: const Duration(seconds: 10));
      
      // Wait for scan to complete
      await Future.delayed(const Duration(seconds: 10));
      
      if (mounted) {
        setState(() {
          _isScanning = false;
          _statusMessage = 'Scan complete. Found ${_scanResults.length} device(s)';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isScanning = false;
          _statusMessage = 'Scan error: $e';
        });
        _showMessage('Error scanning: $e', isError: true);
      }
    }
  }

  Future<void> _stopScan() async {
    await _iotService.stopScan();
    setState(() {
      _isScanning = false;
      _statusMessage = 'Scan stopped';
    });
  }

  Future<void> _connectToDevice(BluetoothDevice device) async {
    setState(() {
      _statusMessage = 'Connecting to ${device.platformName}...';
    });

    bool success = await _iotService.connectToDevice(device);
    
    if (mounted) {
      if (success) {
        _showMessage('Connected to ${device.platformName}');
        // Stop scanning after successful connection
        await _stopScan();
      } else {
        _showMessage('Failed to connect to ${device.platformName}', isError: true);
      }
    }
  }

  Future<void> _disconnect() async {
    await _iotService.disconnect();
    setState(() {
      _ledState = false;
    });
  }

  Future<void> _toggleLed() async {
    if (!_isConnected) {
      _showMessage('Please connect to a device first', isError: true);
      return;
    }

    bool success;
    if (_ledState) {
      success = await _iotService.turnLedOff();
    } else {
      success = await _iotService.turnLedOn();
    }

    if (success && mounted) {
      setState(() {
        _ledState = !_ledState;
      });
      _showMessage(_ledState ? 'LED turned ON' : 'LED turned OFF');
    } else {
      _showMessage('Failed to control LED', isError: true);
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Colors.red : AppTheme.primaryColor,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  void dispose() {
    // Don't dispose the service as it's a singleton
    // Just stop scanning if active
    if (_isScanning) {
      _iotService.stopScan();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IOT Control'),
        actions: [
          if (_isConnected)
            IconButton(
              icon: const Icon(Icons.bluetooth_disabled),
              onPressed: _disconnect,
              tooltip: 'Disconnect',
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status Card
            _buildStatusCard(),
            SizedBox(height: 20.h),

            // LED Control Card
            _buildLedControlCard(),
            SizedBox(height: 20.h),

            // Bluetooth Controls
            _buildBluetoothControls(),
            SizedBox(height: 20.h),

            // Device List
            _buildDeviceList(),
            SizedBox(height: 20.h),

            // Setup Instructions Button
            _buildSetupInstructionsButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _isConnected ? Icons.bluetooth_connected : Icons.bluetooth,
                  color: _isConnected ? AppTheme.successColor : AppTheme.greyColor,
                  size: 32.sp,
                ),
                SizedBox(width: 12.w),
                Text(
                  _isConnected ? 'Connected' : 'Not Connected',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: _isConnected ? AppTheme.successColor : AppTheme.greyColor,
                  ),
                ),
              ],
            ),
            if (_isConnected && _iotService.connectedDevice != null) ...[
              SizedBox(height: 8.h),
              Text(
                _iotService.connectedDevice!.platformName.isNotEmpty
                    ? _iotService.connectedDevice!.platformName
                    : 'Unknown Device',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppTheme.greyColor,
                ),
              ),
            ],
            if (_statusMessage != null) ...[
              SizedBox(height: 12.h),
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightGreyColor,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  _statusMessage!,
                  style: TextStyle(fontSize: 12.sp),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLedControlCard() {
    return Card(
      color: _ledState ? AppTheme.primaryColor.withOpacity(0.1) : null,
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            Icon(
              Icons.lightbulb,
              size: 80.sp,
              color: _ledState ? Colors.yellow : AppTheme.greyColor,
            ),
            SizedBox(height: 16.h),
            Text(
              _ledState ? 'LED is ON' : 'LED is OFF',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: _ledState ? AppTheme.primaryColor : AppTheme.greyColor,
              ),
            ),
            SizedBox(height: 20.h),
            ElevatedButton.icon(
              onPressed: _isConnected ? _toggleLed : null,
              icon: Icon(_ledState ? Icons.power_settings_new : Icons.power),
              label: Text(
                _ledState ? 'Turn OFF' : 'Turn ON',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _ledState ? Colors.orange : AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBluetoothControls() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Bluetooth Devices',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _isScanning ? null : _startScan,
                icon: _isScanning
                    ? SizedBox(
                        width: 20.w,
                        height: 20.h,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Icon(Icons.search),
                label: Text(_isScanning ? 'Scanning...' : 'Scan Devices'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                ),
              ),
            ),
            if (_isScanning) ...[
              SizedBox(width: 12.w),
              ElevatedButton(
                onPressed: _stopScan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
                ),
                child: const Text('Stop'),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildDeviceList() {
    if (_scanResults.isEmpty && !_isScanning) {
      return Card(
        child: Padding(
          padding: EdgeInsets.all(32.w),
          child: Column(
            children: [
              Icon(
                Icons.bluetooth_searching,
                size: 48.sp,
                color: AppTheme.greyColor,
              ),
              SizedBox(height: 12.h),
              Text(
                'No devices found',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppTheme.greyColor,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Make sure your Arduino\nBluetooth module is powered on',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppTheme.greyColor,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: _scanResults.map((result) {
        String deviceName = result.device.platformName.isNotEmpty
            ? result.device.platformName
            : 'Unknown Device';
        
        return Card(
          margin: EdgeInsets.only(bottom: 8.h),
          child: ListTile(
            leading: Icon(
              Icons.bluetooth,
              color: AppTheme.primaryColor,
              size: 32.sp,
            ),
            title: Text(
              deviceName,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              result.device.remoteId.toString(),
              style: TextStyle(fontSize: 11.sp),
            ),
            trailing: result.rssi != 0
                ? Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      '${result.rssi} dBm',
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  )
                : null,
            onTap: () => _connectToDevice(result.device),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSetupInstructionsButton() {
    return OutlinedButton.icon(
      onPressed: () => _showSetupInstructions(),
      icon: const Icon(Icons.help_outline),
      label: const Text('Setup Instructions'),
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        side: BorderSide(color: AppTheme.primaryColor),
      ),
    );
  }

  void _showSetupInstructions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('IOT Setup Instructions'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Required Hardware:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text('• Arduino (Uno/Nano/Mega)'),
              const Text('• HC-05 or HC-06 Bluetooth Module'),
              const Text('• LED bulb'),
              const Text('• 220Ω Resistor'),
              const Text('• Jumper wires'),
              const SizedBox(height: 16),
              const Text(
                'Quick Steps:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text('1. Upload Arduino code to your board'),
              const Text('2. Connect HC-05/HC-06 module'),
              const Text('3. Connect LED to pin 13'),
              const Text('4. Power on the Arduino'),
              const Text('5. Tap "Scan Devices" in the app'),
              const Text('6. Select your Bluetooth module'),
              const Text('7. Control the LED!'),
              const SizedBox(height: 16),
              const Text(
                'For detailed instructions, see:\nIOT_SETUP_GUIDE.md',
                style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it!'),
          ),
        ],
      ),
    );
  }
}
