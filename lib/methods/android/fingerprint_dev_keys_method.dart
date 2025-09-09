import 'package:device_info_plus/device_info_plus.dart';

import 'package:emulator_guard/methods/emulator_detection_method.dart';

/// Detection method that checks if the device fingerprint contains "dev-keys".
///
/// This method examines the device's fingerprint property to detect emulators.
/// Many Android emulators return "dev-keys" as the fingerprint value, which is
/// uncommon on physical devices that typically have specific fingerprint values.
///
/// **Reliability**: Medium (70-80%)
/// - Good indicator for many emulators
/// - Easy to spoof by modifying device properties
///
/// **Score**: 15 points when fingerprint contains "dev-keys"
///
/// **Performance**: Fast - only checks string property
class FingerprintDevKeysMethod extends EmulatorDetectionMethod {
  FingerprintDevKeysMethod({
    super.score = 15,
    super.reason = "Fingerprint contains dev-keys",
  });

  @override
  Future<({double score, String? reason})> execute() async {
    final deviceInfo = await DeviceInfoPlugin().deviceInfo;

    if (deviceInfo is AndroidDeviceInfo) {
      if (deviceInfo.fingerprint.contains('dev-keys')) {
        return (score: score, reason: reason);
      }
    }

    return (score: 0.0, reason: null);
  }
}
