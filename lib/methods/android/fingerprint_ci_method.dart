import 'package:device_info_plus/device_info_plus.dart';

import 'package:emulator_guard/methods/base_method.dart';

/// Detection method that checks for CI/CD artifacts in device fingerprint.
///
/// This method examines the device's fingerprint property for continuous integration
/// artifacts, specifically looking for "jenkins" which is commonly found in
/// automated build environments and emulators used for testing.
///
/// **Reliability**: High (80-90%)
/// - Very specific indicator for CI/CD environments and test emulators
/// - Low false positive rate as "jenkins" is rarely found in production devices
/// - Indicates automated testing or development environment usage
///
/// **Score**: 10 points when CI artifacts are detected in fingerprint
///
/// **Performance**: Fast - only checks string property
class FingerprintCIMethod extends BaseMethod {
  FingerprintCIMethod({
    super.score = 10,
    super.reason = "Fingerprint contains CI artifact",
  });

  @override
  Future<({double score, String? reason})> execute() async {
    final deviceInfo = await DeviceInfoPlugin().deviceInfo;

    if (deviceInfo is AndroidDeviceInfo) {
      if (deviceInfo.fingerprint.toLowerCase().contains('jenkins')) {
        return (score: score, reason: "$reason ${deviceInfo.fingerprint}");
      }
    }

    return (score: 0.0, reason: null);
  }
}
