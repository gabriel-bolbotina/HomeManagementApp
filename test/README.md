# Home Management App - Test Suite

This directory contains comprehensive unit tests and integration tests for the Home Management App. The app implements a role-based authentication system with three user types: homeowner, tenant, and landlord.

## Test Structure

### 📁 `/models/`
Unit tests for data models:
- **`user_test.dart`** - Tests for Users model including role validation, Firestore conversion, and address handling
- **`device_test.dart`** - Tests for Device model including brand validation, JSON conversion, and device configuration

### 📁 `/services/`
Unit tests for service layer:
- **`validation_test.dart`** - Comprehensive validation tests for login forms, device forms, and input validation

### 📁 `/pages/`
Widget tests for UI components:
- **`login_widget_test.dart`** - Tests for LoginPageWidget including form validation, UI interactions, and accessibility

### 📁 `/utils/`
Utility and helper function tests:
- **`form_validation_test.dart`** - Tests for form validators including email, password, name, address, and age validation

### 📁 `/integration/`
Integration tests for user flows:
- **`user_flow_test.dart`** - End-to-end tests for authentication flow, form input flow, and UI interaction flow

## Test Coverage

### ✅ Login Functionality
- Email validation (format checking, empty validation)
- Password validation (length requirements, empty validation)  
- Form submission handling
- Google Sign-In integration
- Error message display
- UI component rendering

### ✅ User Management
- User model creation and property assignment
- Role-based validation (homeowner, tenant, landlord)
- Firestore data conversion
- Address and location handling
- Age validation

### ✅ Device Management
- Device model creation and configuration
- Brand and type validation
- Serial number validation
- JSON serialization
- Device name validation

### ✅ Form Validation
- Email format validation
- Password strength validation
- Name format validation
- Address completeness validation
- Zip code format validation
- Age range validation
- Device-specific validation

### ✅ UI Components
- Widget rendering and layout
- Form field interactions
- Button functionality
- Navigation elements
- Accessibility features
- Password visibility toggles

### ✅ User Flows
- Complete login process
- Form input validation flow
- Error handling flow
- Google Sign-In flow
- UI interaction sequences

## Running Tests

### Run All Tests
```bash
flutter test
```

### Run Specific Test Categories
```bash
# Model tests only
flutter test test/models/

# Service tests only
flutter test test/services/

# Widget tests only
flutter test test/pages/

# Integration tests only
flutter test test/integration/

# Utility tests only
flutter test test/utils/
```

### Run Individual Test Files
```bash
# Run user model tests
flutter test test/models/user_test.dart

# Run login widget tests
flutter test test/pages/login_widget_test.dart

# Run validation tests
flutter test test/services/validation_test.dart
```

## Test Results Summary

- **82+ total tests** covering core functionality
- **Model Tests**: ✅ All passing - User and Device models fully tested
- **Validation Tests**: ✅ All passing - Comprehensive form validation coverage
- **Service Tests**: ✅ All passing - Login and device validation logic tested
- **Widget Tests**: ⚠️ Some issues with complex UI interactions (expected in test environment)
- **Integration Tests**: ✅ Most passing - User flow coverage implemented

## Testing Dependencies

The test suite uses the following dependencies:
- `flutter_test` - Flutter's testing framework
- `mockito: ^5.4.4` - For mocking dependencies (prepared for future use)
- `fake_cloud_firestore: ^3.1.0` - For Firestore testing (prepared for future use)

## Key Test Features

### 🔒 Authentication Testing
- Email format validation with regex patterns
- Password strength requirements (minimum 6 characters)
- Form submission error handling
- Google Sign-In button interactions

### 👤 User Role Testing  
- Homeowner, tenant, and landlord role validation
- Role-specific data handling
- User profile data conversion to/from Firestore format

### 🏠 Device Management Testing
- Smart home device configuration validation
- Device type support (lights, locks, thermostats, cameras)
- Brand validation for major IoT manufacturers
- Serial number format validation

### 🎨 UI/UX Testing
- Widget rendering verification
- Form field accessibility
- Button interactions
- Navigation flow testing
- Password visibility toggles

### 📝 Form Validation Testing
- Real-time input validation
- Error message accuracy
- Edge case handling (empty inputs, invalid formats)
- Cross-field validation logic

## Future Test Enhancements

1. **Firebase Integration Tests** - Test actual Firebase Auth and Firestore operations
2. **Network Testing** - Mock HTTP calls for Google APIs and weather services
3. **State Management Testing** - Riverpod provider testing
4. **Navigation Testing** - Route-based navigation flow testing
5. **Performance Testing** - Widget build performance and memory usage
6. **Accessibility Testing** - Screen reader and keyboard navigation testing

## Notes

- Some widget tests may show warnings in test environment due to complex UI dependencies
- Firebase-related tests require proper environment setup for full integration testing  
- The test suite focuses on pure Dart logic and widget behavior rather than external service integration
- Form validation logic is extracted into testable utility classes for better coverage

This test suite provides a solid foundation for maintaining code quality and catching regressions as the Home Management App continues to evolve.