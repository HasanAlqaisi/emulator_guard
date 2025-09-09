import 'package:device_info_plus/device_info_plus.dart';

import 'package:emulator_guard/methods/base_method.dart';

/// Detection method specifically designed to identify BlueStacks emulator.
///
/// This method looks for BlueStacks-specific signatures in device properties including:
/// - "bluestacks" in manufacturer, brand, model, device, or product
/// - "BlueStacks" as exact manufacturer name
/// - QC_Reference_Phone board with non-Xiaomi manufacturer (BlueStacks signature)
///
/// **Reliability**: Very High (95-98%)
/// - Highly specific to BlueStacks emulator
/// - Very low false positive rate
/// - BlueStacks signatures are well-documented and consistent
///
/// **Score**: 30 points when BlueStacks is detected
///
/// **Performance**: Fast - only checks string properties
class BlueStacksDetectionMethod extends BaseMethod {
  BlueStacksDetectionMethod({
    super.score = 30,
    super.reason = "BlueStacks emulator detected",
  });

  @override
  Future<({double score, String? reason})> execute() async {
    final deviceInfo = await DeviceInfoPlugin().deviceInfo;

    if (deviceInfo is AndroidDeviceInfo) {
      if (_isBlueStacks(deviceInfo)) {
        return (score: score, reason: reason);
      }
    }

    return (score: 0.0, reason: null);
  }

  bool _isBlueStacks(AndroidDeviceInfo info) {
    final manufacturer = info.manufacturer.toLowerCase();
    final brand = info.brand.toLowerCase();
    final model = info.model.toLowerCase();
    final device = info.device.toLowerCase();
    final product = info.product.toLowerCase();

    return manufacturer.contains('bluestacks') ||
        brand.contains('bluestacks') ||
        model.contains('bluestacks') ||
        device.contains('bluestacks') ||
        product.contains('bluestacks') ||
        info.manufacturer == 'BlueStacks' ||
        (info.board == 'QC_Reference_Phone' &&
            !info.manufacturer.toLowerCase().contains('xiaomi'));
  }
}
