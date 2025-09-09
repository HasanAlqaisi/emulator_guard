# Emulator Guard

  

[![pub package](https://img.shields.io/pub/v/emulator_guard.svg)](https://pub.dev/packages/emulator_guard)

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

  

A comprehensive Flutter package for detecting emulators and simulators across multiple platforms. Emulator Guard uses multiple detection methods and provides a scoring system to determine the likelihood that a device is an emulator.

  
> ⚠️ Disclaimer
>
> Detection heuristics can produce false positives and may become outdated as emulator vendors evolve. This package has not been tested across a wide range of real devices and emulator variants. Treat results as indicators rather than proof, tune thresholds for your use case, and combine with additional signals where possible.

  

## ✨ Features

  

-  **🌍 Multi-platform support**: Works on Android, iOS, Linux, macOS, and Windows

-  **🔍 Comprehensive detection**: Uses 25+ different detection methods for Android alone

-  **⚙️ Configurable thresholds**: Customize sensitivity for different platforms

-  **📊 Detailed reporting**: Provides reasons and scores for detection results

-  **🚀 Async operations**: Non-blocking file system checks for better performance

-  **📚 Well documented**: Each detection method includes reliability scores and explanations

  

## 🚀 Getting Started

  

### Installation

  

Add this to your package's `pubspec.yaml` file:

  

```yaml
dependencies:
  emulator_guard: ^0.0.1
```

  

Then run:

  

```bash
flutter pub get
```

  

### Basic Usage

  

```dart
import 'package:emulator_guard/emulator_guard.dart';

Future<void> main() async {
  // Create detector instance
  final detector = EmulatorGuard();

  // Detect if device is an emulator
  final result = await detector.detect();

  // Check results
  print('Is Emulator: ${result.isEmulator}');
  print('Emulator Score: ${result.score}');
  print('Detection Reasons: ${result.reasons.join(', ')}');

  // Handle based on result
  if (result.isEmulator) {
    print('⚠️ Emulator detected! Score: ${result.score}');
    print('Reasons: ${result.reasons.join(', ')}');
  } else {
    print('✅ Physical device detected');
  }
}
```

  

### Advanced Usage

  

```dart
// Custom configuration with different thresholds
final customDetector = EmulatorGuard(
  androidThreshold: 30, // Lower threshold = more sensitive
  iosThreshold: 40,
  linuxThreshold: 25,
  macOsThreshold: 35,
  windowsThreshold: 45,
);

// Use custom detection methods
final customAndroidDetector = EmulatorGuard(
  androidMethods: [
    // Your custom detection methods
  ],
);

final result = await customDetector.detect();
```

  

## 🔍 Detection Methods

  

### Android Detection Methods

  

Emulator Guard includes 25+ detection methods for Android with different reliability scores:

  

#### **File-based Detection** (90-95% reliability)

-  **EmulatorFilesMethod**: Checks for QEMU, Genymotion, and emulator-specific files

-  **LDPlayerDetectionMethod**: Detects LDPlayer emulator files and properties

-  **MEmuDetectionMethod**: Identifies MEmu emulator files and signatures

  

#### **Hardware Analysis** (85-98% reliability)

-  **HardwareEmulatorMethod**: Detects goldfish/ranchu hardware signatures

-  **HardwareX86Method**: Identifies x86 architecture and virtualization indicators

  

#### **System Properties** (70-90% reliability)

-  **SerialNumberMethod**: Checks for "unknown" serial numbers

-  **ManufacturerUnknownMethod**: Detects unknown/empty manufacturer

-  **BootloaderMethod**: Identifies unknown bootloader values

-  **BuildTypeMethod**: Flags development build types (userdebug, eng)

  

#### **Resource Analysis** (60-80% reliability)

-  **AvailableRamMethod**: Detects unusually low RAM ratios

-  **FreeDiskSpaceMethod**: Identifies unusually high free disk space

  

#### **Emulator-specific Detection** (90-98% reliability)

-  **BlueStacksDetectionMethod**: Specifically targets BlueStacks emulator

-  **FingerprintCIMethod**: Detects CI/CD artifacts in device fingerprint

  

### iOS Detection Methods

  

iOS detection methods are available and can be customized for your specific needs.

  

## 📊 Scoring System

  

-  **Score Range**: 0-100 points

-  **Threshold**: Configurable per platform (default: 50 points)

-  **Decision**: If total score > threshold → device is considered an emulator

-  **Reliability**: Each method includes reliability percentage and detailed explanations

  

### Score Examples

  

```dart
// Low score - likely physical device
EmulatorCheckResult(
  score: 15.0,
  isEmulator: false,
  reasons: [],
);

// High score - likely emulator
EmulatorCheckResult(
  score: 75.0,
  isEmulator: true,
  reasons: [
    'Hardware or board indicates emulator: goldfish',
    'Emulator-specific files detected: /dev/qemu_pipe',
    'Serial number is unknown',
  ],
);
```

  

## 🛠️ Configuration

  

### Platform Thresholds

  

```dart
final detector = EmulatorGuard(
  androidThreshold: 50, // Android detection threshold
  iosThreshold: 40,     // iOS detection threshold
  linuxThreshold: 30,   // Linux detection threshold
  macOsThreshold: 35,   // macOS detection threshold
  windowsThreshold: 45, // Windows detection threshold
);
```

  

### Custom Detection Methods

  

```dart
class CustomDetectionMethod extends BaseMethod {
  CustomDetectionMethod() : super(score: 25, reason: 'Custom detection');

  @override
  Future<({double score, String? reason})> execute() async {
    // Your custom detection logic
    final condition = false; // replace with your logic
    if (condition) {
      return (score: score, reason: reason);
    }
    return (score: 0.0, reason: null);
  }
}

final detector = EmulatorGuard(
  androidMethods: [
    CustomDetectionMethod(),
    // ... other methods
  ],
);
```

  

## 📈 Performance

  

-  **Async file operations**: Non-blocking file system checks

-  **Parallel execution**: Multiple detection methods run concurrently

-  **Fast property checks**: String and numeric property validation

-  **Efficient scoring**: Optimized calculation and aggregation

  

## 🔒 Security Considerations

  

-  **False positives**: Some methods may flag rooted devices or development environments

-  **Spoofing**: Advanced emulators may hide detection indicators

-  **Threshold tuning**: Adjust thresholds based on your specific use case

-  **Regular updates**: Detection methods may need updates as emulators evolve

  

## 🤝 Contributing

  

Contributions are welcome! Please feel free to submit a Pull Request.

  

1. Fork the repository

2. Create your feature branch (`git checkout -b feature/amazing-feature`)

3. Commit your changes (`git commit -m 'Add some amazing feature'`)

4. Push to the branch (`git push origin feature/amazing-feature`)

5. Open a Pull Request

  

## 📄 License

  

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

  

## 🙏 Acknowledgments

  

- [device_info_plus](https://pub.dev/packages/device_info_plus) for device information

  

## 📞 Support

  

If you encounter any issues or have questions:

  

1. Check the [Issues](https://github.com/your-repo/emulator_guard/issues) page

2. Create a new issue with detailed information