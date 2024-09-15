// ignore_for_file: unnecessary_this

import 'package:flutter/material.dart';

extension Rounding on double {
  double roundToPrecision(int places) {
    return double.parse(this.toStringAsFixed(places));
  }
}

extension MaxMin on Iterable<double> {
  double get max => reduce((current, next) => current > next ? current : next);
  double get min => reduce((current, next) => current < next ? current : next);
}

extension Date on DateTime {
  DateTime get date => DateTime(this.year, this.month, this.day);
}

extension Time on DateTime {
  DateTime addTime(TimeOfDay time) {
    return this
        .add(Duration(hours: time.hour))
        .add(Duration(minutes: time.minute));
  }
}
