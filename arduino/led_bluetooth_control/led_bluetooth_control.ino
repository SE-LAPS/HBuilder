/*
 * LED Bluetooth Control for Washtron IOT
 * 
 * This Arduino sketch enables LED control via Bluetooth (HC-05/HC-06)
 * Compatible with: Arduino Uno, Nano, Mega, etc.
 * 
 * Hardware Required:
 * - Arduino board (Uno/Nano/Mega)
 * - HC-05 or HC-06 Bluetooth Module
 * - LED bulb
 * - 220Ω Resistor
 * - Jumper wires
 * - Breadboard (optional)
 * 
 * Connections:
 * HC-05/HC-06 Module:
 *   VCC  -> Arduino 5V
 *   GND  -> Arduino GND
 *   TXD  -> Arduino RX (Pin 0)
 *   RXD  -> Arduino TX (Pin 1) via voltage divider (1K + 2K resistors)
 * 
 * LED:
 *   Anode (+)  -> Arduino Pin 13 -> 220Ω Resistor
 *   Cathode (-) -> Arduino GND
 * 
 * Protocol:
 * - Send '1' to turn LED ON
 * - Send '0' to turn LED OFF
 */

// Pin Configuration
const int LED_PIN = 13;  // Built-in LED on most Arduino boards
                          // You can use any digital pin for external LED

// Bluetooth Communication
char receivedChar;

void setup() {
  // Initialize Serial for Bluetooth communication
  // HC-05/HC-06 default baud rate is 9600
  Serial.begin(9600);
  
  // Configure LED pin as output
  pinMode(LED_PIN, OUTPUT);
  
  // Ensure LED is OFF at startup
  digitalWrite(LED_PIN, LOW);
  
  // Send startup message
  Serial.println("Washtron IOT Ready");
  Serial.println("Send '1' for ON, '0' for OFF");
}

void loop() {
  // Check if data is available from Bluetooth
  if (Serial.available() > 0) {
    // Read the incoming byte
    receivedChar = Serial.read();
    
    // Process the command
    if (receivedChar == '1') {
      // Turn LED ON
      digitalWrite(LED_PIN, HIGH);
      Serial.println("LED: ON");
    } 
    else if (receivedChar == '0') {
      // Turn LED OFF
      digitalWrite(LED_PIN, LOW);
      Serial.println("LED: OFF");
    }
    else {
      // Unknown command
      Serial.print("Unknown command: ");
      Serial.println(receivedChar);
    }
  }
}

/*
 * ALTERNATIVE VERSION: Multiple LED Control
 * 
 * If you want to control multiple LEDs, use this version:
 */

/*
// Pin Configuration for multiple LEDs
const int LED1_PIN = 13;
const int LED2_PIN = 12;
const int LED3_PIN = 11;

void setup() {
  Serial.begin(9600);
  pinMode(LED1_PIN, OUTPUT);
  pinMode(LED2_PIN, OUTPUT);
  pinMode(LED3_PIN, OUTPUT);
  digitalWrite(LED1_PIN, LOW);
  digitalWrite(LED2_PIN, LOW);
  digitalWrite(LED3_PIN, LOW);
  Serial.println("Multi-LED IOT Ready");
}

void loop() {
  if (Serial.available() > 0) {
    char cmd = Serial.read();
    
    switch(cmd) {
      case '1':  // LED 1 ON
        digitalWrite(LED1_PIN, HIGH);
        Serial.println("LED1: ON");
        break;
      case '0':  // LED 1 OFF
        digitalWrite(LED1_PIN, LOW);
        Serial.println("LED1: OFF");
        break;
      case '3':  // LED 2 ON
        digitalWrite(LED2_PIN, HIGH);
        Serial.println("LED2: ON");
        break;
      case '2':  // LED 2 OFF
        digitalWrite(LED2_PIN, LOW);
        Serial.println("LED2: OFF");
        break;
      case '5':  // LED 3 ON
        digitalWrite(LED3_PIN, HIGH);
        Serial.println("LED3: ON");
        break;
      case '4':  // LED 3 OFF
        digitalWrite(LED3_PIN, LOW);
        Serial.println("LED3: OFF");
        break;
      case '9':  // ALL ON
        digitalWrite(LED1_PIN, HIGH);
        digitalWrite(LED2_PIN, HIGH);
        digitalWrite(LED3_PIN, HIGH);
        Serial.println("ALL LEDs: ON");
        break;
      case '8':  // ALL OFF
        digitalWrite(LED1_PIN, LOW);
        digitalWrite(LED2_PIN, LOW);
        digitalWrite(LED3_PIN, LOW);
        Serial.println("ALL LEDs: OFF");
        break;
    }
  }
}
*/

/*
 * TROUBLESHOOTING:
 * 
 * 1. LED not responding:
 *    - Check wiring connections
 *    - Verify LED polarity (long leg = anode/+)
 *    - Test LED with a battery
 *    - Check resistor value (220Ω recommended)
 * 
 * 2. Cannot connect to Bluetooth:
 *    - Check HC-05/HC-06 power LED is blinking
 *    - Default pairing code is usually "1234" or "0000"
 *    - Ensure baud rate matches (9600)
 *    - Check voltage divider for RXD pin
 * 
 * 3. Bluetooth connects but no response:
 *    - Open Serial Monitor (9600 baud) to check messages
 *    - Verify TX/RX connections (they should be crossed)
 *    - Check if commands are being received
 *    - Try uploading code again
 * 
 * 4. HC-05/HC-06 Configuration:
 *    - To change baud rate or name, use AT commands
 *    - Enter AT mode: Hold button while powering on
 *    - Common AT commands:
 *      AT+NAME=WashtronIOT
 *      AT+BAUD4 (sets to 9600)
 *      AT+PSWD=1234
 */
