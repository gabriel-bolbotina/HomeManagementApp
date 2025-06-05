# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

### Flutter Commands
- `flutter pub get` - Install dependencies
- `flutter run` - Run the app (requires device/emulator)
- `flutter build apk` - Build Android APK
- `flutter build ios` - Build iOS app
- `flutter clean` - Clean build cache
- `flutter doctor` - Check Flutter installation and dependencies

### Testing
- `flutter test` - Run widget tests (limited tests available in test/widget_test.dart)

## Architecture Overview

### Multi-Role Authentication System
The app implements a role-based authentication system with three distinct user types:
- **Homeowner**: Primary property owner with full device management
- **Tenant**: Property renter with limited device access
- **Landlord**: Property manager overseeing multiple properties

User roles are stored in Firestore and determine app navigation flow in `main.dart:48-68`.

### Core Services Architecture
- **Authentication Service** (`lib/Services/authentication.dart`): Centralized auth state management with Firebase Auth integration and user profile data caching
- **DatabaseService** (`lib/Services/DatabaseService.dart`): Firestore operations for user data CRUD
- **FirebaseService** (`lib/Services/FirebaseService.dart`): Google Sign-In integration

### Page Structure by Role
Each user role has dedicated page hierarchies:
- `lib/Pages/HomePages/` - Role-specific home screens
- `lib/Pages/ProfilePages/` - Role-specific profile management
- `lib/Pages/EditPages/` - Role-specific edit forms
- `lib/Pages/NotificationPages/` - Role-specific notifications

### Smart Home Integration
- **Device Management**: Centralized in `lib/model/Devices.dart` with Firestore persistence
- **Room Management**: `lib/model/Room.dart` for spatial organization
- **IoT Integrations**: 
  - Philips Hue lights (`lib/Pages/FunctionalityPages/PhilipsHueLight.dart`)
  - Bluetooth connectivity (`flutter_bluetooth_serial`)
  - TensorFlow Lite ML model for door prediction (`assets/models/door_lock_model.tflite`)

### Theme System
Custom theme implementation in `lib/Pages/flutter_flow/HomeAppTheme.dart`:
- Light/Dark mode support with SharedPreferences persistence
- Google Fonts integration (Poppins, Fira Sans)
- Role-based color schemes

### Environment Configuration
- `.env` file required in project root for API keys
- Environment loading in `main.dart:29-30` with hardcoded path
- Firebase configuration files required:
  - `android/app/google-services.json`
  - `ios/Runner/GoogleService-Info.plist`

### Navigation Architecture
- Named routes defined in `main.dart:69-84`
- Role-based routing logic in StreamBuilder (`main.dart:48-68`)
- Authentication state drives initial route selection

## Firebase Setup Requirements

Before running the app:
1. Add `google-services.json` to `android/app/`
2. Add `GoogleService-Info.plist` to `ios/Runner/`
3. Ensure package names match Firebase console configuration
4. Create `.env` file in project root with required API keys

## Key Dependencies
- Firebase suite (Auth, Firestore, Storage)
- Google Maps and Places APIs
- TensorFlow Lite for ML inference
- Bluetooth serial communication
- Local notifications framework