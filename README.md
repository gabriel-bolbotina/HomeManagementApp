# HomeApp Flutter Application - Installation Guide

Welcome to the installation guide of HomeApp, a Flutter application. This app is a cross-platform application, and this guide will walk you through the steps needed to run the application on both Android and iOS devices. 

## Prerequisites

Before you can run this app, you need to have the following installed:

1. Flutter SDK (version 2.2.3 or above)
2. Dart (version 2.13.4 or above)
3. Android Studio or IntelliJ or VS Code with Flutter plugin installed
4. Xcode (for iOS only)
5. Git

To check if you have Flutter and Dart installed correctly, run the following commands:

```bash
flutter --version
dart --version
```


## Steps to Run the App

### 1. Clone this repository to your local machine.
You can use the following command to clone the repository:

```bash
git clone https://github.com/gabriel-bolbotina/HomeManagementApp.git
```

### 2. Navigate into the cloned repository's directory:
```bash
cd HomeManagementApp
```

### 3. Install the Flutter and Dart packages. 
Run the following command in the root of your project:
```bash
flutter pub get
```

### 4. Before you can run the application, you need to set up Firebase. 
Download your own **`google-services.json`** (for Android) and **`GoogleService-Info.plist`** (for iOS) from Firebase Console and put them into **`android/app`** and **`ios/Runner`** directory respectively.
For Android, ensure that your package name in **`android/app/build.gradle`** file matches your Firebase project's package name.
For iOS, in Xcode, you need to also set the Bundle Identifier to match the one on Firebase console.

## Android
1.Connect your Android device or start the Android emulator.
2.Run the following command to build and run the app:

```bash
flutter run
```

## iOS
1.Open the **ios/Runner.xcworkspace** file in Xcode.
2.Set up a Team for your project. Go to **`Runner`** > **`Signing & Capabilities`** > **`Team`** and choose your team.
3.Connect your iOS device or start the iOS simulator.
4.Go back to your terminal, and run the following command:
```bash
flutter run
```
Congratulations, you should now be able to run the HomeApp on your device!

## Troubleshooting
If you encounter any issues, try the following:

1.Make sure all your Flutter and Dart plugins are up-to-date.
2.Try to stop the app and re-run it.
3.If any issue persists, try a full restart by stopping the app, deleting it from your device/emulator, and re-running it.

If you still face issues, please raise an issue on the GitHub repository, providing as much detail as possible.
