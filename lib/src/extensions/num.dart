// ignore_for_file: unnecessary_this

import 'dart:math';

extension Rounding on double {
  double roundToPrecision(int places) {
    // For example, 1.017 to two places will go 1.017 -> 101.7 -> 102 -> 1.02
    final powerFactor = pow(10, places);
    return (this * powerFactor).round() / powerFactor;
  }
}

extension Fraction on double {
  int get integer => this.truncate();
  int get fraction => ((this - this.truncate()) * 10).round();
}
