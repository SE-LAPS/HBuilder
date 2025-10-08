# Complete Firebase Setup for HBuilder App
## Connected to: hbuilderapp@gmail.com

Your Firebase project: **hbuilder-ca089 (HBuilder)**

---

## 🎯 Quick Setup (Follow These Steps)

### Step 1: Configure FlutterFire (2 minutes)

Run this command in your terminal:
```bash
flutterfire configure
```

When prompted:
1. **Select project**: Choose `hbuilder-ca089 (HBuilder)` (press Enter)
2. **Select platforms**: Choose `android` (use Space to select, Enter to confirm)
3. Wait for configuration to complete

This will:
- ✅ Create/update `lib/firebase_options.dart` automatically
- ✅ Download `android/app/google-services.json` automatically
- ✅ Configure your app for Firebase

---

### Step 2: Enable Firebase Authentication (3 minutes)

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project: **hbuilder-ca089**
3. In the left menu, click **"Authentication"**
4. Click **"Get Started"**
5. Click on **"Email/Password"** tab
6. Toggle **Enable** (first switch)
7. Click **"Save"**

#### Optional: Add Test User
1. Click **"Users"** tab
2. Click **"Add user"**
3. Email: `HBuilder@gmail.com`
4. Password: Your chosen password
5. Click **"Add user"**

---

### Step 3: Create Firestore Database (3 minutes)

1. In Firebase Console, click **"Firestore Database"** in left menu
2. Click **"Create database"**
3. Choose **"Start in production mode"**
4. Select location: **us-central1** (or closest to you)
5. Click **"Enable"**

---

### Step 4: Add Sample Service Center Data (5 minutes)

#### A. Update Security Rules First

1. In Firestore, click **"Rules"** tab
2. Replace the content with:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users collection
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Service Centers - public read, no public write
    match /serviceCenters/{centerId} {
      allow read: if true;
      allow write: if false;
    }
    
    // Vehicles
    match /vehicles/{vehicleId} {
      allow read, write: if request.auth != null && 
        resource.data.userId == request.auth.uid;
      allow create: if request.auth != null;
    }
    
    // Purchase History
    match /purchaseHistory/{purchaseId} {
      allow read: if request.auth != null && 
        resource.data.userId == request.auth.uid;
      allow create: if request.auth != null;
    }
    
    // Franchise Applications
    match /franchiseApplications/{applicationId} {
      allow create: if request.auth != null;
      allow read: if request.auth != null && 
        resource.data.userId == request.auth.uid;
    }
  }
}
```

3. Click **"Publish"**

#### B. Add Service Centers

1. In Firestore, click **"Data"** tab
2. Click **"Start collection"**
3. Collection ID: `serviceCenters`
4. Click **"Next"**

**Add Service Center 1:**
- Document ID: (use Auto-ID)
- Add these fields by clicking "Add field":

| Field Name | Type | Value |
|------------|------|-------|
| name | string | Downtown Premium Wash |
| imageUrl | string | https://images.unsplash.com/photo-1601362840469-51e4d8d58785?w=800 |
| location | string | 123 Main Street, Downtown, NY 10001 |
| latitude | number | 40.7128 |
| longitude | number | -74.0060 |
| businessHours | string | 08:00 - 20:00 |
| contactNumber | string | +1-555-0101 |
| isInBusiness | boolean | true |
| description | string | Premium car wash service with modern equipment |

5. For `membershipCards` field:
   - Type: **array**
   - Click the array to expand
   - Click **"Add item"**
   - Type: **map**
   - Add these fields for each map:

**Monthly Card (Item 0):**
```
type: "monthly" (string)
name: "Monthly Card" (string)
days: 30 (number)
price: 159 (number)
imageUrl: "" (string)
```

**Seasonal Card (Item 1):**
```
type: "seasonal" (string)
name: "Seasonal Card" (string)
days: 90 (number)
price: 299 (number)
originalPrice: 1080 (number)
imageUrl: "" (string)
```

**Annual Card (Item 2):**
```
type: "annual" (string)
name: "Annual Card" (string)
days: 360 (number)
price: 498 (number)
originalPrice: 6220 (number)
imageUrl: "" (string)
```

6. Click **"Save"**

#### Quick Add More Service Centers

Repeat the above but use these different values:

**Service Center 2 - Uptown:**
- name: `Uptown Auto Spa`
- imageUrl: `https://images.unsplash.com/photo-1520340356584-f9917d1eea6f?w=800`
- location: `456 Park Avenue, Uptown, NY 10021`
- latitude: `40.7489`
- longitude: `-73.9680`
- businessHours: `07:00 - 19:00`
- contactNumber: `+1-555-0102`
- (same membershipCards array as above)

**Service Center 3 - Brooklyn:**
- name: `Brooklyn Car Care`
- imageUrl: `https://images.unsplash.com/photo-1591291621164-2c6367723315?w=800`
- location: `789 Brooklyn Ave, Brooklyn, NY 11201`
- latitude: `40.6782`
- longitude: `-73.9442`
- businessHours: `06:00 - 22:00`
- contactNumber: `+1-555-0103`
- (same membershipCards array)

---

### Step 5: Verify Integration (2 minutes)

1. Run in terminal:
```bash
flutter pub get
```

2. Check that these files exist:
   - ✅ `lib/firebase_options.dart` (updated by FlutterFire)
   - ✅ `android/app/google-services.json` (downloaded by FlutterFire)

---

### Step 6: Run the App! 🚀

```bash
flutter run
```

---

## ✅ Verification Checklist

After running the app, verify these work:

### Authentication
- [ ] Can create new account (Sign Up)
- [ ] Can sign in with email/password
- [ ] User profile is created in Firestore
- [ ] Session persists after closing app

### Home Screen
- [ ] Banner images load and auto-rotate
- [ ] Service centers appear in the list
- [ ] Location permission requested
- [ ] Service centers sort by distance

### Service Centers
- [ ] Can tap on a service center
- [ ] Details screen loads with image
- [ ] Membership cards display horizontally
- [ ] Can swipe through cards
- [ ] "Buy Now" buttons work

### QR Scanner
- [ ] Scanner screen opens
- [ ] Camera permission requested
- [ ] Can scan QR codes
- [ ] Flashlight toggle works

### Other Features
- [ ] Can add vehicles
- [ ] Can submit franchise application
- [ ] Purchase history displays
- [ ] Profile shows user info
- [ ] Sign out works

---

## 🐛 Common Issues & Solutions

### Issue 1: "Firebase not configured"
**Solution:**
```bash
cd H:\HBuilder
flutterfire configure
# Select: hbuilder-ca089
# Select platform: android
flutter pub get
flutter run
```

### Issue 2: "No service centers showing"
**Solution:** Add at least one service center to Firestore (Step 4)

### Issue 3: "Authentication error"
**Solution:** Verify Email/Password is enabled in Firebase Console

### Issue 4: "Permission denied" in Firestore
**Solution:** Update security rules (Step 4A)

### Issue 5: Build errors
**Solution:**
```bash
flutter clean
flutter pub get
flutter run
```

---

## 📱 Testing Flow

1. **First Launch**
   - See onboarding screens
   - Skip or swipe through

2. **Sign Up**
   - Email: `test@example.com`
   - Password: `test123456`
   - Name: `Test User`

3. **Home**
   - Grant location permission
   - View service centers
   - Watch banner auto-rotate

4. **Service Center**
   - Tap a center
   - View details
   - Swipe membership cards

5. **Purchase**
   - Tap "Buy Now"
   - Complete purchase
   - Check history in Profile

6. **Scanner**
   - Grant camera permission
   - Test QR scanning

7. **Vehicle**
   - Add a test vehicle
   - View in list

8. **Profile**
   - View purchase history
   - Test settings
   - Sign out

---

## 🎯 Quick Commands

```bash
# Full setup
cd H:\HBuilder
flutterfire configure
flutter pub get
flutter run

# If errors occur
flutter clean
flutter pub get
flutter run

# Build release APK
flutter build apk --release

# Check for issues
flutter doctor
flutter analyze
```

---

## 📊 Firebase Console Quick Links

After setup, bookmark these:

1. **Project Overview**
   https://console.firebase.google.com/project/hbuilder-ca089

2. **Authentication**
   https://console.firebase.google.com/project/hbuilder-ca089/authentication/users

3. **Firestore Database**
   https://console.firebase.google.com/project/hbuilder-ca089/firestore

4. **Project Settings**
   https://console.firebase.google.com/project/hbuilder-ca089/settings/general

---

## 🎉 You're All Set!

Once you complete these steps:
- ✅ Firebase configured
- ✅ Authentication enabled
- ✅ Firestore database created
- ✅ Sample data added
- ✅ App ready to run

**Estimated time: 15 minutes total**

Now run: `flutterfire configure` and follow the prompts, then `flutter run`!

Good luck! 🚀



