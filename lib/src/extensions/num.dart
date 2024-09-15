// ignore_for_file: unnecessary_this

extension Rounding on double {
  double roundToPrecision(int places) {
    return double.parse(this.toStringAsFixed(places));
  }
}

extension Fraction on double {
  int get integer => this.truncate();
  int get fraction => ((this - this.truncate()) * 10).round();
}
