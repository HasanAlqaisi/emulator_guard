import 'package:device_info_plus/device_info_plus.dart';

import 'package:emulator_guard/methods/base_method.dart';

/// Detection method that checks if the device product name contains "sdk", "emulator", or "generic".
///
/// This method examines the device's product property to detect emulators.
/// Many Android emulators return "sdk", "emulator", or "generic" as the product value.
///
/// **Reliability**: Medium (70-80%)
/// - Good indicator for many emulators
/// - Easy to spoof by modifying device properties
///
/// **Score**: 15 points when product name contains "sdk", "emulator", or "generic"
///
/// **Performance**: Fast - only checks string property
class ProductEmulatorMethod extends BaseMethod {
  ProductEmulatorMethod({
    super.score = 15,
    super.reason = "Product name indicates emulator",
  });

  @override
  Future<({double score, String? reason})> execute() async {
    final deviceInfo = await DeviceInfoPlugin().deviceInfo;

    if (deviceInfo is AndroidDeviceInfo) {
      final product = deviceInfo.product.toLowerCase();

      if (product.contains('sdk') ||
          product.contains('emulator') ||
          product.contains('generic')) {
        return (score: score, reason: "$reason: $product");
      }
    }

    return (score: 0.0, reason: null);
  }
}
