import 'package:device_info_plus/device_info_plus.dart';

import 'package:emulator_guard/methods/base_method.dart';

/// Detection method that checks if the device host name contains "jenkins" or "build".
///
/// This method examines the device's host property to detect emulators.
/// Many Android emulators return "jenkins" or "build" as the host value, which is
/// uncommon on physical devices that typically have specific host names.
///
/// **Reliability**: Medium (70-80%)
/// - Good indicator for many emulators
/// - Easy to spoof by modifying device properties
///
/// **Score**: 10 points when host name contains "jenkins" or "build"
///
/// **Performance**: Fast - only checks string property
class HostCIMethod extends BaseMethod {
  HostCIMethod({
    super.score = 10,
    super.reason = "Host name indicates CI / emulator",
  });

  @override
  Future<({double score, String? reason})> execute() async {
    final deviceInfo = await DeviceInfoPlugin().deviceInfo;

    if (deviceInfo is AndroidDeviceInfo) {
      final host = deviceInfo.host.toLowerCase();

      if (host.contains('jenkins') || host.contains('build')) {
        return (score: score, reason: "$reason $host");
      }
    }

    return (score: 0.0, reason: null);
  }
}
