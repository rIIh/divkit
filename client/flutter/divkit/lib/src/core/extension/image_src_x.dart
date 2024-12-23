extension ImageSrcX on String {
  /// Search for "@3x" or similar in file name ending.
  double get imageScale {
    final regexp = RegExp(r'@(\d)x(\.[a-zA-Z]+)?$');
    final decoded = Uri.decodeFull(this);
    final match = regexp.firstMatch(decoded)?.group(1);

    if (match == null) return 1.0;

    return int.tryParse(match)?.toDouble() ?? 1.0;
  }
}
