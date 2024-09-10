// ignore_for_file: unnecessary_this

extension Rounding on double {
  double roundToPrecision(int places) {
    return double.parse(this.toStringAsFixed(places));
  }
}

extension MaxMin on Iterable<double> {
  double get max => reduce((current, next) => current > next ? current : next);
  double get min => reduce((current, next) => current < next ? current : next);
}
