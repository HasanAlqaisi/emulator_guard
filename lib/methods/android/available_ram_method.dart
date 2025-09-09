import 'package:device_info_plus/device_info_plus.dart';

import 'package:emulator_guard/methods/emulator_detection_method.dart';

/// Detection method that checks for unusually low available RAM ratio.
///
/// This method calculates the ratio of available RAM to physical RAM and flags devices
/// with very low available memory. Emulators often have limited RAM allocation compared
/// to physical devices, resulting in low available RAM ratios.
///
/// **Reliability**: Medium (60-75%)
/// - Good indicator for resource-constrained emulators
/// - May have false positives on devices with many running apps
/// - Some emulators may allocate more RAM to avoid detection
///
/// **Score**: 10 points when available RAM ratio is below 20%
///
/// **Performance**: Fast - only checks numeric properties
class AvailableRamMethod extends EmulatorDetectionMethod {
  AvailableRamMethod({
    super.score = 10,
    super.reason = "Available RAM unusually low",
  });

  @override
  Future<({double score, String? reason})> execute() async {
    final deviceInfo = await DeviceInfoPlugin().deviceInfo;

    if (deviceInfo is AndroidDeviceInfo) {
      final availableRatio =
          deviceInfo.availableRamSize / deviceInfo.physicalRamSize;
      if (availableRatio < 0.2) {
        return (
          score: score,
          reason: "$reason: ${(availableRatio * 100).toStringAsFixed(1)}%",
        );
      }
    }

    return (score: 0.0, reason: null);
  }
}
