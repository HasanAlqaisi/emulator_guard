import 'package:device_info_plus/device_info_plus.dart';

import 'package:emulator_guard/methods/emulator_detection_method.dart';

/// Detection method that checks if the device model and CPU mismatch.
///
/// This method examines the device's model and hardware properties to detect emulators.
/// Many Android emulators return "sm-g" as the model and "x86" as the hardware, which is
/// uncommon on physical devices that typically have specific model and hardware names.
///
/// **Reliability**: Medium (70-80%)
/// - Good indicator for many emulators
/// - Easy to spoof by modifying device properties
///
/// **Score**: 10 points when model contains "sm-g" and hardware contains "x86"
///
/// **Performance**: Fast - only checks string properties
class ModelCpuMismatchMethod extends EmulatorDetectionMethod {
  ModelCpuMismatchMethod({
    super.score = 10,
    super.reason = "Model looks real but CPU indicates emulator",
  });

  @override
  Future<({double score, String? reason})> execute() async {
    final deviceInfo = await DeviceInfoPlugin().deviceInfo;

    if (deviceInfo is AndroidDeviceInfo) {
      final model = deviceInfo.model.toLowerCase();
      final hw = deviceInfo.hardware.toLowerCase();

      if (model.contains('sm-g') && hw.contains('x86')) {
        return (score: score, reason: reason);
      }
    }

    return (score: 0.0, reason: null);
  }
}
