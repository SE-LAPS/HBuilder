# HBuilder - Quick Start Checklist

Use this checklist to get your app running in 20 minutes!

## ☑️ Pre-Requirements

- [ ] Flutter SDK installed (version 3.9+)
- [ ] Android Studio or VS Code with Flutter extension
- [ ] Android device or emulator
- [ ] Google account for Firebase
- [ ] Internet connection

---

## 🔥 Step 1: Firebase Setup (10 minutes)

### Create Firebase Project
- [ ] Go to https://console.firebase.google.com/
- [ ] Click "Add project"
- [ ] Name it: **HBuilder**
- [ ] Disable Google Analytics (optional)
- [ ] Click "Create project"

### Add Android App
- [ ] Click Android icon
- [ ] Package name: `com.hbuilder.hbuilder`
- [ ] App nickname: **HBuilder**
- [ ] Click "Register app"
- [ ] Download `google-services.json`
- [ ] Move file to: `H:\HBuilder\android\app\google-services.json`
- [ ] Click "Next" through remaining steps

### Enable Authentication
- [ ] In Firebase Console, go to "Authentication"
- [ ] Click "Get started"
- [ ] Click "Email/Password"
- [ ] Enable the first switch (Email/Password)
- [ ] Click "Save"

### Create Firestore Database
- [ ] In Firebase Console, go to "Firestore Database"
- [ ] Click "Create database"
- [ ] Select "Start in production mode"
- [ ] Choose location (e.g., us-central1)
- [ ] Click "Enable"

### Add Sample Service Center Data
- [ ] In Firestore, click "Start collection"
- [ ] Collection ID: `serviceCenters`
- [ ] Click "Next"
- [ ] Document ID: (Auto-ID)
- [ ] Add fields (copy from FIREBASE_DATA_STRUCTURE.md):
  ```
  name: "Downtown Car Wash"
  imageUrl: "https://images.unsplash.com/photo-1601362840469-51e4d8d58785?w=800"
  location: "123 Main Street, Downtown"
  latitude: 40.7128 (number)
  longitude: -74.0060 (number)
  businessHours: "08:00 - 20:00"
  contactNumber: "+1-555-0101"
  isInBusiness: true (boolean)
  description: "Professional car wash service"
  membershipCards: (array) - Add 3 maps with fields from docs
  ```
- [ ] Click "Save"
- [ ] Add 2-3 more service centers with different locations

### Update Security Rules
- [ ] In Firestore, go to "Rules" tab
- [ ] Copy rules from FIREBASE_DATA_STRUCTURE.md
- [ ] Click "Publish"

---

## 💻 Step 2: Flutter Setup (5 minutes)

### Install Dependencies
- [ ] Open terminal/PowerShell
- [ ] Navigate to project: `cd H:\HBuilder`
- [ ] Run: `flutter pub get`
- [ ] Wait for completion

### Configure Firebase (Choose One)

**Option A - FlutterFire CLI** (Recommended):
- [ ] Run: `dart pub global activate flutterfire_cli`
- [ ] Run: `firebase login` (if not logged in)
- [ ] Run: `flutterfire configure`
- [ ] Select your Firebase project
- [ ] Select platforms: Android
- [ ] Confirm

**Option B - Manual**:
- [ ] Edit `lib/firebase_options.dart`
- [ ] Get values from Firebase Console → Project Settings
- [ ] Replace placeholders with your values

---

## 🚀 Step 3: Run the App (3 minutes)

### Connect Device
- [ ] Connect Android phone via USB
- [ ] Enable USB Debugging on phone
- OR
- [ ] Start Android emulator

### Launch App
- [ ] In terminal: `flutter devices`
- [ ] Confirm device is listed
- [ ] Run: `flutter run`
- [ ] Wait for build and installation

---

## ✅ Step 4: Test Features (10 minutes)

### Onboarding
- [ ] View 3 onboarding screens
- [ ] Test swipe navigation
- [ ] Test "Skip" button

### Sign Up
- [ ] Click "Sign Up"
- [ ] Fill in details:
  - Name: Your Name
  - Email: test@example.com
  - Password: test123456
- [ ] Click "Sign Up"
- [ ] Verify successful login

### Home Screen
- [ ] View auto-rotating banner (wait 3 seconds)
- [ ] See service centers (may show "No service centers" if none added)

### Grant Permissions
- [ ] When prompted, grant Location permission
- [ ] Service centers should sort by distance

### Service Center Details
- [ ] Tap on a service center
- [ ] View details and images
- [ ] Swipe through membership cards
- [ ] Test "Scan Code" button

### QR Scanner
- [ ] When prompted, grant Camera permission
- [ ] Point at any QR code
- [ ] Verify scan works
- [ ] Test flashlight toggle

### Card Purchase
- [ ] Go back to service center
- [ ] Tap "Buy Now" on a card
- [ ] Verify purchase flow
- [ ] Complete purchase
- [ ] Check Purchase History in Profile

### Add Vehicle
- [ ] Tap "Add Vehicle" button from home
- [ ] Fill vehicle details
- [ ] Submit
- [ ] Verify in "My Vehicles" list
- [ ] Test delete

### Franchise Application
- [ ] Tap "Apply for Accession"
- [ ] View company info
- [ ] Fill application form
- [ ] Submit
- [ ] Verify success message

### Profile
- [ ] Tap Profile icon (bottom right)
- [ ] View user details
- [ ] Check Purchase History
- [ ] Open Settings
- [ ] View About App
- [ ] Test Sign Out

---

## 🎉 Success Criteria

Your app is working correctly if:
- [x] Can sign up and sign in
- [x] Service centers display with images
- [x] Location permission granted
- [x] QR scanner works
- [x] Can purchase cards
- [x] Can add vehicles
- [x] Can submit franchise application
- [x] Profile shows user info
- [x] Purchase history displays
- [x] All navigation works

---

## 🐛 Troubleshooting

### "Service Centers Not Showing"
→ Add data to Firestore (Step 1)

### "Firebase Error"
→ Check google-services.json location

### "Camera Not Working"
→ Test on physical device, not emulator

### "Location Not Updating"
→ Enable location on device, test outdoors

### "Build Failed"
→ Run: `flutter clean && flutter pub get && flutter run`

---

## 📸 Screenshot Checklist

Test these screens and take screenshots:
- [ ] Onboarding (3 screens)
- [ ] Sign Up screen
- [ ] Home with banners
- [ ] Service center list
- [ ] Service center details
- [ ] Membership cards
- [ ] QR Scanner
- [ ] Card purchase flow
- [ ] Add vehicle
- [ ] Franchise application
- [ ] Profile screen
- [ ] Purchase history

---

## 🎯 Next Steps

After successful testing:
1. [ ] Add more service centers to Firestore
2. [ ] Customize banner images
3. [ ] Update company information
4. [ ] Test on multiple devices
5. [ ] Build release APK: `flutter build apk --release`
6. [ ] Share with testers

---

## 📱 Device Requirements

**Minimum:**
- Android 5.0 (API 21)
- 100 MB storage
- Camera (for QR scanning)
- GPS (for location features)
- Internet connection

**Recommended:**
- Android 8.0 or higher
- 200 MB storage
- Good camera
- Accurate GPS

---

## ⏱️ Time Estimates

- Firebase Setup: **10 minutes**
- Flutter Setup: **5 minutes**
- Run App: **3 minutes**
- Testing: **10 minutes**
- **Total: ~30 minutes**

---

## ✅ Completion

Once all checkboxes are complete, your HBuilder app is:
- ✅ Fully functional
- ✅ Connected to Firebase
- ✅ Ready for testing
- ✅ Ready for deployment

**Congratulations! You're ready to launch! 🎉🚀**

---

## 📞 Need Help?

Refer to these files:
- **SETUP_GUIDE.md** - Detailed setup
- **FIREBASE_DATA_STRUCTURE.md** - Database structure
- **COMMANDS.md** - All commands
- **README.md** - Full documentation
- **PROJECT_SUMMARY.md** - Feature overview

---

**Pro Tip**: Keep this checklist open during setup and check off items as you complete them!



