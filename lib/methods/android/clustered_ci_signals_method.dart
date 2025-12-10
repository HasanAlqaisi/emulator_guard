import 'package:device_info_plus/device_info_plus.dart';

import 'package:emulator_guard/methods/emulator_detection_method.dart';

/// Detection method that clusters multiple CI-style artifacts to avoid
/// single-signal false positives.
///
/// Triggers only when at least two of these are present:
/// - fingerprint contains "jenkins"
/// - host contains "jenkins" or "build"
///
/// Assigns 30 points; tuned to push emulators like BlueStacks over the
/// threshold while remaining conservative on physical devices.
class ClusteredCiSignalsMethod extends EmulatorDetectionMethod {
  ClusteredCiSignalsMethod({
    super.score = 30,
    super.reason = 'Multiple CI artifacts detected',
  });

  @override
  Future<({double score, String? reason})> execute() async {
    final info = await DeviceInfoPlugin().deviceInfo;
    if (info is! AndroidDeviceInfo) return (score: 0.0, reason: null);

    final fingerprint = info.fingerprint.toLowerCase();
    final host = info.host.toLowerCase();

    final hasJenkinsFingerprint = fingerprint.contains('jenkins');
    final hasCiHost = host.contains('jenkins') || host.contains('build');

    final ciSignals = <String>[
      if (hasJenkinsFingerprint) 'fingerprint=$fingerprint',
      if (hasCiHost) 'host=$host',
    ];

    if (ciSignals.length >= 2) {
      return (score: score, reason: '$reason (${ciSignals.join(", ")})');
    }

    return (score: 0.0, reason: null);
  }
}
