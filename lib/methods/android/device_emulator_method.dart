import 'package:device_info_plus/device_info_plus.dart';

import 'package:emulator_guard/methods/emulator_detection_method.dart';

/// Detection method that checks if the device name contains "generic" or "emulator".
///
/// This method examines the device's device property to detect emulators.
/// Many Android emulators return "generic" or "emulator" as the device value.
///
/// **Reliability**: Medium (70-80%)
/// - Good indicator for many emulators
/// - Easy to spoof by modifying device properties
///
/// **Score**: 15 points when device name contains "generic" or "emulator"
///
/// **Performance**: Fast - only checks string property
class DeviceEmulatorMethod extends EmulatorDetectionMethod {
  DeviceEmulatorMethod({
    super.score = 15,
    super.reason = "Device name indicates emulator",
  });

  @override
  Future<({double score, String? reason})> execute() async {
    final deviceInfo = await DeviceInfoPlugin().deviceInfo;

    if (deviceInfo is AndroidDeviceInfo) {
      final device = deviceInfo.device.toLowerCase();

      if (device.contains('generic') || device.contains('emulator')) {
        return (score: score, reason: "$reason: $device");
      }
    }

    return (score: 0.0, reason: null);
  }
}
