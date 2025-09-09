import 'package:device_info_plus/device_info_plus.dart';

import 'package:emulator_guard/methods/base_method.dart';

/// Detection method that checks if the device bootloader is "unknown".
///
/// This method examines the device's bootloader property to detect emulators.
/// Many Android emulators return "unknown" as the bootloader value, which is
/// uncommon on physical devices that typically have specific bootloader versions.
///
/// **Reliability**: Medium (65-75%)
/// - Good indicator for many emulators
/// - Some physical devices may also return "unknown" if bootloader info is unavailable
/// - Easy to spoof by modifying device properties
///
/// **Score**: 5 points when bootloader is "unknown"
///
/// **Performance**: Fast - only checks string property
class BootloaderMethod extends BaseMethod {
  BootloaderMethod({super.score = 5, super.reason = "Bootloader is unknown"});

  @override
  Future<({double score, String? reason})> execute() async {
    final deviceInfo = await DeviceInfoPlugin().deviceInfo;

    if (deviceInfo is AndroidDeviceInfo) {
      if (deviceInfo.bootloader.toLowerCase() == 'unknown') {
        return (score: score, reason: reason);
      }
    }

    return (score: 0.0, reason: null);
  }
}
