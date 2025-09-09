import 'package:device_info_plus/device_info_plus.dart';

import 'package:emulator_guard/methods/base_method.dart';

/// Detection method that checks if the device brand and model mismatch with the CPU architecture.
///
/// This method examines the device's brand and hardware properties to detect emulators.
/// Many Android emulators return "samsung" as the brand and "x86" as the hardware, which is
/// uncommon on physical devices that typically have specific brand and hardware names.
///
/// **Reliability**: Medium (70-80%)
/// - Good indicator for many emulators
/// - Easy to spoof by modifying device properties
///
/// **Score**: 15 points when brand is "samsung" and hardware contains "x86"
///
/// **Performance**: Fast - only checks string properties
class BrandModelMismatchMethod extends BaseMethod {
  BrandModelMismatchMethod({
    super.score = 15,
    super.reason = "Brand/model mismatch with CPU architecture",
  });

  @override
  Future<({double score, String? reason})> execute() async {
    final deviceInfo = await DeviceInfoPlugin().deviceInfo;

    if (deviceInfo is AndroidDeviceInfo) {
      final brand = deviceInfo.brand.toLowerCase();
      final hw = deviceInfo.hardware.toLowerCase();

      if (brand == 'samsung' && hw.contains('x86')) {
        return (score: score, reason: reason);
      }
    }

    return (score: 0.0, reason: null);
  }
}
