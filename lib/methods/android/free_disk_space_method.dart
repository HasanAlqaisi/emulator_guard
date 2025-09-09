import 'package:device_info_plus/device_info_plus.dart';

import 'package:emulator_guard/methods/base_method.dart';

/// Detection method that checks for unusually high free disk space ratio.
///
/// This method calculates the ratio of free disk space to total disk space and flags
/// devices with very high available storage. Emulators often have large virtual disk
/// images with minimal usage, resulting in high free disk space ratios that are
/// uncommon on physical devices with typical app and data usage.
///
/// **Reliability**: Medium (60-75%)
/// - Good indicator for emulators with large virtual storage
/// - May have false positives on new or lightly used physical devices
/// - Some emulators may limit disk space to appear more realistic
///
/// **Score**: 20 points when free disk space ratio is above 95%
///
/// **Performance**: Fast - only checks numeric properties
class FreeDiskSpaceMethod extends BaseMethod {
  FreeDiskSpaceMethod({
    super.score = 20,
    super.reason = "Free disk space unusually high",
  });

  @override
  Future<({double score, String? reason})> execute() async {
    final deviceInfo = await DeviceInfoPlugin().deviceInfo;

    if (deviceInfo is AndroidDeviceInfo) {
      final freeRatio = deviceInfo.freeDiskSize / deviceInfo.totalDiskSize;
      if (freeRatio > 0.95) {
        return (
          score: score,
          reason: "$reason: ${(freeRatio * 100).toStringAsFixed(1)}%",
        );
      }
    }

    return (score: 0.0, reason: null);
  }
}
