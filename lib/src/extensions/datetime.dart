// ignore_for_file: unnecessary_this

import "package:flutter/material.dart";

extension Date on DateTime {
  DateTime get date => DateTime(this.year, this.month, this.day);
}

extension Time on DateTime {
  DateTime addTime(TimeOfDay time) {
    return this.add(Duration(hours: time.hour)).add(Duration(minutes: time.minute));
  }
}
