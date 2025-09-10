## 0.1.0+1
- Update README.md to fix the broken link


## 0.1.0

### Added

- **Comprehensive Android emulator detection** with 25+ detection methods
- **Multi-platform support** for Android, iOS, Linux, macOS, and Windows
- **Configurable scoring system** with customizable thresholds per platform
- **Detailed detection reporting** with specific reasons for each detection
- **Async file operations** for non-blocking emulator file detection

### Features

- **EmulatorGuard class** with platform-specific method configuration
- **Scoring system** (0-100 points) with configurable thresholds
- **Comprehensive result reporting** with detailed reasons
- **Easy integration** with simple API
- **Extensible architecture** for adding custom detection methods

### Usage

```dart
final detector = EmulatorGuard();
final result = await detector.detect();

print('Is Emulator: ${result.isEmulator}');
print('Score: ${result.score}');
print('Reasons: ${result.reasons.join(', ')}');
```
