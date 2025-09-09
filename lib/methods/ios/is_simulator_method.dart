import 'package:device_info_plus/device_info_plus.dart';

import 'package:emulator_guard/methods/base_method.dart';

class IsSimulatorMethod extends BaseMethod {
  IsSimulatorMethod({
    super.score = 40,
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
