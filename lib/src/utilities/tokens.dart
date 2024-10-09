List<String> tokenize(String value) {
  return value
      .trim()
      // Split by comma or space
      .split(RegExp(r"[,\s]+"))
      .map(
        // Remove any parantheses surrounding alternate names like fetta (feta)
        (v) => v.replaceAll("(", "").replaceAll(")", "").trim(),
      )
      .where((v) => v.isNotEmpty)
      .toList();
}
