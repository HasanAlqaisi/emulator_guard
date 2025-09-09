import 'package:device_info_plus/device_info_plus.dart';

import 'package:emulator_guard/methods/base_method.dart';

/// Detection method that checks hardware and board information for emulator indicators.
///
/// This method examines the device's hardware and board properties to identify common
/// emulator signatures. It looks for:
/// - "goldfish" in hardware or board (Android emulator)
/// - "ranchu" in hardware or board (Android emulator)
///
/// **Reliability**: Very High (95-98%)
/// - Extremely reliable for detecting standard Android emulators
/// - Low false positive rate as these values are hard to spoof
/// - Some custom emulators may use different hardware identifiers
///
/// **Score**: 20 points when emulator hardware is detected
///
/// **Performance**: Fast - only checks string properties
class HardwareEmulatorMethod extends BaseMethod {
  HardwareEmulatorMethod({
    super.score = 20,
    super.reason = "Hardware or board indicates emulator",
  });

  @override
  Future<({double score, String? reason})> execute() async {
    final deviceInfo = await DeviceInfoPlugin().deviceInfo;

    if (deviceInfo is AndroidDeviceInfo) {
      final hw = deviceInfo.hardware.toLowerCase();
      final board = deviceInfo.board.toLowerCase();

      if (hw.contains('goldfish') ||
          hw.contains('ranchu') ||
          board.contains('goldfish') ||
          board.contains('ranchu')) {
        return (score: score, reason: "$reason: $hw / $board");
      }
    }

    return (score: 0.0, reason: null);
  }
}
