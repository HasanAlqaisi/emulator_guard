import 'package:device_info_plus/device_info_plus.dart';

import 'package:emulator_guard/methods/emulator_detection_method.dart';

/// Detection method that checks if the device serial number is "unknown".
///
/// This method examines the device's serial number property to detect emulators.
/// Many Android emulators return "unknown" as the serial number, which is uncommon
/// on physical devices that typically have unique serial numbers.
///
/// **Reliability**: Medium (70-80%)
/// - Good indicator for many emulators
/// - Some physical devices may also return "unknown" if serial is not available
/// - Easy to spoof by modifying device properties
///
/// **Score**: 15 points when serial number is "unknown"
///
/// **Performance**: Fast - only checks string property
class SerialNumberMethod extends EmulatorDetectionMethod {
  SerialNumberMethod({
    super.score = 15,
    super.reason = "Serial number is unknown",
  });

  @override
  Future<({double score, String? reason})> execute() async {
    final deviceInfo = await DeviceInfoPlugin().deviceInfo;

    if (deviceInfo is AndroidDeviceInfo) {
      if (deviceInfo.serialNumber.toLowerCase() == 'unknown') {
        return (score: score, reason: reason);
      }
    }

    return (score: 0.0, reason: null);
  }
}
