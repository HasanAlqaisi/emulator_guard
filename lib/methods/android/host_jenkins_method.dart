import 'package:device_info_plus/device_info_plus.dart';

import 'package:emulator_guard/methods/emulator_detection_method.dart';

/// Detection method that checks if the device host name contains "jenkins".
///
/// This method examines the device's host property to detect emulators.
/// Many Android emulators return "jenkins" as the host value, which is
/// uncommon on physical devices that typically have specific host names.
///
/// **Reliability**: Medium (70-80%)
/// - Good indicator for many emulators
/// - Easy to spoof by modifying device properties
///
/// **Score**: 5 points when host name contains "jenkins"
///
/// **Performance**: Fast - only checks string property
class HostJenkinsMethod extends EmulatorDetectionMethod {
  HostJenkinsMethod({super.score = 5, super.reason = "Host name suspicious"});

  @override
  Future<({double score, String? reason})> execute() async {
    final deviceInfo = await DeviceInfoPlugin().deviceInfo;

    if (deviceInfo is AndroidDeviceInfo) {
      if (deviceInfo.host.toLowerCase().contains('jenkins')) {
        return (score: score, reason: "$reason: ${deviceInfo.host}");
      }
    }

    return (score: 0.0, reason: null);
  }
}
