import 'package:device_info_plus/device_info_plus.dart';

import 'package:emulator_guard/methods/emulator_detection_method.dart';

/// Detection method that checks if the device has no system features.
///
/// This method examines the device's system features property to detect emulators.
/// Many Android emulators return an empty list as the system features value.
///
/// **Reliability**: Medium (70-80%)
/// - Good indicator for many emulators
/// - Easy to spoof by modifying device properties
///
/// **Score**: 5 points when system features are empty
///
/// **Performance**: Fast - only checks list property
class SystemFeaturesEmptyMethod extends EmulatorDetectionMethod {
  SystemFeaturesEmptyMethod({
    super.score = 5,
    super.reason = "No system features detected",
  });

  @override
  Future<({double score, String? reason})> execute() async {
    final deviceInfo = await DeviceInfoPlugin().deviceInfo;

    if (deviceInfo is AndroidDeviceInfo) {
      if (deviceInfo.systemFeatures.isEmpty) {
        return (score: score, reason: reason);
      }
    }

    return (score: 0.0, reason: null);
  }
}
