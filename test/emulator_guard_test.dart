import 'package:emulator_guard/emulator_guard.dart';
import 'package:emulator_guard/methods/base_method.dart';
import 'package:emulator_guard/result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Initialize Flutter binding for tests that need it
  TestWidgetsFlutterBinding.ensureInitialized();

  group('EmulatorCheckResult', () {
    test('should create result with correct properties', () {
      final reasons = ['Test reason 1', 'Test reason 2'];
      final result = EmulatorCheckResult(
        score: 75.5,
        isEmulator: false,
        reasons: reasons,
      );

      expect(result.score, 75.5);
      expect(result.isEmulator, false);
      expect(result.reasons, reasons);
    });

    test('should create result with empty reasons', () {
      final result = EmulatorCheckResult(
        score: 0.0,
        isEmulator: true,
        reasons: [],
      );

      expect(result.score, 0.0);
      expect(result.isEmulator, true);
      expect(result.reasons, isEmpty);
    });

    test('should have correct toString representation', () {
      final reasons = ['Low RAM', 'Emulator files detected'];
      final result = EmulatorCheckResult(
        score: 60.0,
        isEmulator: false,
        reasons: reasons,
      );

      final stringRepresentation = result.toString();
      expect(stringRepresentation, contains('Emulator Likelihood Score: 60.0'));
      expect(stringRepresentation, contains('Is Emulator: false'));
      expect(stringRepresentation, contains('Reasons:'));
      expect(stringRepresentation, contains('- Low RAM'));
      expect(stringRepresentation, contains('- Emulator files detected'));
    });
  });

  group('BaseMethod', () {
    test('should create method with score and reason', () {
      final method = TestBaseMethod(score: 25.0, reason: 'Test reason');

      expect(method.score, 25.0);
      expect(method.reason, 'Test reason');
    });

    test('should create method with score only', () {
      final method = TestBaseMethod(score: 15.0);

      expect(method.score, 15.0);
      expect(method.reason, isNull);
    });
  });

  group('EmulatorGuard', () {
    test('should create with default values', () {
      final guard = EmulatorGuard();

      expect(guard.androidMethods, isNotEmpty);
      expect(guard.iosMethods, isNotEmpty);
      expect(guard.linuxMethods, isEmpty);
      expect(guard.macOsMethods, isEmpty);
      expect(guard.windowsMethods, isEmpty);
      expect(guard.androidThreshold, 50);
      expect(guard.iosThreshold, 50);
      expect(guard.linuxThreshold, 50);
      expect(guard.macOsThreshold, 50);
      expect(guard.windowsThreshold, 50);
    });

    test('should create with custom values', () {
      final customMethods = [TestBaseMethod(score: 10.0)];
      final guard = EmulatorGuard(
        androidMethods: customMethods,
        iosMethods: customMethods,
        androidThreshold: 30,
        iosThreshold: 40,
      );

      expect(guard.androidMethods, customMethods);
      expect(guard.iosMethods, customMethods);
      expect(guard.androidThreshold, 30);
      expect(guard.iosThreshold, 40);
    });

    test('should handle empty methods list', () {
      final guard = EmulatorGuard(androidMethods: []);

      // Test that the guard is created with empty methods
      expect(guard.androidMethods, isEmpty);
    });
  });

  group('IsEmulatorDetector', () {
    test('should create with default values', () {
      final detector = EmulatorGuard();

      expect(detector.androidMethods, isNotEmpty);
      expect(detector.iosMethods, isNotEmpty);
      expect(detector.linuxMethods, isEmpty);
      expect(detector.macOsMethods, isEmpty);
      expect(detector.windowsMethods, isEmpty);
      expect(detector.androidThreshold, 50);
      expect(detector.iosThreshold, 50);
      expect(detector.linuxThreshold, 50);
      expect(detector.macOsThreshold, 50);
      expect(detector.windowsThreshold, 50);
    });

    test('should create with custom values', () {
      final customMethods = [TestBaseMethod(score: 20.0)];
      final detector = EmulatorGuard(
        androidMethods: customMethods,
        iosMethods: customMethods,
        androidThreshold: 25,
        iosThreshold: 35,
      );

      expect(detector.androidMethods, customMethods);
      expect(detector.iosMethods, customMethods);
      expect(detector.androidThreshold, 25);
      expect(detector.iosThreshold, 35);
    });
  });

  group('Platform Detection', () {
    test('should have all platform methods configured', () {
      final guard = EmulatorGuard();

      // Test that all platform methods are properly configured
      expect(guard.androidMethods, isNotEmpty);
      expect(guard.iosMethods, isNotEmpty);
      expect(guard.linuxMethods, isEmpty);
      expect(guard.macOsMethods, isEmpty);
      expect(guard.windowsMethods, isEmpty);
    });
  });
}

// Test helper class for BaseMethod
class TestBaseMethod extends BaseMethod {
  TestBaseMethod({required super.score, super.reason});

  @override
  Future<({double score, String? reason})> execute() async {
    return (score: score, reason: reason);
  }
}
