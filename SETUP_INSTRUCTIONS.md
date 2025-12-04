# Washtron App Setup Instructions

## Issues Fixed

### 1. AI Chatbot Configuration ✅
### 2. Profile Image Upload Fix ✅

---

## Required Setup Steps

### Step 1: Configure Google AI API Key (For Chatbot)

The AI chatbot requires a valid Google AI API key to function.

**Get Your API Key:**
1. Visit: https://makersuite.google.com/app/apikey
2. Sign in with your Google account
3. Click "Create API Key"
4. Copy the generated API key

**Update the Code:**
1. Open: `lib/services/ai_service.dart`
2. Find line 7: `static const String _apiKey = 'AIzaSyBdkmGFhdjOKUMxr8i6kQ0R3eclfsyFeLY';`
3. Replace with your new API key: `static const String _apiKey = 'YOUR_NEW_API_KEY_HERE';`

**Important:** The current API key may be invalid or have reached its quota limit.

---

### Step 2: Configure Firebase Storage Rules

The profile image upload requires proper Firebase Storage rules.

**Update Firebase Storage Rules:**

1. Go to Firebase Console: https://console.firebase.google.com/
2. Select your project
3. Navigate to: **Storage** → **Rules**
4. Replace the rules with:

```
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // Allow authenticated users to upload/read their own profile pictures
    match /profile_pictures/{userId}_{timestamp}.jpg {
      allow read: if true;  // Anyone can read profile pictures
      allow write: if request.auth != null && request.auth.uid == userId;
      allow delete: if request.auth != null && request.auth.uid == userId;
    }
    
    // Legacy support for old profile picture format
    match /profile_pictures/{userId}.jpg {
      allow read: if true;
      allow write: if request.auth != null && request.auth.uid == userId;
      allow delete: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

5. Click **Publish**

---

### Step 3: Update Firestore Rules (If Needed)

Ensure your Firestore rules allow profile picture URL updates:

1. Go to: **Firestore Database** → **Rules**
2. Ensure you have:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users collection
    match /users/{userId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null && request.auth.uid == userId;
      allow update: if request.auth != null && request.auth.uid == userId;
      allow delete: if request.auth != null && request.auth.uid == userId;
    }
    
    // Other collections...
  }
}
```

---

## Code Changes Made

### 1. Enhanced AI Service (`lib/services/ai_service.dart`)
- ✅ Updated to `gemini-1.5-flash` model (newer, more reliable)
- ✅ Added initialization checks
- ✅ Improved error handling with specific error messages
- ✅ Added debug logging for troubleshooting
- ✅ Better null safety

### 2. Improved Storage Service (`lib/services/storage_service.dart`)
- ✅ Added file existence validation
- ✅ Added file size validation (2MB limit)
- ✅ Unique filenames with timestamps to avoid caching issues
- ✅ Upload progress monitoring
- ✅ Better error messages
- ✅ Enhanced Firebase exception handling

### 3. Updated Auth Provider (`lib/providers/auth_provider.dart`)
- ✅ Profile picture URL now persists to Firestore
- ✅ Proper async/await handling
- ✅ Error propagation for better debugging

### 4. Enhanced Profile Screen (`lib/screens/profile/profile_screen.dart`)
- ✅ Added mounted checks to prevent crashes
- ✅ Better image compression settings
- ✅ Improved error messages for users
- ✅ Debug logging

### 5. Updated AndroidManifest.xml
- ✅ Added storage permissions for Android
- ✅ Added UCrop activity for image cropper
- ✅ Added media permissions for Android 13+

---

## Testing the Fixes

### Test AI Chatbot:
1. Open the app
2. Navigate to Profile → Help & Support
3. Try asking: "What membership cards do you offer?"
4. You should get a detailed response about the three card types

**If you still see the fallback message:**
- Check the debug console for error messages
- Verify your API key is valid
- Ensure you have internet connection

### Test Profile Image Upload:
1. Open the app
2. Navigate to Profile screen
3. Tap the camera icon on your profile picture
4. Select "Choose from Gallery" or "Take Photo"
5. Crop the image
6. Wait for upload to complete
7. Your profile picture should update

**If upload fails:**
- Check Firebase Storage rules are published
- Verify Firebase Storage is enabled in your project
- Check the debug console for specific error messages
- Ensure the image is under 2MB

---

## Troubleshooting

### AI Chatbot Issues:
- **Error: API Key Invalid** → Get a new API key from Google AI Studio
- **Error: Quota Exceeded** → Wait or upgrade your API quota
- **Error: Network** → Check internet connection

### Image Upload Issues:
- **Error: object-not-found** → Update Firebase Storage rules (see Step 2)
- **Error: Permission denied** → Check Firebase Storage rules
- **Error: File too large** → Image must be under 2MB
- **App crashes** → Ensure AndroidManifest.xml has all permissions

---

## Additional Notes

### Security Best Practices:
1. **Never commit API keys to public repositories**
2. Consider using environment variables or Firebase Remote Config for API keys
3. Implement rate limiting for API calls
4. Monitor Firebase Storage usage

### Performance Tips:
1. Images are automatically compressed to 85% quality
2. Max resolution is 1024x1024 pixels
3. Unique filenames prevent caching issues
4. Profile pictures are publicly readable for better performance

---

## Support

If you continue to experience issues:
1. Check the Flutter debug console for detailed error messages
2. Verify all Firebase services are enabled
3. Ensure you're using the latest package versions
4. Check Firebase Console for any quota or billing issues

For more help, refer to:
- Google AI Documentation: https://ai.google.dev/docs
- Firebase Storage Documentation: https://firebase.google.com/docs/storage
- Flutter Documentation: https://flutter.dev/docs
