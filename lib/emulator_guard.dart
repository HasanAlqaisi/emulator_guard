import 'package:device_info_plus/device_info_plus.dart';
import 'package:emulator_guard/methods/methods.dart';
import 'package:emulator_guard/result.dart';

export 'package:emulator_guard/result.dart';

/// A comprehensive Flutter package for detecting emulators and simulators across multiple platforms.
///
/// EmulatorGuard uses multiple detection methods and provides a scoring system to determine
/// the likelihood that a device is an emulator. It supports Android, iOS, Linux, macOS, and Windows
/// with platform-specific detection methods and configurable thresholds.
///
/// ## Features
/// - **Multi-platform support**: Works on Android, iOS, Linux, macOS, and Windows
/// - **Comprehensive detection**: Uses 25+ different detection methods for Android alone
/// - **Configurable thresholds**: Customize sensitivity for different platforms
/// - **Detailed reporting**: Provides reasons and scores for detection results
/// - **Async file operations**: Non-blocking file system checks for better performance
///
/// ## Usage
/// ```dart
/// final detector = EmulatorGuard();
/// final result = await detector.detect();
///
/// print('Is Physical Device: ${result.isPhysical}');
/// print('Emulator Score: ${result.score}');
/// print('Reasons: ${result.reasons.join(', ')}');
/// ```
///
/// ## Detection Methods
/// Each platform supports various detection methods with different reliability scores:
/// - **File-based detection**: Checks for emulator-specific files and directories
/// - **Hardware analysis**: Examines device hardware and board properties
/// - **System properties**: Analyzes device manufacturer, model, and other properties
/// - **Resource analysis**: Checks RAM, disk space, and other resource indicators
/// - **Emulator-specific detection**: Identifies specific emulators like BlueStacks, LDPlayer, MEmu
///
/// ## Scoring System
/// - Each detection method contributes a score (0-100 points)
/// - Total score is compared against the platform threshold
/// - If total score > threshold, device is considered an emulator
/// - Default threshold is 50 points for all platforms
class EmulatorGuard {
  /// if none is provided, [allAndroidMethods] will be used
  final List<BaseMethod> androidMethods;

  /// The threshold for the emulator check result
  /// If the score is greater than the threshold, the device is considered NOT physical
  final double androidThreshold;

  /// if none is provided, [allIosMethods] will be used
  final List<BaseMethod> iosMethods;

  /// The threshold for the emulator check result
  /// If the score is greater than the threshold, the device is considered NOT physical
  final double iosThreshold;

  final List<BaseMethod> linuxMethods;

  /// The threshold for the emulator check result
  /// If the score is greater than the threshold, the device is considered NOT physical
  final double linuxThreshold;

  final List<BaseMethod> macOsMethods;

  /// The threshold for the emulator check result
  /// If the score is greater than the threshold, the device is considered NOT physical
  final double macOsThreshold;

  final List<BaseMethod> windowsMethods;

  /// The threshold for the emulator check result
  /// If the score is greater than the threshold, the device is considered NOT physical
  final double windowsThreshold;

  EmulatorGuard({
    List<BaseMethod>? androidMethods,
    List<BaseMethod>? iosMethods,
    this.linuxMethods = const [],
    this.macOsMethods = const [],
    this.windowsMethods = const [],
    this.androidThreshold = 50,
    this.iosThreshold = 50,
    this.linuxThreshold = 50,
    this.macOsThreshold = 50,
    this.windowsThreshold = 50,
  }) : androidMethods = androidMethods ?? allAndroidMethods,
       iosMethods = iosMethods ?? allIosMethods;

  /// Detects if the current device is an emulator or physical device.
  ///
  /// This method automatically detects the current platform and runs the appropriate
  /// detection methods for that platform. It returns a comprehensive result including
  /// the emulator likelihood score, whether the device is physical, and detailed reasons.
  ///
  /// Returns:
  /// - [EmulatorCheckResult] containing the detection results
  ///
  /// Throws:
  /// - Platform-specific exceptions if device info cannot be retrieved
  Future<EmulatorCheckResult> detect() async {
    final deviceInfo = await DeviceInfoPlugin().deviceInfo;

    switch (deviceInfo) {
      case AndroidDeviceInfo():
        final (:reasons, :totalScore) = await _calculateScore(androidMethods);
        return EmulatorCheckResult(
          score: totalScore > 100 ? 100 : totalScore,
          isEmulator: totalScore >= androidThreshold,
          reasons: reasons,
        );
      case IosDeviceInfo():
        final (:reasons, :totalScore) = await _calculateScore(iosMethods);
        return EmulatorCheckResult(
          score: totalScore > 100 ? 100 : totalScore,
          isEmulator: totalScore >= iosThreshold,
          reasons: reasons,
        );
      case LinuxDeviceInfo():
        final (:reasons, :totalScore) = await _calculateScore(linuxMethods);
        return EmulatorCheckResult(
          score: totalScore > 100 ? 100 : totalScore,
          isEmulator: totalScore >= linuxThreshold,
          reasons: reasons,
        );
      case MacOsDeviceInfo():
        final (:reasons, :totalScore) = await _calculateScore(macOsMethods);
        return EmulatorCheckResult(
          score: totalScore > 100 ? 100 : totalScore,
          isEmulator: totalScore >= macOsThreshold,
          reasons: reasons,
        );
      case WindowsDeviceInfo():
        final (:reasons, :totalScore) = await _calculateScore(windowsMethods);
        return EmulatorCheckResult(
          score: totalScore > 100 ? 100 : totalScore,
          isEmulator: totalScore >= windowsThreshold,
          reasons: reasons,
        );
      case BaseDeviceInfo():
        return EmulatorCheckResult(score: 100.0, isEmulator: true, reasons: []);
    }
  }

  Future<({double totalScore, List<String> reasons})> _calculateScore(
    List<BaseMethod> methods,
  ) async {
    final executeResults = methods.map((method) => method.execute()).toList();
    final result = await Future.wait(executeResults);
    final totalScore = result.fold<double>(0, (sum, e) => sum + e.score);
    return (
      totalScore: totalScore,
      reasons: result
          .where((e) => e.reason != null)
          .map((e) => e.reason!)
          .toList(),
    );
  }
}
