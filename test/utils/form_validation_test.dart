import 'package:flutter_test/flutter_test.dart';

class FormValidators {
  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Please enter your email address.';
    }
    
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      return 'Please enter a valid email address.';
    }
    
    return null;
  }
  
  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Please enter your password.';
    }
    
    if (password.length < 6) {
      return 'Password must be at least 6 characters long.';
    }
    
    return null;
  }
  
  static String? validateName(String? name) {
    if (name == null || name.isEmpty) {
      return 'Please enter your name.';
    }
    
    if (name.length < 2) {
      return 'Name must be at least 2 characters long.';
    }
    
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(name)) {
      return 'Name can only contain letters and spaces.';
    }
    
    return null;
  }
  
  static String? validateDeviceName(String? deviceName) {
    if (deviceName == null || deviceName.isEmpty) {
      return 'Please enter a device name.';
    }
    
    if (deviceName.length < 3) {
      return 'Device name must be at least 3 characters long.';
    }
    
    if (deviceName.length > 50) {
      return 'Device name must be less than 50 characters.';
    }
    
    return null;
  }
  
  static String? validateAddress(String? address) {
    if (address == null || address.isEmpty) {
      return 'Please enter your address.';
    }
    
    if (address.length < 10) {
      return 'Please enter a complete address.';
    }
    
    return null;
  }
  
  static String? validateZipCode(String? zipCode) {
    if (zipCode == null || zipCode.isEmpty) {
      return 'Please enter your zip code.';
    }
    
    if (!RegExp(r'^\d{5}(-\d{4})?$').hasMatch(zipCode)) {
      return 'Please enter a valid zip code (e.g., 12345 or 12345-6789).';
    }
    
    return null;
  }
  
  static String? validateAge(String? age) {
    if (age == null || age.isEmpty) {
      return 'Please enter your age.';
    }
    
    final ageInt = int.tryParse(age);
    if (ageInt == null) {
      return 'Please enter a valid number.';
    }
    
    if (ageInt < 16 || ageInt > 120) {
      return 'Please enter a valid age between 16 and 120.';
    }
    
    return null;
  }
}

void main() {
  group('Form Validation Tests', () {
    group('Email Validation', () {
      test('should return null for valid email', () {
        // Act & Assert
        expect(FormValidators.validateEmail('test@example.com'), isNull);
        expect(FormValidators.validateEmail('user.name@domain.co.uk'), isNull);
        expect(FormValidators.validateEmail('user+tag@example.org'), isNull);
        expect(FormValidators.validateEmail('user_name@example-domain.com'), isNull);
      });

      test('should return error for empty email', () {
        // Act & Assert
        expect(FormValidators.validateEmail(''), equals('Please enter your email address.'));
        expect(FormValidators.validateEmail(null), equals('Please enter your email address.'));
      });

      test('should return error for invalid email format', () {
        // Act & Assert
        expect(FormValidators.validateEmail('invalid'), equals('Please enter a valid email address.'));
        expect(FormValidators.validateEmail('test@'), equals('Please enter a valid email address.'));
        expect(FormValidators.validateEmail('@example.com'), equals('Please enter a valid email address.'));
        expect(FormValidators.validateEmail('test@.com'), equals('Please enter a valid email address.'));
        expect(FormValidators.validateEmail('test.example.com'), equals('Please enter a valid email address.'));
      });
    });

    group('Password Validation', () {
      test('should return null for valid password', () {
        // Act & Assert
        expect(FormValidators.validatePassword('password123'), isNull);
        expect(FormValidators.validatePassword('MySecretPassword'), isNull);
        expect(FormValidators.validatePassword('123456'), isNull);
        expect(FormValidators.validatePassword('abcdef'), isNull);
      });

      test('should return error for empty password', () {
        // Act & Assert
        expect(FormValidators.validatePassword(''), equals('Please enter your password.'));
        expect(FormValidators.validatePassword(null), equals('Please enter your password.'));
      });

      test('should return error for short password', () {
        // Act & Assert
        expect(FormValidators.validatePassword('12345'), equals('Password must be at least 6 characters long.'));
        expect(FormValidators.validatePassword('abc'), equals('Password must be at least 6 characters long.'));
        expect(FormValidators.validatePassword('a'), equals('Password must be at least 6 characters long.'));
      });
    });

    group('Name Validation', () {
      test('should return null for valid name', () {
        // Act & Assert
        expect(FormValidators.validateName('John'), isNull);
        expect(FormValidators.validateName('John Doe'), isNull);
        expect(FormValidators.validateName('Mary Jane Smith'), isNull);
        expect(FormValidators.validateName('Van Der Berg'), isNull);
      });

      test('should return error for empty name', () {
        // Act & Assert
        expect(FormValidators.validateName(''), equals('Please enter your name.'));
        expect(FormValidators.validateName(null), equals('Please enter your name.'));
      });

      test('should return error for short name', () {
        // Act & Assert
        expect(FormValidators.validateName('A'), equals('Name must be at least 2 characters long.'));
      });

      test('should return error for name with invalid characters', () {
        // Act & Assert
        expect(FormValidators.validateName('John123'), equals('Name can only contain letters and spaces.'));
        expect(FormValidators.validateName('John@Doe'), equals('Name can only contain letters and spaces.'));
        expect(FormValidators.validateName('John-Doe'), equals('Name can only contain letters and spaces.'));
      });
    });

    group('Device Name Validation', () {
      test('should return null for valid device name', () {
        // Act & Assert
        expect(FormValidators.validateDeviceName('Smart Light'), isNull);
        expect(FormValidators.validateDeviceName('Living Room Thermostat'), isNull);
        expect(FormValidators.validateDeviceName('Door Lock 1'), isNull);
        expect(FormValidators.validateDeviceName('Kitchen Smart Switch'), isNull);
      });

      test('should return error for empty device name', () {
        // Act & Assert
        expect(FormValidators.validateDeviceName(''), equals('Please enter a device name.'));
        expect(FormValidators.validateDeviceName(null), equals('Please enter a device name.'));
      });

      test('should return error for short device name', () {
        // Act & Assert
        expect(FormValidators.validateDeviceName('AB'), equals('Device name must be at least 3 characters long.'));
        expect(FormValidators.validateDeviceName('A'), equals('Device name must be at least 3 characters long.'));
      });

      test('should return error for long device name', () {
        // Arrange
        final longName = 'A' * 51; // 51 characters

        // Act & Assert
        expect(FormValidators.validateDeviceName(longName), equals('Device name must be less than 50 characters.'));
      });
    });

    group('Address Validation', () {
      test('should return null for valid address', () {
        // Act & Assert
        expect(FormValidators.validateAddress('123 Main Street, Anytown, ST 12345'), isNull);
        expect(FormValidators.validateAddress('456 Oak Avenue, Unit 2B'), isNull);
        expect(FormValidators.validateAddress('789 Pine Road, Apartment 15'), isNull);
      });

      test('should return error for empty address', () {
        // Act & Assert
        expect(FormValidators.validateAddress(''), equals('Please enter your address.'));
        expect(FormValidators.validateAddress(null), equals('Please enter your address.'));
      });

      test('should return error for short address', () {
        // Act & Assert
        expect(FormValidators.validateAddress('123 Main'), equals('Please enter a complete address.'));
        expect(FormValidators.validateAddress('Short St'), equals('Please enter a complete address.'));
      });
    });

    group('Zip Code Validation', () {
      test('should return null for valid zip code', () {
        // Act & Assert
        expect(FormValidators.validateZipCode('12345'), isNull);
        expect(FormValidators.validateZipCode('12345-6789'), isNull);
        expect(FormValidators.validateZipCode('90210'), isNull);
        expect(FormValidators.validateZipCode('10001-1234'), isNull);
      });

      test('should return error for empty zip code', () {
        // Act & Assert
        expect(FormValidators.validateZipCode(''), equals('Please enter your zip code.'));
        expect(FormValidators.validateZipCode(null), equals('Please enter your zip code.'));
      });

      test('should return error for invalid zip code format', () {
        // Act & Assert
        expect(FormValidators.validateZipCode('1234'), equals('Please enter a valid zip code (e.g., 12345 or 12345-6789).'));
        expect(FormValidators.validateZipCode('123456'), equals('Please enter a valid zip code (e.g., 12345 or 12345-6789).'));
        expect(FormValidators.validateZipCode('ABCDE'), equals('Please enter a valid zip code (e.g., 12345 or 12345-6789).'));
        expect(FormValidators.validateZipCode('12345-ABC'), equals('Please enter a valid zip code (e.g., 12345 or 12345-6789).'));
      });
    });

    group('Age Validation', () {
      test('should return null for valid age', () {
        // Act & Assert
        expect(FormValidators.validateAge('18'), isNull);
        expect(FormValidators.validateAge('25'), isNull);
        expect(FormValidators.validateAge('65'), isNull);
        expect(FormValidators.validateAge('120'), isNull);
        expect(FormValidators.validateAge('16'), isNull);
      });

      test('should return error for empty age', () {
        // Act & Assert
        expect(FormValidators.validateAge(''), equals('Please enter your age.'));
        expect(FormValidators.validateAge(null), equals('Please enter your age.'));
      });

      test('should return error for non-numeric age', () {
        // Act & Assert
        expect(FormValidators.validateAge('abc'), equals('Please enter a valid number.'));
        expect(FormValidators.validateAge('twenty'), equals('Please enter a valid number.'));
        expect(FormValidators.validateAge('25.5'), equals('Please enter a valid number.'));
      });

      test('should return error for invalid age range', () {
        // Act & Assert
        expect(FormValidators.validateAge('15'), equals('Please enter a valid age between 16 and 120.'));
        expect(FormValidators.validateAge('121'), equals('Please enter a valid age between 16 and 120.'));
        expect(FormValidators.validateAge('0'), equals('Please enter a valid age between 16 and 120.'));
        expect(FormValidators.validateAge('-5'), equals('Please enter a valid age between 16 and 120.'));
      });
    });
  });
}