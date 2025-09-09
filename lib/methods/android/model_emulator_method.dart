import 'package:device_info_plus/device_info_plus.dart';

import 'package:emulator_guard/methods/base_method.dart';

/// Detection method that checks if the device model contains "sdk_gphone" or "emulator".
///
/// This method examines the device's model property to detect emulators.
/// Many Android emulators return "sdk_gphone" or "emulator" as the model value.
///
/// **Reliability**: Medium (70-80%)
/// - Good indicator for many emulators
/// - Easy to spoof by modifying device properties
///
/// **Score**: 20 points when model contains "sdk_gphone" or "emulator"
///
/// **Performance**: Fast - only checks string property
class ModelEmulatorMethod extends BaseMethod {
  ModelEmulatorMethod({
    super.score = 20,
    super.reason = "Model indicates emulator",
  });

  @override
  Future<({double score, String? reason})> execute() async {
    final deviceInfo = await DeviceInfoPlugin().deviceInfo;

    if (deviceInfo is AndroidDeviceInfo) {
      final model = deviceInfo.model.toLowerCase();

      if (model.contains('sdk_gphone') || model.contains('emulator')) {
        return (score: score, reason: "$reason: $model");
      }
    }

    return (score: 0.0, reason: null);
  }
}
