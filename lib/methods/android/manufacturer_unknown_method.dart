import 'package:device_info_plus/device_info_plus.dart';

import 'package:emulator_guard/methods/base_method.dart';

/// Detection method that checks if the device manufacturer is unknown or empty.
///
/// This method examines the device's manufacturer property to detect emulators.
/// Many Android emulators return "unknown" or empty string as the manufacturer,
/// which is uncommon on physical devices that typically have specific manufacturer
/// names like "Samsung", "Google", "OnePlus", etc.
///
/// **Reliability**: Medium (70-80%)
/// - Good indicator for many emulators
/// - Some physical devices may also return "unknown" if manufacturer info is unavailable
/// - Easy to spoof by modifying device properties
///
/// **Score**: 10 points when manufacturer is "unknown" or empty
///
/// **Performance**: Fast - only checks string property
class ManufacturerUnknownMethod extends BaseMethod {
  ManufacturerUnknownMethod({
    super.score = 10,
    super.reason = "Manufacturer is unknown or empty",
  });

  @override
  Future<({double score, String? reason})> execute() async {
    final deviceInfo = await DeviceInfoPlugin().deviceInfo;

    if (deviceInfo is AndroidDeviceInfo) {
      if (deviceInfo.manufacturer.toLowerCase() == 'unknown' ||
          deviceInfo.manufacturer.isEmpty) {
        return (score: score, reason: reason);
      }
    }

    return (score: 0.0, reason: null);
  }
}
