# 🚀 Easy Database Setup - 3 Simple Methods

The Dart script had Flutter compilation errors. Here are **3 easier ways** to add service centers to your database:

---

## ✅ **Method 1: Manual Entry in Firebase Console** (5 minutes per center)

### Step-by-Step:

1. Go to [Firebase Console - Firestore](https://console.firebase.google.com/project/hbuilder-ca089/firestore)

2. Click **"Start collection"**
   - Collection ID: `serviceCenters`
   - Click "Next"

3. **Add Document** (use Auto-ID)

4. **Add these fields** (click "Add field" for each):

   | Field | Type | Value |
   |-------|------|-------|
   | name | string | Downtown Premium Wash |
   | imageUrl | string | https://images.unsplash.com/photo-1601362840469-51e4d8d58785?w=800 |
   | location | string | 123 Main Street, Downtown, NY 10001 |
   | latitude | number | 40.7128 |
   | longitude | number | -74.0060 |
   | businessHours | string | 08:00 - 20:00 |
   | contactNumber | string | +1-555-0101 |
   | isInBusiness | boolean | true |
   | description | string | Premium car wash service with modern equipment |

5. **Add membershipCards array**:
   - Field name: `membershipCards`
   - Type: **array**
   - Click the array to expand
   - Click "Add item" 3 times
   - For each item, select type: **map**
   
   **Item 0 (Monthly Card):**
   ```
   type: "monthly" (string)
   name: "Monthly Card" (string)
   days: 30 (number)
   price: 159 (number)
   imageUrl: "" (string)
   ```
   
   **Item 1 (Seasonal Card):**
   ```
   type: "seasonal" (string)
   name: "Seasonal Card" (string)
   days: 90 (number)
   price: 299 (number)
   originalPrice: 1080 (number)
   imageUrl: "" (string)
   ```
   
   **Item 2 (Annual Card):**
   ```
   type: "annual" (string)
   name: "Annual Card" (string)
   days: 360 (number)
   price: 498 (number)
   originalPrice: 6220 (number)
   imageUrl: "" (string)
   ```

6. Click "Save"

7. Repeat for more service centers (data below)

---

## ✅ **Method 2: Using Firestore REST API** (Fastest - 30 seconds)

### PowerShell Script:

```powershell
# Get your project ID
$PROJECT_ID = "hbuilder-ca089"

# Service Center 1
$body = @{
    fields = @{
        name = @{ stringValue = "Downtown Premium Wash" }
        imageUrl = @{ stringValue = "https://images.unsplash.com/photo-1601362840469-51e4d8d58785?w=800" }
        location = @{ stringValue = "123 Main Street, Downtown, NY 10001" }
        latitude = @{ doubleValue = 40.7128 }
        longitude = @{ doubleValue = -74.0060 }
        businessHours = @{ stringValue = "08:00 - 20:00" }
        contactNumber = @{ stringValue = "+1-555-0101" }
        isInBusiness = @{ booleanValue = $true }
        description = @{ stringValue = "Premium car wash service" }
    }
} | ConvertTo-Json -Depth 10

Invoke-RestMethod -Uri "https://firestore.googleapis.com/v1/projects/$PROJECT_ID/databases/(default)/documents/serviceCenters" -Method Post -Body $body -ContentType "application/json"
```

*(This requires authentication - easier to use Method 1 or 3)*

---

## ✅ **Method 3: Copy-Paste Template** (Easiest for multiple centers)

I've created a **ready-to-use data file**: `service_centers_import.json`

### Quick Add via Firebase Console:

For each service center in the JSON file:

1. Go to Firestore → serviceCenters collection
2. Click "Add document"
3. Use Auto-ID
4. Copy the data structure from the JSON for each center
5. Add fields manually (unfortunately Firebase doesn't support JSON import directly in console)

---

## 📋 **Quick Reference Data for Manual Entry**

### Service Center 1: Downtown Premium Wash
- **Location**: 123 Main Street, Downtown, NY 10001
- **Coordinates**: 40.7128, -74.0060
- **Hours**: 08:00 - 20:00
- **Phone**: +1-555-0101
- **Status**: Open
- **Image**: https://images.unsplash.com/photo-1601362840469-51e4d8d58785?w=800

### Service Center 2: Uptown Auto Spa
- **Location**: 456 Park Avenue, Uptown, NY 10021
- **Coordinates**: 40.7489, -73.9680
- **Hours**: 07:00 - 19:00
- **Phone**: +1-555-0102
- **Status**: Open
- **Image**: https://images.unsplash.com/photo-1520340356584-f9917d1eea6f?w=800

### Service Center 3: Brooklyn Car Care
- **Location**: 789 Brooklyn Avenue, Brooklyn, NY 11201
- **Coordinates**: 40.6782, -73.9442
- **Hours**: 06:00 - 22:00
- **Phone**: +1-555-0103
- **Status**: Open
- **Image**: https://images.unsplash.com/photo-1591291621164-2c6367723315?w=800

### Service Center 4: Queens Express Wash
- **Location**: 321 Queens Boulevard, Queens, NY 11375
- **Coordinates**: 40.7282, -73.7949
- **Hours**: 07:00 - 21:00
- **Phone**: +1-555-0104
- **Status**: Open
- **Image**: https://images.unsplash.com/photo-1607860108855-64acf2078ed9?w=800

### Service Center 5: Bronx Auto Detailing
- **Location**: 555 Grand Concourse, Bronx, NY 10451
- **Coordinates**: 40.8448, -73.9252
- **Hours**: 08:00 - 18:00
- **Phone**: +1-555-0105
- **Status**: Open
- **Image**: https://images.unsplash.com/photo-1619642751034-765dfdf7c58e?w=800

### Service Center 6: Staten Island Shine
- **Location**: 777 Victory Boulevard, Staten Island, NY 10301
- **Coordinates**: 40.6437, -74.0831
- **Hours**: 09:00 - 19:00
- **Phone**: +1-555-0106
- **Status**: Open
- **Image**: https://images.unsplash.com/photo-1632823469850-1b4942f0d7d5?w=800

### Service Center 7: Midtown Express Clean
- **Location**: 888 5th Avenue, Midtown, NY 10022
- **Coordinates**: 40.7614, -73.9776
- **Hours**: 06:00 - 23:00
- **Phone**: +1-555-0107
- **Status**: Open
- **Image**: https://images.unsplash.com/photo-1606016159991-88421e3e93d2?w=800

### Service Center 8: Harlem Wash & Shine
- **Location**: 999 Malcolm X Boulevard, Harlem, NY 10026
- **Coordinates**: 40.8075, -73.9525
- **Hours**: 07:00 - 20:00
- **Phone**: +1-555-0108
- **Status**: **Closed** (for testing)
- **Image**: https://images.unsplash.com/photo-1588195538326-c5b1e5b94ef3?w=800

---

## ⏱️ **Time Estimates**

- **Method 1 (Manual)**: ~5 minutes per service center = 40 minutes for 8
- **Method 3 (with template)**: ~3 minutes per service center = 24 minutes for 8
- **Just add 1-2 for testing**: ~10 minutes

---

## 💡 **Recommended Approach**

**For quick testing:**
1. Add just 1-2 service centers manually (10 minutes)
2. Test the app to make sure everything works
3. Add more later if needed

**For complete setup:**
1. Use Method 1 (Manual entry) 
2. Follow the step-by-step guide above
3. Use the Quick Reference Data for values
4. Start with 3 centers, then add more

---

## ✅ **Verification**

After adding service centers:

1. Go to [Firestore Console](https://console.firebase.google.com/project/hbuilder-ca089/firestore)
2. You should see: `serviceCenters` collection
3. It should have 8 documents (or however many you added)
4. Each document should have all fields including `membershipCards` array

---

## 🚀 **Then Run Your App**

```bash
flutter run
```

The service centers will appear in your app!

---

## 🎯 **Why the Dart Script Failed**

The script tried to import Flutter UI libraries which can't be used in standalone Dart scripts. Firebase Admin SDK would work, but requires Node.js or complex setup. Manual entry is actually faster for small datasets!

---

**Recommendation**: Add 2-3 service centers now to test, then add more later! 🚀



