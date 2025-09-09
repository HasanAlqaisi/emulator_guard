import 'package:device_info_plus/device_info_plus.dart';

import 'package:emulator_guard/methods/base_method.dart';

/// Detection method that checks if the device has Pixel-exclusive features.
///
/// This method examines the device's brand and system features to detect emulators.
/// Many Android emulators return "google" as the brand and have Pixel-exclusive features.
///
/// **Reliability**: Medium (70-80%)
/// - Good indicator for many emulators
/// - Some physical devices may have custom rom with Pixel-exclusive features
/// - Easy to spoof by modifying device properties
///
/// **Score**: 15 points when brand is "google" and system features contain "pixel"
///
/// **Performance**: Fast - only checks string properties
class PixelFeaturesMethod extends BaseMethod {
  PixelFeaturesMethod({
    super.score = 15,
    super.reason = "Pixel-exclusive features detected on non-Pixel device",
  });

  @override
  Future<({double score, String? reason})> execute() async {
    final deviceInfo = await DeviceInfoPlugin().deviceInfo;

    if (deviceInfo is AndroidDeviceInfo) {
      final brand = deviceInfo.brand.toLowerCase();

      if (brand != 'google') {
        if (deviceInfo.systemFeatures.any(
          (f) => f.toLowerCase().contains('pixel'),
        )) {
          return (score: score, reason: reason);
        }
      }
    }

    return (score: 0.0, reason: null);
  }
}
