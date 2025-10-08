# Firebase Data Structure Guide

This document explains the Firestore database structure for the HBuilder app.

## 📊 Collections Overview

The app uses 5 main Firestore collections:

1. **users** - User profiles
2. **serviceCenters** - Car wash service centers
3. **vehicles** - User vehicles
4. **purchaseHistory** - Membership card purchases
5. **franchiseApplications** - Franchise applications

---

## 1. Users Collection

**Path**: `/users/{userId}`

**Structure**:
```json
{
  "email": "user@example.com",
  "name": "John Doe",
  "phone": "+1234567890",
  "createdAt": Timestamp
}
```

**Fields**:
- `email` (string, required) - User's email address
- `name` (string, optional) - User's full name
- `phone` (string, optional) - User's phone number
- `createdAt` (timestamp, optional) - Account creation date

**Notes**:
- Document ID is the Firebase Auth UID
- Created automatically on sign up
- Users can only read/write their own document

---

## 2. Service Centers Collection

**Path**: `/serviceCenters/{centerId}`

**Structure**:
```json
{
  "name": "Downtown Car Wash",
  "imageUrl": "https://example.com/image.jpg",
  "location": "123 Main Street, Downtown",
  "latitude": 40.7128,
  "longitude": -74.0060,
  "businessHours": "08:00 - 20:00",
  "contactNumber": "+1-555-0101",
  "isInBusiness": true,
  "description": "Professional car wash service with modern equipment.",
  "membershipCards": [
    {
      "type": "monthly",
      "name": "Monthly Card",
      "days": 30,
      "price": 159,
      "originalPrice": null,
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

**Fields**:
- `name` (string, required) - Service center name
- `imageUrl` (string, required) - URL to center image
- `location` (string, required) - Full address
- `latitude` (number, required) - GPS latitude (-90 to 90)
- `longitude` (number, required) - GPS longitude (-180 to 180)
- `businessHours` (string, required) - Operating hours
- `contactNumber` (string, required) - Phone number
- `isInBusiness` (boolean, required) - Currently open/closed
- `description` (string, optional) - Description text
- `membershipCards` (array, required) - Available membership cards

**Membership Card Object**:
- `type` (string) - "monthly", "seasonal", or "annual"
- `name` (string) - Display name
- `days` (number) - Validity period in days
- `price` (number) - Current price in USD
- `originalPrice` (number, optional) - Original price (for discount display)
- `imageUrl` (string) - Card image URL (can be empty)

**Notes**:
- Public read access
- Only admins can write (via Firebase Console)
- Add 5-10 centers for testing

### Sample Service Center Data

```json
// Service Center 1 - Downtown
{
  "name": "Downtown Premium Wash",
  "imageUrl": "https://images.unsplash.com/photo-1601362840469-51e4d8d58785?w=800",
  "location": "123 Main Street, Downtown, NY 10001",
  "latitude": 40.7128,
  "longitude": -74.0060,
  "businessHours": "08:00 - 20:00",
  "contactNumber": "+1-555-0101",
  "isInBusiness": true,
  "description": "Premium car wash service in downtown Manhattan with state-of-the-art equipment and experienced staff.",
  "membershipCards": [...]
}

// Service Center 2 - Uptown
{
  "name": "Uptown Auto Spa",
  "imageUrl": "https://images.unsplash.com/photo-1520340356584-f9917d1eea6f?w=800",
  "location": "456 Park Avenue, Uptown, NY 10021",
  "latitude": 40.7489,
  "longitude": -73.9680,
  "businessHours": "07:00 - 19:00",
  "contactNumber": "+1-555-0102",
  "isInBusiness": true,
  "description": "Luxury auto spa offering premium washing and detailing services.",
  "membershipCards": [...]
}

// Service Center 3 - Brooklyn
{
  "name": "Brooklyn Car Care",
  "imageUrl": "https://images.unsplash.com/photo-1591291621164-2c6367723315?w=800",
  "location": "789 Brooklyn Ave, Brooklyn, NY 11201",
  "latitude": 40.6782,
  "longitude": -73.9442,
  "businessHours": "06:00 - 22:00",
  "contactNumber": "+1-555-0103",
  "isInBusiness": true,
  "description": "24-hour accessible car wash with membership benefits and loyalty rewards.",
  "membershipCards": [...]
}
```

---

## 3. Vehicles Collection

**Path**: `/vehicles/{vehicleId}`

**Structure**:
```json
{
  "userId": "firebase_auth_uid",
  "vehicleName": "My Car",
  "vehicleNumber": "ABC-1234",
  "vehicleType": "Car",
  "brand": "Toyota",
  "model": "Camry",
  "color": "Black",
  "addedAt": Timestamp
}
```

**Fields**:
- `userId` (string, required) - Owner's Firebase Auth UID
- `vehicleName` (string, required) - Custom name for vehicle
- `vehicleNumber` (string, required) - License plate number
- `vehicleType` (string, required) - Type: "Car", "SUV", "Truck", "Van", "Motorcycle", "Other"
- `brand` (string, optional) - Vehicle brand/manufacturer
- `model` (string, optional) - Vehicle model
- `color` (string, optional) - Vehicle color
- `addedAt` (timestamp, optional) - Date added

**Notes**:
- Users can only read/write their own vehicles
- Auto-generated document ID

---

## 4. Purchase History Collection

**Path**: `/purchaseHistory/{purchaseId}`

**Structure**:
```json
{
  "userId": "firebase_auth_uid",
  "serviceCenterId": "center_doc_id",
  "cardType": "monthly",
  "amount": 159,
  "purchasedAt": Timestamp
}
```

**Fields**:
- `userId` (string, required) - Buyer's Firebase Auth UID
- `serviceCenterId` (string, required) - Service center document ID
- `cardType` (string, required) - "monthly", "seasonal", or "annual"
- `amount` (number, required) - Purchase amount in USD
- `purchasedAt` (timestamp, auto) - Purchase timestamp

**Notes**:
- Users can only read their own purchases
- Users can create (purchase)
- Ordered by purchasedAt descending for history display

---

## 5. Franchise Applications Collection

**Path**: `/franchiseApplications/{applicationId}`

**Structure**:
```json
{
  "userId": "firebase_auth_uid",
  "name": "John Doe",
  "contactNumber": "+1234567890",
  "franchiseCity": "New York",
  "message": "I am interested in opening a franchise...",
  "status": "pending",
  "submittedAt": Timestamp
}
```

**Fields**:
- `userId` (string, required) - Applicant's Firebase Auth UID
- `name` (string, required) - Applicant's name
- `contactNumber` (string, required) - Contact phone number
- `franchiseCity` (string, required) - Desired franchise location
- `message` (string, required) - Application message
- `status` (string, auto) - "pending", "approved", or "rejected"
- `submittedAt` (timestamp, auto) - Submission timestamp

**Notes**:
- Users can create and read their own applications
- Admins can update status via Firebase Console

---

## 🔒 Security Rules

Recommended Firestore Security Rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Helper function to check if user is authenticated
    function isSignedIn() {
      return request.auth != null;
    }
    
    // Helper function to check if user owns the document
    function isOwner(userId) {
      return isSignedIn() && request.auth.uid == userId;
    }
    
    // Users collection
    match /users/{userId} {
      allow read, write: if isOwner(userId);
    }
    
    // Service Centers - public read, no public write
    match /serviceCenters/{centerId} {
      allow read: if true;
      allow write: if false; // Only via Firebase Console
    }
    
    // Vehicles - users can manage their own
    match /vehicles/{vehicleId} {
      allow read: if isSignedIn() && resource.data.userId == request.auth.uid;
      allow create: if isSignedIn() && request.resource.data.userId == request.auth.uid;
      allow update, delete: if isSignedIn() && resource.data.userId == request.auth.uid;
    }
    
    // Purchase History - users can view their own and create new
    match /purchaseHistory/{purchaseId} {
      allow read: if isSignedIn() && resource.data.userId == request.auth.uid;
      allow create: if isSignedIn() && request.resource.data.userId == request.auth.uid;
      allow update, delete: if false; // No updates/deletes
    }
    
    // Franchise Applications
    match /franchiseApplications/{applicationId} {
      allow read: if isSignedIn() && resource.data.userId == request.auth.uid;
      allow create: if isSignedIn() && request.resource.data.userId == request.auth.uid;
      allow update, delete: if false; // Only admins via console
    }
  }
}
```

---

## 📝 Indexes

You may need to create composite indexes for complex queries:

### Recommended Indexes:

1. **vehicles**
   - Collection: `vehicles`
   - Fields: `userId` (Ascending), `addedAt` (Descending)

2. **purchaseHistory**
   - Collection: `purchaseHistory`
   - Fields: `userId` (Ascending), `purchasedAt` (Descending)

3. **franchiseApplications**
   - Collection: `franchiseApplications`
   - Fields: `userId` (Ascending), `submittedAt` (Descending)

Firebase will prompt you to create these indexes when needed.

---

## 🎯 Initial Data Setup Script

To quickly populate your database, use Firebase Console's "Import" feature or add documents manually:

### Add 5 Service Centers:
1. Copy the service center JSON from above
2. Go to Firestore → serviceCenters → Add Document
3. Use Auto-ID
4. Paste JSON
5. Repeat 5 times with different locations

### Test Coordinates:
- **New York**: 40.7128, -74.0060
- **Los Angeles**: 34.0522, -118.2437
- **Chicago**: 41.8781, -87.6298
- **Houston**: 29.7604, -95.3698
- **Phoenix**: 33.4484, -112.0740

---

## 🔍 Querying Examples

### Get Service Centers (in app):
```dart
FirebaseFirestore.instance
  .collection('serviceCenters')
  .get();
```

### Get User's Vehicles:
```dart
FirebaseFirestore.instance
  .collection('vehicles')
  .where('userId', isEqualTo: currentUserId)
  .orderBy('addedAt', descending: true)
  .get();
```

### Get Purchase History:
```dart
FirebaseFirestore.instance
  .collection('purchaseHistory')
  .where('userId', isEqualTo: currentUserId)
  .orderBy('purchasedAt', descending: true)
  .get();
```

---

## 💾 Backup & Export

1. Go to Firestore → Import/Export
2. Export to Google Cloud Storage
3. Set up automated backups (recommended)

---

## 📊 Data Validation

All data validation is handled by:
1. **Client-side**: Form validation in Flutter
2. **Security Rules**: Firestore rules
3. **Type Safety**: Dart models

---

## 🎉 Done!

Your Firestore database is now properly structured for the HBuilder app. Add sample data and test all features!



