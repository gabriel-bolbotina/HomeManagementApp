import 'package:flutter_test/flutter_test.dart';

class LoginValidation {
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  static bool isValidPassword(String password) {
    return password.length >= 6;
  }

  static String? validateLoginForm(String email, String password) {
    if (email.isEmpty) {
      return 'Please enter your email address.';
    }
    
    if (!isValidEmail(email)) {
      return 'Please enter a valid email address.';
    }
    
    if (password.isEmpty) {
      return 'Please enter your password.';
    }
    
    if (!isValidPassword(password)) {
      return 'Password must be at least 6 characters long.';
    }
    
    return null; // Valid form
  }
}

class DeviceValidation {
  static bool isValidDeviceName(String name) {
    return name.isNotEmpty && name.length >= 3 && name.length <= 50;
  }

  static bool isValidSerialNumber(int? serialNumber) {
    return serialNumber != null && serialNumber > 0;
  }

  static String? validateDevice(String name, String? type, String? brand, int? serialNumber) {
    if (!isValidDeviceName(name)) {
      return 'Device name must be between 3 and 50 characters.';
    }
    
    if (type == null || type.isEmpty) {
      return 'Please select a device type.';
    }
    
    if (brand == null || brand.isEmpty) {
      return 'Please enter the device brand.';
    }
    
    if (!isValidSerialNumber(serialNumber)) {
      return 'Please enter a valid serial number.';
    }
    
    return null; // Valid device
  }
}

void main() {
  group('Login Validation Tests', () {
    group('Email Validation', () {
      test('should validate correct email formats', () {
        expect(LoginValidation.isValidEmail('test@example.com'), isTrue);
        expect(LoginValidation.isValidEmail('user.name@domain.co.uk'), isTrue);
        expect(LoginValidation.isValidEmail('user+tag@example.org'), isTrue);
      });

      test('should reject invalid email formats', () {
        expect(LoginValidation.isValidEmail('invalid'), isFalse);
        expect(LoginValidation.isValidEmail('test@'), isFalse);
        expect(LoginValidation.isValidEmail('@example.com'), isFalse);
        expect(LoginValidation.isValidEmail('test.example.com'), isFalse);
      });
    });

    group('Password Validation', () {
      test('should validate passwords with 6 or more characters', () {
        expect(LoginValidation.isValidPassword('123456'), isTrue);
        expect(LoginValidation.isValidPassword('password'), isTrue);
        expect(LoginValidation.isValidPassword('MySecretPassword123'), isTrue);
      });

      test('should reject passwords with less than 6 characters', () {
        expect(LoginValidation.isValidPassword('12345'), isFalse);
        expect(LoginValidation.isValidPassword('abc'), isFalse);
        expect(LoginValidation.isValidPassword(''), isFalse);
      });
    });

    group('Login Form Validation', () {
      test('should return null for valid login form', () {
        final result = LoginValidation.validateLoginForm('test@example.com', 'password123');
        expect(result, isNull);
      });

      test('should return error for empty email', () {
        final result = LoginValidation.validateLoginForm('', 'password123');
        expect(result, equals('Please enter your email address.'));
      });

      test('should return error for invalid email', () {
        final result = LoginValidation.validateLoginForm('invalid-email', 'password123');
        expect(result, equals('Please enter a valid email address.'));
      });

      test('should return error for empty password', () {
        final result = LoginValidation.validateLoginForm('test@example.com', '');
        expect(result, equals('Please enter your password.'));
      });

      test('should return error for short password', () {
        final result = LoginValidation.validateLoginForm('test@example.com', '123');
        expect(result, equals('Password must be at least 6 characters long.'));
      });
    });
  });

  group('Device Validation Tests', () {
    group('Device Name Validation', () {
      test('should validate correct device names', () {
        expect(DeviceValidation.isValidDeviceName('Smart Light'), isTrue);
        expect(DeviceValidation.isValidDeviceName('Living Room Thermostat'), isTrue);
        expect(DeviceValidation.isValidDeviceName('Door Lock 1'), isTrue);
      });

      test('should reject invalid device names', () {
        expect(DeviceValidation.isValidDeviceName(''), isFalse);
        expect(DeviceValidation.isValidDeviceName('AB'), isFalse);
        expect(DeviceValidation.isValidDeviceName('A' * 51), isFalse);
      });
    });

    group('Serial Number Validation', () {
      test('should validate positive serial numbers', () {
        expect(DeviceValidation.isValidSerialNumber(123456), isTrue);
        expect(DeviceValidation.isValidSerialNumber(1), isTrue);
        expect(DeviceValidation.isValidSerialNumber(999999999), isTrue);
      });

      test('should reject invalid serial numbers', () {
        expect(DeviceValidation.isValidSerialNumber(null), isFalse);
        expect(DeviceValidation.isValidSerialNumber(0), isFalse);
        expect(DeviceValidation.isValidSerialNumber(-1), isFalse);
      });
    });

    group('Device Form Validation', () {
      test('should return null for valid device', () {
        final result = DeviceValidation.validateDevice('Smart Light', 'light', 'Philips', 123456);
        expect(result, isNull);
      });

      test('should return error for invalid device name', () {
        final result = DeviceValidation.validateDevice('AB', 'light', 'Philips', 123456);
        expect(result, equals('Device name must be between 3 and 50 characters.'));
      });

      test('should return error for missing type', () {
        final result = DeviceValidation.validateDevice('Smart Light', null, 'Philips', 123456);
        expect(result, equals('Please select a device type.'));
      });

      test('should return error for missing brand', () {
        final result = DeviceValidation.validateDevice('Smart Light', 'light', null, 123456);
        expect(result, equals('Please enter the device brand.'));
      });

      test('should return error for invalid serial number', () {
        final result = DeviceValidation.validateDevice('Smart Light', 'light', 'Philips', null);
        expect(result, equals('Please enter a valid serial number.'));
      });
    });
  });
}