# IOT Quick Start Guide

## 5-Minute Setup for LED Control

### What You Need
- Arduino Uno/Nano
- HC-05 or HC-06 Bluetooth Module
- LED + 220Ω Resistor
- Jumper wires
- USB cable

---

## Step 1: Wire Everything (5 minutes)

### HC-05/HC-06 Connections:
```
HC-05/06 → Arduino
VCC  → 5V
GND  → GND
TXD  → RX (Pin 0)
RXD  → TX (Pin 1) via voltage divider*
```

**Voltage Divider (IMPORTANT):**
```
Arduino TX Pin 1 → [1KΩ resistor] → HC-05/06 RXD
                                  ↓
                              [2KΩ resistor]
                                  ↓
                                 GND
```

### LED Connection:
```
Arduino Pin 13 → [220Ω resistor] → LED (+) → LED (-) → GND
```

---

## Step 2: Upload Arduino Code (3 minutes)

1. Open Arduino IDE
2. Load file: `arduino/led_bluetooth_control.ino`
3. Select Board: **Tools → Board → Arduino Uno**
4. Select Port: **Tools → Port → COM3** (or your port)
5. Click **Upload** (→ button)
6. Wait for "Done uploading"

**Test:** Open Serial Monitor (9600 baud)
- Type `1` → LED should turn ON
- Type `0` → LED should turn OFF

---

## Step 3: Run the App (2 minutes)

1. Connect Android phone via USB
2. In terminal run:
   ```
   flutter pub get
   flutter run
   ```
3. Grant Bluetooth permissions when prompted

---

## Step 4: Connect and Control (2 minutes)

1. Tap **"Test IOT"** button on home screen
2. Tap **"Scan Devices"**
3. Select **HC-05** or **HC-06** from list
4. Wait for "Connected" status
5. Tap **"Turn ON"** → LED lights up! 💡
6. Tap **"Turn OFF"** → LED turns off

---

## Troubleshooting

### Can't find HC-05/06?
- Check power LED is blinking
- Pair in Android Settings first (PIN: 1234)
- Move phone closer

### LED not responding?
- Check LED polarity (long leg = +)
- Verify Pin 13 connection
- Test with Serial Monitor first

### Can't upload code?
- Check USB cable
- Select correct COM port
- Close Serial Monitor

---

## Wiring Visual Guide

```
┌───────────────────────────────────────┐
│          COMPLETE SETUP               │
├───────────────────────────────────────┤
│                                       │
│  ARDUINO UNO        HC-05/06          │
│  ┌─────────┐       ┌────────┐        │
│  │ 5V  ────┼───────┤ VCC    │        │
│  │ GND ────┼───────┤ GND    │        │
│  │ RX  ────┼───────┤ TXD    │        │
│  │ TX  ────┼──┐    │        │        │
│  │         │  │    └────────┘        │
│  │         │  │                      │
│  │         │ [1KΩ]──────┐            │
│  │         │            │            │
│  │         │         RXD (HC-05)     │
│  │         │            │            │
│  │         │         [2KΩ]           │
│  │         │            │            │
│  │ GND ────┼────────────┴────┐       │
│  │         │                 │       │
│  │ Pin13───┼───[220Ω]─── LED(+)     │
│  │         │                 │       │
│  │ GND ────┼──────────── LED(-)     │
│  └─────────┘                         │
│                                       │
└───────────────────────────────────────┘
```

---

## Default Bluetooth Settings

- **Name:** HC-05 or HC-06
- **PIN:** 1234 (or 0000)
- **Baud Rate:** 9600
- **Range:** ~10 meters

---

## Files Reference

- **Arduino Code:** `arduino/led_bluetooth_control.ino`
- **Full Guide:** `IOT_SETUP_GUIDE.md`
- **App Screen:** `lib/screens/iot/iot_control_screen.dart`
- **IOT Service:** `lib/services/iot_service.dart`

---

## Next Steps

✅ Got it working? Try these:
- Add more LEDs
- Control a buzzer
- Add temperature sensor
- Use relay for AC appliances

📖 For detailed instructions, see: **IOT_SETUP_GUIDE.md**

---

**Total Setup Time:** ~15 minutes  
**Difficulty:** Beginner-Friendly  
**Cost:** ~₹700-1500
