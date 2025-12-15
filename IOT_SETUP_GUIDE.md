# Washtron IOT Setup Guide
## LED Control via Arduino & Bluetooth

This guide will help you integrate IOT functionality into the Washtron app to control an LED bulb using Arduino and a Bluetooth module.

---

## 📋 Table of Contents
1. [Hardware Requirements](#hardware-requirements)
2. [Hardware Setup](#hardware-setup)
3. [Arduino Configuration](#arduino-configuration)
4. [App Configuration](#app-configuration)
5. [Testing the Setup](#testing-the-setup)
6. [Troubleshooting](#troubleshooting)
7. [Advanced Features](#advanced-features)

---

## 🛠️ Hardware Requirements

### Required Components:
- **Arduino Board** (Uno, Nano, or Mega) - ₹400-800
- **HC-05 or HC-06 Bluetooth Module** - ₹200-400
- **LED Bulb** (5mm or 3mm) - ₹5-20
- **220Ω Resistor** (for LED) - ₹2-5
- **1KΩ Resistor** (for voltage divider) - ₹2-5
- **2KΩ Resistor** (for voltage divider) - ₹2-5
- **Jumper Wires** (Male-to-Male, Male-to-Female) - ₹50-100
- **Breadboard** (optional but recommended) - ₹50-150
- **USB Cable** (for Arduino programming) - ₹50-150
- **9V Battery + Battery Clip** (optional, for portable use) - ₹30-80

### Optional Components:
- Multiple LEDs for advanced control
- Relay module for controlling AC appliances
- Buzzer for audio feedback
- Additional sensors (temperature, motion, etc.)

---

## 🔌 Hardware Setup

### Step 1: HC-05/HC-06 Bluetooth Module Connections

**IMPORTANT:** HC-05/HC-06 operates at 3.3V logic level, but Arduino TX is 5V. We need a voltage divider for RXD pin.

#### HC-05/HC-06 to Arduino:

```
HC-05/06 Pin  →  Arduino Pin
━━━━━━━━━━━━━━━━━━━━━━━━━━━━
VCC           →  5V
GND           →  GND
TXD           →  RX (Pin 0) - Direct connection
RXD           →  TX (Pin 1) - Through voltage divider
```

#### Voltage Divider Circuit for RXD:
```
Arduino TX (Pin 1) ──[1KΩ]──┬── HC-05/06 RXD
                             │
                          [2KΩ]
                             │
                            GND
```

This divider reduces 5V to approximately 3.3V, protecting the Bluetooth module.

### Step 2: LED Connections

```
LED Anode (+, longer leg) → Arduino Pin 13 (or any digital pin)
            ↓
        [220Ω Resistor]
            ↓
LED Cathode (-, shorter leg) → GND
```

**Note:** Pin 13 has a built-in LED on most Arduino boards, perfect for initial testing.

### Step 3: Complete Wiring Diagram

```
                    ARDUINO UNO
         ┌──────────────────────────┐
    5V ──┤ 5V                    13 ├── [220Ω] ── LED(+) ── LED(-) ── GND
   GND ──┤ GND                   12 ├
   HC-06├┤ 0 (RX)                11 ├
 TXD     │                       10 ├
   HC-06├┤ 1 (TX) ──[Voltage     9 ├
RXD(3.3V)│           Divider]    8 ├
         │                        7 ├
         │                        6 ├
         │                        5 ├
         │                        4 ├
         │                        3 ├
         │                        2 ├
         └──────────────────────────┘

HC-05/HC-06 MODULE:
┌─────────────┐
│    VCC  ────┼── Arduino 5V
│    GND  ────┼── Arduino GND
│    TXD  ────┼── Arduino RX (Pin 0)
│    RXD  ────┼── Arduino TX (Pin 1) via voltage divider
│    STATE    │ (optional)
│    EN/KEY   │ (optional)
└─────────────┘
```

---

## 💻 Arduino Configuration

### Step 1: Install Arduino IDE
1. Download from: https://www.arduino.cc/en/software
2. Install on your computer
3. Connect Arduino via USB cable

### Step 2: Upload the Code

1. **Open Arduino IDE**
2. **Load the sketch:**
   - Navigate to: `h:\HBuilder\arduino\led_bluetooth_control.ino`
   - Or copy the code from the file

3. **Configure Arduino IDE:**
   - **Tools** → **Board** → Select your Arduino (e.g., "Arduino Uno")
   - **Tools** → **Port** → Select the COM port (e.g., "COM3")

4. **Upload:**
   - Click the **Upload** button (→)
   - Wait for "Done uploading" message

5. **Verify:**
   - Open **Serial Monitor** (Ctrl+Shift+M)
   - Set baud rate to **9600**
   - You should see: "Washtron IOT Ready"

### Step 3: Test Arduino Setup

1. In Serial Monitor, type `1` and press Enter
   - LED should turn ON
   - Serial Monitor shows: "LED: ON"

2. Type `0` and press Enter
   - LED should turn OFF
   - Serial Monitor shows: "LED: OFF"

**If this works, your Arduino setup is correct!** ✅

---

## 📱 App Configuration

### Step 1: Install Dependencies

1. Open terminal in project directory
2. Run:
```bash
flutter pub get
```

This installs:
- `flutter_blue_plus` - Bluetooth communication
- `permission_handler` - Permission management

### Step 2: App Permissions (Already Added)

The following permissions are already configured in `AndroidManifest.xml`:
- ✅ BLUETOOTH
- ✅ BLUETOOTH_ADMIN
- ✅ BLUETOOTH_SCAN
- ✅ BLUETOOTH_CONNECT
- ✅ ACCESS_FINE_LOCATION

### Step 3: Build and Run

1. Connect your Android phone via USB
2. Enable Developer Options and USB Debugging
3. Run:
```bash
flutter run
```

---

## 🎮 Testing the Setup

### Complete Testing Procedure:

#### 1. Prepare Hardware
- ✅ Arduino connected via USB or battery
- ✅ HC-05/06 LED blinking (searching mode)
- ✅ LED circuit connected to Pin 13

#### 2. Pair Bluetooth (First Time Only)

**Method A: Pair via Phone Settings**
1. Go to Android Settings → Bluetooth
2. Turn on Bluetooth
3. Scan for devices
4. Look for "HC-05" or "HC-06" (or custom name)
5. Pair with PIN: `1234` or `0000`

**Method B: Pair via App (Recommended)**
1. Open Washtron app
2. Tap "Test IOT" button on home screen
3. Grant Bluetooth permissions when prompted
4. The app will scan automatically

#### 3. Connect and Control

1. **In the App:**
   - Tap "Scan Devices" button
   - Wait 10 seconds for scan to complete
   - Your HC-05/06 should appear in the list
   - Tap on the device name to connect
   - Status should change to "Connected"

2. **Control LED:**
   - Tap "Turn ON" button → LED lights up
   - Tap "Turn OFF" button → LED turns off
   - Status message confirms each action

#### 4. Verify Connection
- Connection status shows "Connected" with green icon
- Device name displayed under status
- LED responds to commands immediately
- Status messages appear for each action

---

## 🔧 Troubleshooting

### Problem 1: Cannot Find Bluetooth Device

**Symptoms:**
- Scan completes but no devices shown
- HC-05/06 not visible

**Solutions:**
1. **Check HC-05/06 Power:**
   - LED should be blinking rapidly (not paired) or slowly (paired)
   - Measure voltage: VCC should be ~5V
   - Try different power source

2. **Reset HC-05/06:**
   - Disconnect power for 10 seconds
   - Reconnect and wait for LED to blink

3. **Check Bluetooth:**
   - Ensure phone Bluetooth is ON
   - Try pairing in Android Settings first
   - Check if other apps can see Bluetooth devices

4. **HC-05/06 Configuration:**
   - Module might be in AT mode
   - Power cycle without holding EN/KEY button
   - Default name: "HC-05" or "HC-06"

### Problem 2: Device Connects but LED Doesn't Respond

**Symptoms:**
- App shows "Connected"
- Commands sent but LED doesn't change
- No error messages

**Solutions:**
1. **Check LED Circuit:**
   - Verify LED polarity (long leg to resistor, short leg to GND)
   - Test LED with 3V battery
   - Check resistor value (220Ω)
   - Ensure Pin 13 connection is solid

2. **Verify Arduino Code:**
   - Re-upload the sketch
   - Open Serial Monitor (9600 baud)
   - Send `1` and `0` manually
   - Check for response messages

3. **Check Bluetooth Module:**
   - Verify TX/RX connections (they should be correct, not crossed)
   - Ensure voltage divider is correct
   - Try disconnecting and reconnecting

4. **Test Communication:**
   - Use Serial Monitor to check if commands arrive
   - Commands should show in Serial Monitor when sent from app

### Problem 3: Connection Drops Frequently

**Symptoms:**
- Connects but disconnects after few seconds
- Unstable connection

**Solutions:**
1. **Power Issues:**
   - Use external 5V power supply (not just USB)
   - Check for loose connections
   - Ensure stable power to HC-05/06

2. **Distance:**
   - Keep phone within 5-10 meters
   - Remove obstacles between phone and HC-05/06
   - HC-05 has better range than HC-06

3. **Interference:**
   - Move away from WiFi routers
   - Turn off other Bluetooth devices
   - Avoid metal objects nearby

### Problem 4: App Crashes or Permissions Error

**Symptoms:**
- App crashes when opening IOT screen
- "Permission denied" errors

**Solutions:**
1. **Grant Permissions:**
   - Go to Android Settings → Apps → Washtron
   - Permissions → Enable all Bluetooth permissions
   - Enable Location (required for Bluetooth scan)

2. **Android Version:**
   - Android 12+: Requires BLUETOOTH_SCAN and BLUETOOTH_CONNECT
   - Android 11 and below: Requires BLUETOOTH and BLUETOOTH_ADMIN
   - All versions: Requires ACCESS_FINE_LOCATION

3. **Reinstall App:**
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

### Problem 5: HC-05/06 Won't Pair

**Symptoms:**
- Pairing fails
- Wrong PIN error

**Solutions:**
1. **Default PINs:**
   - Try: `1234`, `0000`, `123456`
   - Check HC-05/06 documentation

2. **Reset Pairing:**
   - Forget device in Android Bluetooth settings
   - Restart phone
   - Try pairing again

3. **AT Commands (Advanced):**
   ```
   AT+PSWD=1234    // Set PIN to 1234
   AT+NAME=WashtronIOT  // Set custom name
   AT+BAUD4        // Set baud to 9600
   ```

### Problem 6: Voltage Divider Issues

**Symptoms:**
- Bluetooth module not responding
- Erratic behavior

**Solutions:**
1. **Verify Resistor Values:**
   - Use multimeter to measure: 1KΩ and 2KΩ
   - Color codes:
     - 1KΩ: Brown-Black-Red
     - 2KΩ: Red-Black-Red

2. **Measure Voltage:**
   - At HC-05/06 RXD pin should be ~3.3V
   - If higher, check divider circuit

3. **Alternative:**
   - Use a 3.3V logic level converter module
   - Safer and more reliable

---

## 🚀 Advanced Features

### 1. Control Multiple LEDs

Modify Arduino code to control multiple LEDs:
```cpp
const int LED1_PIN = 13;
const int LED2_PIN = 12;
const int LED3_PIN = 11;

// Commands:
// '1' = LED1 ON, '0' = LED1 OFF
// '3' = LED2 ON, '2' = LED2 OFF
// '5' = LED3 ON, '4' = LED3 OFF
// '9' = ALL ON, '8' = ALL OFF
```

See alternative version in `led_bluetooth_control.ino`

### 2. Control AC Appliances

**Warning:** High voltage is dangerous! Take proper precautions.

Use a **5V Relay Module**:
```
Arduino Pin → Relay IN
Relay VCC → Arduino 5V
Relay GND → Arduino GND
Relay COM → AC Live Wire
Relay NO → Appliance
```

Replace LED control code with relay control.

### 3. Add More Sensors

#### Temperature Sensor (DHT11/DHT22):
```cpp
#include <DHT.h>
#define DHTPIN 7
#define DHTTYPE DHT11
DHT dht(DHTPIN, DHTTYPE);

// In loop(), read and send temperature
float temp = dht.readTemperature();
Serial.print("Temp:");
Serial.println(temp);
```

#### Motion Sensor (PIR):
```cpp
const int PIR_PIN = 8;
boolean motion = digitalRead(PIR_PIN);
if(motion) Serial.println("Motion detected!");
```

### 4. Customize App UI

Modify `lib/screens/iot/iot_control_screen.dart`:
- Add more control buttons
- Create custom LED patterns
- Add temperature/sensor displays
- Implement scheduling/automation

### 5. Battery Operation

For portable Arduino:
- Use 9V battery with battery clip
- Connect to Arduino VIN and GND
- Ensure 5V regulator can handle current
- Or use 4× AA batteries (6V) to VIN

### 6. Extended Range

- HC-05 has better range (~10m) than HC-06
- Use external antenna HC-05 variant
- Consider Bluetooth 5.0 modules for 100m+ range
- Or use WiFi modules (ESP8266/ESP32) for internet control

### 7. Cloud Integration (Future)

Connect ESP32 instead of Arduino:
- Use WiFi for internet connectivity
- Integrate with Firebase
- Control from anywhere in the world
- Add voice control via Google Assistant

---

## 📊 System Architecture

```
┌─────────────────┐
│  Washtron App   │
│   (Flutter)     │
└────────┬────────┘
         │ Bluetooth
         │ (flutter_blue_plus)
         ↓
┌─────────────────┐
│   HC-05/HC-06   │
│ Bluetooth Module│
└────────┬────────┘
         │ Serial (TX/RX)
         │ 9600 baud
         ↓
┌─────────────────┐
│  Arduino Uno    │
│   (ATmega328)   │
└────────┬────────┘
         │ Digital Pin 13
         ↓
┌─────────────────┐
│   LED Circuit   │
│ (with resistor) │
└─────────────────┘
```

---

## 📝 Command Protocol

### Current Implementation:
| Command | Action      | Response     |
|---------|-------------|--------------|
| `1`     | LED ON      | "LED: ON"    |
| `0`     | LED OFF     | "LED: OFF"   |

### Extended Protocol (for future):
| Command | Action           |
|---------|------------------|
| `A`     | Toggle LED       |
| `B`     | Blink 3 times    |
| `S`     | Get status       |
| `T`     | Get temperature  |
| `R`     | Reset/Reboot     |

---

## 🔒 Security Notes

1. **Bluetooth Security:**
   - Change default PIN: `AT+PSWD=your_pin`
   - Rename device: `AT+NAME=custom_name`
   - Disable visibility after pairing

2. **Physical Security:**
   - Keep Arduino in enclosure
   - Secure all connections
   - Use proper insulation for high voltage

3. **App Security:**
   - Implement device authentication
   - Add user-specific device pairing
   - Log all IOT commands

---

## 📚 Additional Resources

### Documentation:
- Arduino: https://www.arduino.cc/reference/en/
- Flutter Blue Plus: https://pub.dev/packages/flutter_blue_plus
- HC-05 Datasheet: Search "HC-05 datasheet PDF"
- HC-06 Datasheet: Search "HC-06 datasheet PDF"

### Video Tutorials:
- Search YouTube: "HC-05 Arduino tutorial"
- Search YouTube: "Flutter Bluetooth Arduino"

### Community Support:
- Arduino Forum: https://forum.arduino.cc/
- Flutter Discord: https://discord.gg/flutter
- Stack Overflow: Tag [arduino] [flutter]

---

## ✅ Quick Reference Checklist

### Hardware Setup:
- [ ] Arduino board
- [ ] HC-05/HC-06 module
- [ ] LED with 220Ω resistor
- [ ] Voltage divider (1KΩ + 2KΩ)
- [ ] All connections secure
- [ ] Power supply (USB or battery)

### Software Setup:
- [ ] Arduino IDE installed
- [ ] Code uploaded to Arduino
- [ ] Serial Monitor test passed
- [ ] Flutter dependencies installed
- [ ] App built and running
- [ ] Bluetooth permissions granted

### Testing:
- [ ] HC-05/06 LED blinking
- [ ] Device visible in Bluetooth scan
- [ ] Successful pairing
- [ ] Connection established in app
- [ ] LED responds to ON command
- [ ] LED responds to OFF command

---

## 🎉 Success!

If you've reached this point and everything works, congratulations! You've successfully integrated IOT into your Washtron app.

### What's Next?
- Experiment with different LED colors
- Add more sensors (temperature, humidity, motion)
- Control other devices (motors, relays, buzzers)
- Implement automation and scheduling
- Share your project with the community!

---

## 📞 Support

If you encounter issues not covered in this guide:

1. **Check Documentation:**
   - Re-read relevant sections
   - Check wiring diagrams carefully

2. **Debug Systematically:**
   - Test each component individually
   - Use Serial Monitor for Arduino debugging
   - Check app logs for errors

3. **Ask for Help:**
   - Arduino Forum
   - Flutter Community
   - GitHub Issues

---

**Created for Washtron App**  
**Version:** 1.0  
**Last Updated:** December 2024  

Happy Building! 🚀
