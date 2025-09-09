import 'package:device_info_plus/device_info_plus.dart';
import 'package:emulator_guard/methods/methods.dart';
import 'package:emulator_guard/result.dart';

export 'package:emulator_guard/result.dart';

class EmulatorGuard {
  /// if none is provided, [allAndroidMethods] will be used
  final List<EmulatorDetectionMethod> androidMethods;

  /// The threshold for the emulator check result
  /// If the score is greater than the threshold, the device is considered NOT physical
  final double androidThreshold;

  /// if none is provided, [allIosMethods] will be used
  final List<EmulatorDetectionMethod> iosMethods;

  /// The threshold for the emulator check result
  /// If the score is greater than the threshold, the device is considered NOT physical
  final double iosThreshold;

  final List<EmulatorDetectionMethod> linuxMethods;

  /// The threshold for the emulator check result
  /// If the score is greater than the threshold, the device is considered NOT physical
  final double linuxThreshold;

  final List<EmulatorDetectionMethod> macOsMethods;

  /// The threshold for the emulator check result
  /// If the score is greater than the threshold, the device is considered NOT physical
  final double macOsThreshold;

  final List<EmulatorDetectionMethod> windowsMethods;

  /// The threshold for the emulator check result
  /// If the score is greater than the threshold, the device is considered NOT physical
  final double windowsThreshold;

  EmulatorGuard({
    List<EmulatorDetectionMethod>? androidMethods,
    List<EmulatorDetectionMethod>? iosMethods,
    List<EmulatorDetectionMethod>? linuxMethods,
    List<EmulatorDetectionMethod>? macOsMethods,
    List<EmulatorDetectionMethod>? windowsMethods,
    this.androidThreshold = 50,
    this.iosThreshold = 50,
    this.linuxThreshold = 50,
    this.macOsThreshold = 50,
    this.windowsThreshold = 50,
  }) : androidMethods = androidMethods ?? allAndroidMethods,
       iosMethods = iosMethods ?? allIosMethods,
       linuxMethods = linuxMethods ?? [],
       macOsMethods = macOsMethods ?? [],
       windowsMethods = windowsMethods ?? [];

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
    List<EmulatorDetectionMethod> methods,
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
