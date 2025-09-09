import 'package:device_info_plus/device_info_plus.dart';

import 'package:emulator_guard/methods/base_method.dart';

/// Detection method that checks for development build types.
///
/// This method examines the device's build type to detect emulators and development
/// environments. It flags devices with:
/// - "userdebug" build type (development builds)
/// - "eng" build type (engineering builds)
///
/// These build types are commonly used in emulators and development environments
/// but are rare on production physical devices.
///
/// **Reliability**: Medium-High (75-85%)
/// - Good indicator for emulators and development devices
/// - Some physical devices used for development may have these build types
/// - Build type can be modified but requires system-level changes
///
/// **Score**: 10 points when development build type is detected
///
/// **Performance**: Fast - only checks string property
class BuildTypeMethod extends BaseMethod {
  BuildTypeMethod({super.score = 10, super.reason = "Build type is"});

  @override
  Future<({double score, String? reason})> execute() async {
    final deviceInfo = await DeviceInfoPlugin().deviceInfo;

    if (deviceInfo is AndroidDeviceInfo) {
      final type = deviceInfo.type.toLowerCase();

      if (type == 'userdebug' || type == 'eng') {
        return (score: score, reason: "$reason $type");
      }
    }

    return (score: 0.0, reason: null);
  }
}
