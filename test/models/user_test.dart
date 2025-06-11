import 'package:flutter_test/flutter_test.dart';
import 'package:homeapp/model/User.dart';

void main() {
  group('Users Model Tests', () {
    test('should create Users instance with default constructor', () {
      // Act
      final user = Users();

      // Assert
      expect(user.firstName, isNull);
      expect(user.lastName, isNull);
      expect(user.age, isNull);
      expect(user.role, isNull);
      expect(user.address, isNull);
      expect(user.zipCode, isNull);
    });

    test('should return user role correctly', () {
      // Arrange
      final user = Users();
      user.role = 'homeowner';

      // Act
      final result = user.getUserRole();

      // Assert
      expect(result, equals('homeowner'));
    });

    test('should return null when role is not set', () {
      // Arrange
      final user = Users();

      // Act
      final result = user.getUserRole();

      // Assert
      expect(result, isNull);
    });

    test('should convert to Firestore format correctly', () {
      // Arrange
      final user = Users();
      user.firstName = 'John';
      user.lastName = 'Doe';
      user.age = 30;
      user.role = 'tenant';

      // Act
      final result = user.toFirestore();

      // Assert
      expect(result, isA<Map<String, dynamic>>());
      expect(result['first name'], equals('John'));
      expect(result['last name'], equals('Doe'));
      expect(result['age'], equals(30));
      expect(result['role'], equals('tenant'));
    });

    test('should handle null values in toFirestore conversion', () {
      // Arrange
      final user = Users();
      user.firstName = 'Jane';
      // Leave other fields null

      // Act
      final result = user.toFirestore();

      // Assert
      expect(result, isA<Map<String, dynamic>>());
      expect(result['first name'], equals('Jane'));
      expect(result.containsKey('last name'), isFalse);
      expect(result.containsKey('age'), isFalse);
      expect(result.containsKey('role'), isFalse);
    });

    test('should create empty toFirestore when all fields are null', () {
      // Arrange
      final user = Users();

      // Act
      final result = user.toFirestore();

      // Assert
      expect(result, isA<Map<String, dynamic>>());
      expect(result.isEmpty, isTrue);
    });

    group('Role-specific tests', () {
      test('should handle homeowner role', () {
        // Arrange
        final user = Users();
        user.role = 'homeowner';

        // Act & Assert
        expect(user.getUserRole(), equals('homeowner'));
      });

      test('should handle tenant role', () {
        // Arrange
        final user = Users();
        user.role = 'tenant';

        // Act & Assert
        expect(user.getUserRole(), equals('tenant'));
      });

      test('should handle landlord role', () {
        // Arrange
        final user = Users();
        user.role = 'landlord';

        // Act & Assert
        expect(user.getUserRole(), equals('landlord'));
      });

      test('should handle invalid role', () {
        // Arrange
        final user = Users();
        user.role = 'invalid_role';

        // Act & Assert
        expect(user.getUserRole(), equals('invalid_role'));
      });
    });

    group('Address and location tests', () {
      test('should handle complete address information', () {
        // Arrange
        final user = Users();
        user.address = '123 Main St';
        user.zipCode = '12345';

        // Act
        final firestore = user.toFirestore();

        // Assert
        expect(firestore['address'], equals('123 Main St'));
        expect(firestore['zip code'], equals('12345'));
      });

      test('should handle partial address information', () {
        // Arrange
        final user = Users();
        user.address = '456 Oak Ave';
        // zipCode left null

        // Act
        final firestore = user.toFirestore();

        // Assert
        expect(firestore['address'], equals('456 Oak Ave'));
        expect(firestore.containsKey('zip code'), isFalse);
      });
    });

    group('Age validation tests', () {
      test('should handle valid age', () {
        // Arrange
        final user = Users();
        user.age = 25;

        // Act & Assert
        expect(user.age, equals(25));
        expect(user.toFirestore()['age'], equals(25));
      });

      test('should handle zero age', () {
        // Arrange
        final user = Users();
        user.age = 0;

        // Act & Assert
        expect(user.age, equals(0));
        expect(user.toFirestore()['age'], equals(0));
      });

      test('should handle negative age', () {
        // Arrange
        final user = Users();
        user.age = -5;

        // Act & Assert
        expect(user.age, equals(-5));
        expect(user.toFirestore()['age'], equals(-5));
      });
    });
  });
}