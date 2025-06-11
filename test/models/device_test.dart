import 'package:flutter_test/flutter_test.dart';
import 'package:homeapp/model/Devices.dart';

void main() {
  group('Device Model Tests', () {
    test('should create Device instance with default constructor', () {
      // Act
      final device = Device();

      // Assert
      expect(device.deviceId, isNull);
      expect(device.deviceName, isNull);
      expect(device.serialNumber, isNull);
      expect(device.type, isNull);
      expect(device.brand, isNull);
      expect(device.uploadedImage, isNull);
      expect(device.timestamp, isNull);
    });

    test('should return brand correctly', () {
      // Arrange
      final device = Device();
      device.brand = 'Philips';

      // Act
      final result = device.getBrand();

      // Assert
      expect(result, equals('Philips'));
    });

    test('should return null when brand is not set', () {
      // Arrange
      final device = Device();

      // Act
      final result = device.getBrand();

      // Assert
      expect(result, isNull);
    });

    test('should convert to JSON format correctly', () {
      // Arrange
      final device = Device();
      device.deviceId = 'device123';
      device.deviceName = 'Smart Light';
      device.serialNumber = 12345;
      device.type = 'light';
      device.brand = 'Philips';

      // Act
      final result = device.toJson();

      // Assert
      expect(result, isA<Map<String, dynamic>>());
      expect(result['id'], equals('device123'));
      expect(result['name'], equals('Smart Light'));
      expect(result['serial number'], equals(12345));
      expect(result['type'], equals('light'));
      expect(result['brand'], equals('Philips'));
      expect(result['timestamp'], isNull);
    });

    test('should handle null values in toJson conversion', () {
      // Arrange
      final device = Device();
      device.deviceName = 'Door Lock';
      // Leave other fields null

      // Act
      final result = device.toJson();

      // Assert
      expect(result, isA<Map<String, dynamic>>());
      expect(result['name'], equals('Door Lock'));
      expect(result['id'], isNull);
      expect(result['serial number'], isNull);
      expect(result['type'], isNull);
      expect(result['brand'], isNull);
      expect(result['timestamp'], isNull);
    });

    group('Device type tests', () {
      test('should handle light device type', () {
        // Arrange
        final device = Device();
        device.type = 'light';
        device.brand = 'Philips';

        // Act & Assert
        expect(device.type, equals('light'));
        expect(device.getBrand(), equals('Philips'));
      });

      test('should handle lock device type', () {
        // Arrange
        final device = Device();
        device.type = 'lock';
        device.brand = 'Yale';

        // Act & Assert
        expect(device.type, equals('lock'));
        expect(device.getBrand(), equals('Yale'));
      });

      test('should handle thermostat device type', () {
        // Arrange
        final device = Device();
        device.type = 'thermostat';
        device.brand = 'Nest';

        // Act & Assert
        expect(device.type, equals('thermostat'));
        expect(device.getBrand(), equals('Nest'));
      });

      test('should handle camera device type', () {
        // Arrange
        final device = Device();
        device.type = 'camera';
        device.brand = 'Ring';

        // Act & Assert
        expect(device.type, equals('camera'));
        expect(device.getBrand(), equals('Ring'));
      });
    });

    group('Serial number validation tests', () {
      test('should handle positive serial number', () {
        // Arrange
        final device = Device();
        device.serialNumber = 123456789;

        // Act & Assert
        expect(device.serialNumber, equals(123456789));
        expect(device.toJson()['serial number'], equals(123456789));
      });

      test('should handle zero serial number', () {
        // Arrange
        final device = Device();
        device.serialNumber = 0;

        // Act & Assert
        expect(device.serialNumber, equals(0));
        expect(device.toJson()['serial number'], equals(0));
      });

      test('should handle negative serial number', () {
        // Arrange
        final device = Device();
        device.serialNumber = -1;

        // Act & Assert
        expect(device.serialNumber, equals(-1));
        expect(device.toJson()['serial number'], equals(-1));
      });
    });

    group('Brand validation tests', () {
      final brandTests = [
        'Philips',
        'Samsung',
        'Apple',
        'Google',
        'Amazon',
        'Yale',
        'Nest',
        'Ring',
        'Honeywell',
        'Ecobee'
      ];

      for (final brand in brandTests) {
        test('should handle $brand brand correctly', () {
          // Arrange
          final device = Device();
          device.brand = brand;

          // Act & Assert
          expect(device.getBrand(), equals(brand));
          expect(device.toJson()['brand'], equals(brand));
        });
      }

      test('should handle empty brand string', () {
        // Arrange
        final device = Device();
        device.brand = '';

        // Act & Assert
        expect(device.getBrand(), equals(''));
        expect(device.toJson()['brand'], equals(''));
      });

      test('should handle brand with special characters', () {
        // Arrange
        final device = Device();
        device.brand = 'Brand-Name_123';

        // Act & Assert
        expect(device.getBrand(), equals('Brand-Name_123'));
        expect(device.toJson()['brand'], equals('Brand-Name_123'));
      });
    });

    group('Device name validation tests', () {
      test('should handle descriptive device names', () {
        // Arrange
        final device = Device();
        device.deviceName = 'Living Room Smart Light';

        // Act & Assert
        expect(device.deviceName, equals('Living Room Smart Light'));
        expect(device.toJson()['name'], equals('Living Room Smart Light'));
      });

      test('should handle short device names', () {
        // Arrange
        final device = Device();
        device.deviceName = 'Lock';

        // Act & Assert
        expect(device.deviceName, equals('Lock'));
        expect(device.toJson()['name'], equals('Lock'));
      });

      test('should handle device names with numbers', () {
        // Arrange
        final device = Device();
        device.deviceName = 'Camera 1';

        // Act & Assert
        expect(device.deviceName, equals('Camera 1'));
        expect(device.toJson()['name'], equals('Camera 1'));
      });
    });

    group('Complete device configuration tests', () {
      test('should handle complete smart light configuration', () {
        // Arrange
        final device = Device();
        device.deviceId = 'light_001';
        device.deviceName = 'Kitchen Smart Bulb';
        device.serialNumber = 987654321;
        device.type = 'light';
        device.brand = 'Philips';
        device.uploadedImage = 'https://example.com/light.jpg';

        // Act
        final json = device.toJson();

        // Assert
        expect(json['id'], equals('light_001'));
        expect(json['name'], equals('Kitchen Smart Bulb'));
        expect(json['serial number'], equals(987654321));
        expect(json['type'], equals('light'));
        expect(json['brand'], equals('Philips'));
        expect(device.uploadedImage, equals('https://example.com/light.jpg'));
      });

      test('should handle complete door lock configuration', () {
        // Arrange
        final device = Device();
        device.deviceId = 'lock_001';
        device.deviceName = 'Front Door Smart Lock';
        device.serialNumber = 555666777;
        device.type = 'lock';
        device.brand = 'Yale';
        device.uploadedImage = 'https://example.com/lock.jpg';

        // Act
        final json = device.toJson();

        // Assert
        expect(json['id'], equals('lock_001'));
        expect(json['name'], equals('Front Door Smart Lock'));
        expect(json['serial number'], equals(555666777));
        expect(json['type'], equals('lock'));
        expect(json['brand'], equals('Yale'));
        expect(device.uploadedImage, equals('https://example.com/lock.jpg'));
      });
    });
  });
}