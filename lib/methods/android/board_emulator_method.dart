import 'package:device_info_plus/device_info_plus.dart';

import 'package:emulator_guard/methods/emulator_detection_method.dart';

/// Detection method that checks if the device board is "goldfish" or "ranchu".
///
/// This method examines the device's board property to detect emulators.
/// Many Android emulators return "goldfish" or "ranchu" as the board value, which is
/// uncommon on physical devices that typically have specific board names.
///
/// **Reliability**: Medium (70-80%)
/// - Good indicator for many emulators
/// - Easy to spoof by modifying device properties
///
/// **Score**: 10 points when board is "goldfish" or "ranchu"
///
/// **Performance**: Fast - only checks string property
class BoardEmulatorMethod extends EmulatorDetectionMethod {
  BoardEmulatorMethod({
    super.score = 10,
    super.reason = "Board indicates emulator",
  });

  @override
  Future<({double score, String? reason})> execute() async {
    final deviceInfo = await DeviceInfoPlugin().deviceInfo;

    if (deviceInfo is AndroidDeviceInfo) {
      final board = deviceInfo.board.toLowerCase();

      if (board.contains('goldfish') ||
          board.contains('ranchu') ||
          board.contains('x86') ||
          board.contains('vbox')) {
        return (score: score, reason: "$reason: $board");
      }
    }

    return (score: 0.0, reason: null);
  }
}
