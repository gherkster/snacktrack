import "package:snacktrack/src/extensions/iterable.dart";

List<String> tokenize(String value) {
  return value
      .trim()
      // Split by comma, space or forward slash
      .split(RegExp(r"[,\s/]+"))
      .map(
        // Remove any parantheses surrounding alternate names like fetta (feta)
        (v) => v.replaceAll("(", "").replaceAll(")", "").trim().toLowerCase(),
      )
      .where((v) =>
          v.isNotEmpty &&
          !v.isIn([
            "&",
            "and",
            "or",
            "from",
            "v", // comes from v/v when splitting by /
          ]))
      .toList();
}
