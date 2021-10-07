// ignore_for_file: unnecessary_this

extension Rounding on double {
  double roundToPrecision(int places) {
    return double.parse(this.toStringAsFixed(places));
  }
}
