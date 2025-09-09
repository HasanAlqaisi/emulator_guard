abstract class BaseMethod {
  final double score;
  final String? reason;

  BaseMethod({required this.score, this.reason});

  /// Executes the method and returns a score between 0 and 100
  Future<({double score, String? reason})> execute();
}
