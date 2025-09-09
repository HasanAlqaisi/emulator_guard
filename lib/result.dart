/// The result of an emulator detection check.
///
/// This class contains the comprehensive results of running emulator detection methods,
/// including the likelihood score, physical device status, and detailed reasons for
/// the detection decision.
class EmulatorCheckResult {
  /// The emulator likelihood score (0-100).
  ///
  /// Higher scores indicate a higher likelihood that the device is an emulator.
  /// A score of 0 means no emulator indicators were found, while 100 means
  /// strong evidence of emulator usage.
  final double score;

  /// Whether the device is considered an emulator device.
  ///
  /// This is determined by comparing the total score against the platform threshold.
  /// If the score is above the threshold, the device is considered emulator.
  final bool isEmulator;

  /// List of reasons why the device was flagged as an emulator.
  ///
  /// Each reason corresponds to a detection method that contributed to the score.
  /// Empty list means no emulator indicators were found.
  final List<String> reasons;

  EmulatorCheckResult({
    required this.score,
    required this.isEmulator,
    required this.reasons,
  });

  @override
  String toString() {
    return 'Emulator Likelihood Score: $score\nIs Emulator: $isEmulator\nReasons:\n- ${reasons.join('\n- ')}';
  }
}
