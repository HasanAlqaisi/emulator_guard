import 'package:device_info_plus/device_info_plus.dart';

import 'package:emulator_guard/methods/emulator_detection_method.dart';

/// Detection method that checks if the device is a simulator from device_info_plus package.
class IsSimulatorMethod extends EmulatorDetectionMethod {
  IsSimulatorMethod({
    super.score = 100,
    super.reason = "DeviceInfo.isPhysicalDevice is false",
  });

  @override
  Future<({double score, String? reason})> execute() async {
    final deviceInfo = await DeviceInfoPlugin().deviceInfo;

    if (deviceInfo is IosDeviceInfo) {
      if (deviceInfo.isPhysicalDevice == false) {
        return (score: score, reason: reason);
      }
    }

    return (score: 0.0, reason: null);
  }
}
