import 'package:device_info_plus/device_info_plus.dart';

import 'package:emulator_guard/methods/emulator_detection_method.dart';

/// Detection method that checks for x86-based hardware indicators.
///
/// This method examines the device's hardware property for x86 architecture and
/// virtualization indicators that are commonly found in emulators:
/// - "goldfish" (Android emulator hardware)
/// - "ranchu" (Android emulator hardware)
/// - "x86" (x86 architecture, common in emulators)
/// - "vbox" (VirtualBox virtualization)
///
/// **Reliability**: High (85-95%)
/// - Very reliable for detecting x86-based emulators
/// - Low false positive rate as these are specific emulator signatures
/// - Some physical devices may use x86 architecture but rarely with these specific strings
///
/// **Score**: 20 points when x86/virtualization hardware is detected
///
/// **Performance**: Fast - only checks string property
class HardwareX86Method extends EmulatorDetectionMethod {
  HardwareX86Method({
    super.score = 20,
    super.reason = "Hardware indicates emulator",
  });

  @override
  Future<({double score, String? reason})> execute() async {
    final deviceInfo = await DeviceInfoPlugin().deviceInfo;

    if (deviceInfo is AndroidDeviceInfo) {
      final hw = deviceInfo.hardware.toLowerCase();

      if (hw.contains('goldfish') ||
          hw.contains('ranchu') ||
          hw.contains('x86') ||
          hw.contains('vbox')) {
        return (score: score, reason: "$reason: $hw");
      }
    }

    return (score: 0.0, reason: null);
  }
}
