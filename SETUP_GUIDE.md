# HBuilder - Quick Setup Guide

## 🚀 Quick Start (5 Steps)

### Step 1: Verify Flutter Installation
```bash
flutter doctor
```
Make sure Flutter is properly installed and configured.

### Step 2: Install Dependencies
```bash
cd H:\HBuilder
flutter pub get
```

### Step 3: Set Up Firebase

#### A. Create Firebase Project
1. Go to https://console.firebase.google.com/
2. Click "Add project"
3. Enter project name: **HBuilder**
4. Follow the setup wizard

#### B. Add Android App
1. In Firebase Console, click Android icon
2. Enter package name: `com.hbuilder.hbuilder`
3. Download `google-services.json`
4. Place the file in: `android/app/google-services.json`

#### C. Enable Authentication
1. In Firebase Console → Authentication
2. Click "Get Started"
3. Enable "Email/Password" sign-in method
4. (Optional) Add test user: `HBuilder@gmail.com`

#### D. Create Firestore Database
1. In Firebase Console → Firestore Database
2. Click "Create database"
3. Start in **production mode**
4. Choose a location (e.g., us-central)

#### E. Configure Firebase in App
Option 1 - **Using FlutterFire CLI** (Recommended):
```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure
flutterfire configure
```

Option 2 - **Manual Configuration**:
Edit `lib/firebase_options.dart` with your Firebase project values from Firebase Console → Project Settings.

### Step 4: Add Sample Data to Firestore

1. In Firebase Console → Firestore Database
2. Create collection: `serviceCenters`
3. Add document with auto-ID:

```json
{
  "name": "Downtown Car Wash",
  "imageUrl": "https://images.unsplash.com/photo-1601362840469-51e4d8d58785?w=800",
  "location": "123 Main St, Downtown",
  "latitude": 40.7128,
  "longitude": -74.0060,
  "businessHours": "08:00 - 20:00",
  "contactNumber": "+1-555-0101",
  "isInBusiness": true,
  "description": "Professional car wash with modern equipment.",
  "membershipCards": [
    {
      "type": "monthly",
      "name": "Monthly Card",
      "days": 30,
      "price": 159,
      "imageUrl": ""
    },
    {
      "type": "seasonal",
      "name": "Seasonal Card",
      "days": 90,
      "price": 299,
      "originalPrice": 1080,
      "imageUrl": ""
    },
    {
      "type": "annual",
      "name": "Annual Card",
      "days": 360,
      "price": 498,
      "originalPrice": 6220,
      "imageUrl": ""
    }
  ]
}
```

Add 2-3 more service centers with different coordinates for testing location features.

### Step 5: Run the App
```bash
# Connect your Android device or start emulator
flutter devices

# Run the app
flutter run
```

## 📱 Testing the App

### Test Flow:
1. **Onboarding** - Swipe through 3 screens or skip
2. **Sign Up** - Create a new account
3. **Home** - View auto-rotating banners and service centers
4. **Location** - Grant location permission (centers will sort by distance)
5. **Service Center** - Tap on a center to view details
6. **Cards** - Swipe through membership cards
7. **Purchase** - Buy a card
8. **Scan** - Test QR scanner (grant camera permission)
9. **Vehicle** - Add a test vehicle
10. **Profile** - View purchase history

## 🎯 Common Issues & Solutions

### Issue: "google-services.json not found"
**Solution**: 
- Download from Firebase Console
- Place in `android/app/google-services.json`
- Run `flutter clean` and `flutter pub get`

### Issue: Firebase connection error
**Solution**:
- Verify package name matches: `com.hbuilder.hbuilder`
- Check `google-services.json` is in correct location
- Rebuild: `flutter clean && flutter run`

### Issue: Camera not working
**Solution**:
- Test on physical device (not emulator)
- Grant camera permission when prompted
- Check Settings → Apps → HBuilder → Permissions

### Issue: Location not updating
**Solution**:
- Enable location on device
- Grant location permission
- Test outdoors or with high accuracy mode

### Issue: No service centers showing
**Solution**:
- Add data to Firestore (see Step 4)
- Check Firestore rules allow read access
- Verify internet connection

## 🔐 Firebase Security Rules

After testing, update Firestore rules:

1. Go to Firestore → Rules
2. Replace with:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    match /serviceCenters/{centerId} {
      allow read: if true;
      allow write: if false;
    }
    
    match /vehicles/{vehicleId} {
      allow read, write: if request.auth != null && 
        resource.data.userId == request.auth.uid;
    }
    
    match /purchaseHistory/{purchaseId} {
      allow read: if request.auth != null && 
        resource.data.userId == request.auth.uid;
      allow create: if request.auth != null;
    }
    
    match /franchiseApplications/{applicationId} {
      allow create: if request.auth != null;
      allow read: if request.auth != null && 
        resource.data.userId == request.auth.uid;
    }
  }
}
```

3. Publish the rules

## 📊 Sample Coordinates for Testing

Add service centers with these coordinates:

| Name | Latitude | Longitude | Location |
|------|----------|-----------|----------|
| Downtown Wash | 40.7128 | -74.0060 | New York |
| Uptown Center | 40.7489 | -73.9680 | Manhattan |
| Brooklyn Wash | 40.6782 | -73.9442 | Brooklyn |
| Queens Station | 40.7282 | -73.7949 | Queens |

## 🎨 Color Theme

The app uses:
- **Primary (Orange)**: #FF6B00
- **Secondary (Black)**: #000000
- **Background (White)**: #FFFFFF
- **Grey**: #9E9E9E
- **Success Green**: #4CAF50

## 📦 Key Features Implemented

✅ Modern onboarding with smooth indicators  
✅ Firebase authentication (sign in/up)  
✅ Auto-rotating image carousel  
✅ Location-based service center sorting  
✅ QR/Barcode scanner with flashlight  
✅ Membership cards (3 types with gradients)  
✅ Card purchase flow  
✅ Vehicle management (add/delete)  
✅ Franchise application form  
✅ Purchase history  
✅ Settings & profile  
✅ Tap-to-call functionality  

## 🔄 Next Steps After Setup

1. **Test All Features** - Go through each screen
2. **Add More Data** - Add 5-10 service centers
3. **Customize Images** - Replace banner URLs with your images
4. **Test Permissions** - Camera, location, internet
5. **Test on Real Device** - For GPS and camera accuracy
6. **Update Firebase Rules** - For production security

## 📞 Need Help?

Check the main README.md for:
- Complete feature list
- Detailed architecture
- Troubleshooting guide
- Project structure

## 🎉 You're Ready!

Once setup is complete, you'll have a fully functional car wash management app with:
- User authentication
- Location services
- QR scanning
- Payment flow
- Profile management

**Time to setup**: ~15-20 minutes

Good luck! 🚀



