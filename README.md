# HBuilder - Car Wash Service Management App

A comprehensive Flutter application for managing car wash services with Firebase integration. Features include finding nearby service centers, purchasing membership cards, QR/Barcode scanning, vehicle management, and franchise applications.

## 🎨 Features

### Authentication
- ✅ Modern onboarding screens with smooth page indicators
- ✅ Sign In with Firebase Authentication
- ✅ Sign Up with user profile creation
- ✅ Secure authentication with email/password

### Home Page
- ✅ Auto-rotating image banner carousel
- ✅ Quick action buttons (Card Purchase, Add Vehicle, Apply for Accession)
- ✅ **Closest to Me** section with distance calculation
- ✅ **Common Washing Stations** section
- ✅ Real-time location-based sorting

### Service Center Details
- ✅ Full-screen image banner
- ✅ Business hours, location, and contact information
- ✅ Horizontal scrolling membership cards (Monthly, Seasonal, Annual)
- ✅ Tap-to-call functionality
- ✅ QR/Barcode scanner integration

### Membership Cards
- ✅ **Monthly Card**: 30 days - $159
- ✅ **Seasonal Card**: 90 days - $299 (was $1080)
- ✅ **Annual Card**: 360 days - $498 (was $6220)
- ✅ Color-coded cards with beautiful gradient designs

### Card Purchase Flow
- ✅ Service center selection
- ✅ Membership card selection with pricing
- ✅ Applicable stores list with distance and call options
- ✅ Purchase notice and terms
- ✅ Dynamic "Recharge Now" button

### QR/Barcode Scanner
- ✅ Real-time QR code and barcode scanning
- ✅ Torch/flashlight toggle
- ✅ Camera flip functionality
- ✅ Modern scanning UI with corner indicators

### Vehicle Management
- ✅ Add vehicle details (name, number, type, brand, model, color)
- ✅ View all user vehicles
- ✅ Delete vehicles with confirmation

### Franchise Application
- ✅ Company information display
- ✅ Working hours and contact details
- ✅ Application form (name, contact, city, message)
- ✅ Submission to Firestore

### Profile & Settings
- ✅ User profile display
- ✅ Purchase history with timestamps
- ✅ Settings (notifications, location, language)
- ✅ About app section
- ✅ Help & support
- ✅ Sign out functionality

## 🎨 Design

- **Theme Colors**: Orange (#FF6B00), White (#FFFFFF), Black (#000000)
- **Modern UI/UX**: Material Design with custom styling
- **Responsive**: Adapts to different screen sizes
- **Icons**: Material Icons with custom color schemes

## 📱 Tech Stack

- **Framework**: Flutter 3.9+
- **Backend**: Firebase (Authentication, Firestore)
- **State Management**: Provider
- **Key Packages**:
  - `firebase_core` & `firebase_auth` - Authentication
  - `cloud_firestore` - Database
  - `mobile_scanner` - QR/Barcode scanning
  - `geolocator` - Location services
  - `carousel_slider` - Image banners
  - `cached_network_image` - Image caching
  - `url_launcher` - Phone calls and URLs

## 🚀 Getting Started

### Prerequisites

1. **Flutter SDK** (3.9.2 or higher)
   ```bash
   flutter --version
   ```

2. **Firebase Account**
   - Create a project at [Firebase Console](https://console.firebase.google.com/)

3. **Android Studio** or **VS Code** with Flutter extensions

### Setup Instructions

#### 1. Clone the Repository
```bash
cd H:\HBuilder
# Project is already here
```

#### 2. Install Dependencies
```bash
flutter pub get
```

#### 3. Configure Firebase

##### Option A: Using FlutterFire CLI (Recommended)
```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Login to Firebase
firebase login

# Configure Firebase for your project
flutterfire configure
```

##### Option B: Manual Configuration
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project or select existing
3. Add an Android app:
   - **Package name**: `com.hbuilder.hbuilder`
   - Download `google-services.json`
   - Place it in `android/app/`
4. Enable Authentication:
   - Go to Authentication > Sign-in method
   - Enable **Email/Password**
5. Create Firestore Database:
   - Go to Firestore Database
   - Create database in production mode
   - Start with these collections:
     - `users` - User profiles
     - `serviceCenters` - Service center data
     - `vehicles` - User vehicles
     - `franchiseApplications` - Franchise applications
     - `purchaseHistory` - Card purchases

6. Update `lib/firebase_options.dart` with your Firebase config values

#### 4. Set Up Firestore Data Structure

Add sample service centers to Firestore:

**Collection**: `serviceCenters`

**Document 1**:
```json
{
  "name": "Premium Car Wash Center",
  "imageUrl": "https://images.unsplash.com/photo-1601362840469-51e4d8d58785?w=800",
  "location": "123 Main Street, Downtown",
  "latitude": 40.7128,
  "longitude": -74.0060,
  "businessHours": "08:00 - 20:00",
  "contactNumber": "+1-555-0101",
  "isInBusiness": true,
  "description": "Premium car wash service with experienced staff and modern equipment.",
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

Add more service centers with different locations for testing.

#### 5. Android Configuration

The app is already configured with:
- ✅ Internet permission
- ✅ Camera permission
- ✅ Location permissions (Fine & Coarse)
- ✅ minSdk 21 (Android 5.0+)

#### 6. Run the App

```bash
# Check connected devices
flutter devices

# Run on connected device
flutter run

# Run in release mode
flutter run --release
```

## 📧 Firebase Setup for HBuilder@gmail.com

To set up the specific email mentioned:

1. Go to Firebase Console > Authentication
2. Add a test user manually:
   - Email: `HBuilder@gmail.com`
   - Password: Your chosen password
3. Or register through the app's Sign Up screen

## 🗂️ Project Structure

```
lib/
├── config/
│   └── theme.dart                 # App theme configuration
├── models/
│   ├── user_model.dart           # User data model
│   ├── service_center_model.dart # Service center & membership card models
│   └── vehicle_model.dart        # Vehicle data model
├── providers/
│   ├── auth_provider.dart        # Authentication state management
│   └── location_provider.dart    # Location services
├── services/
│   └── firestore_service.dart    # Firestore database operations
├── screens/
│   ├── onboarding/
│   │   └── onboarding_screen.dart
│   ├── auth/
│   │   ├── sign_in_screen.dart
│   │   └── sign_up_screen.dart
│   ├── main/
│   │   └── main_screen.dart      # Bottom navigation
│   ├── home/
│   │   └── home_screen.dart      # Main home page
│   ├── service_center/
│   │   └── service_center_detail_screen.dart
│   ├── scan/
│   │   └── scan_screen.dart      # QR/Barcode scanner
│   ├── card_purchase/
│   │   └── card_purchase_screen.dart
│   ├── vehicle/
│   │   └── add_vehicle_screen.dart
│   ├── franchise/
│   │   └── franchise_application_screen.dart
│   └── profile/
│       ├── profile_screen.dart
│       ├── history_screen.dart
│       ├── settings_screen.dart
│       └── about_screen.dart
├── firebase_options.dart          # Firebase configuration
└── main.dart                      # App entry point
```

## 🔧 Configuration Files

### `pubspec.yaml`
All necessary dependencies are already added:
- Firebase packages
- UI packages (carousel, smooth indicators)
- Scanner packages
- Location services
- Image handling

### `android/app/build.gradle.kts`
- minSdk: 21
- multidex enabled
- Kotlin support

### `android/app/src/main/AndroidManifest.xml`
- All required permissions added
- Camera feature declarations

## 📸 Screenshots & Features

### Onboarding (3 screens)
1. Find Car Wash Services
2. Membership Cards
3. Easy Scanning

### Bottom Navigation (3 tabs)
1. **Home** - Main screen with banners and service centers
2. **Scan** - QR/Barcode scanner
3. **Profile** - User profile and settings

### Home Quick Actions
1. **Card Purchase** - Buy membership cards
2. **Add Vehicle** - Manage your vehicles
3. **Apply for Accession** - Franchise application

## 🎯 Usage

### First Time Setup
1. Launch the app
2. View onboarding screens
3. Sign Up with email/password
4. Grant location permission for nearby centers
5. Grant camera permission for scanning

### Purchasing a Card
1. Navigate to Home
2. Browse service centers sorted by distance
3. Tap on a service center
4. View membership cards
5. Tap "Buy Now"
6. Confirm selection and purchase

### Scanning QR Codes
1. Tap Scan icon in bottom navigation
2. Grant camera permission if needed
3. Point camera at QR/Barcode
4. View scan results

### Adding a Vehicle
1. Tap "Add Vehicle" button or menu
2. Fill in vehicle details
3. Submit to save
4. View in "My Vehicles" list

## 🔐 Security Notes

- Firebase Authentication handles secure password storage
- Firestore rules should be configured for production
- API keys in `firebase_options.dart` should be kept secure
- Consider environment variables for production

## 🌐 Firestore Security Rules

Add these rules in Firebase Console > Firestore > Rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Service centers are public read, admin write
    match /serviceCenters/{centerId} {
      allow read: if true;
      allow write: if false; // Only admins via Firebase console
    }
    
    // Vehicles owned by users
    match /vehicles/{vehicleId} {
      allow read, write: if request.auth != null && 
        resource.data.userId == request.auth.uid;
    }
    
    // Purchase history
    match /purchaseHistory/{purchaseId} {
      allow read: if request.auth != null && 
        resource.data.userId == request.auth.uid;
      allow create: if request.auth != null;
    }
    
    // Franchise applications
    match /franchiseApplications/{applicationId} {
      allow create: if request.auth != null;
      allow read: if request.auth != null && 
        resource.data.userId == request.auth.uid;
    }
  }
}
```

## 🐛 Troubleshooting

### Firebase Connection Issues
- Verify `google-services.json` is in `android/app/`
- Check Firebase project configuration
- Ensure internet permission is granted

### Camera Not Working
- Check camera permissions in Android settings
- Verify camera permission in AndroidManifest.xml
- Test on physical device (emulators may have issues)

### Location Not Working
- Enable location services on device
- Grant location permission when prompted
- Check location permission in AndroidManifest.xml

### Build Errors
```bash
# Clean build
flutter clean
flutter pub get

# Rebuild
flutter run
```

## 📝 TODO / Future Enhancements

- [ ] Add payment gateway integration
- [ ] Implement push notifications
- [ ] Add social authentication (Google, Facebook)
- [ ] Multi-language support
- [ ] Dark mode theme
- [ ] Loyalty points system
- [ ] In-app chat support
- [ ] Vehicle service history
- [ ] Appointment booking

## 📄 License

This project is created for HBuilder Car Wash Service Management.

## 👨‍💻 Developer

Created with Flutter & Firebase for modern car wash service management.

## 🆘 Support

For support:
- Email: support@hbuilder.com
- Phone: +1 (555) 123-4567

---

**Version**: 1.0.0  
**Last Updated**: October 2025
