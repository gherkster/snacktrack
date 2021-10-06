import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:snacktrack/src/models/energy.dart';

abstract class IEnergyRepository {
  ValueListenable<Box<dynamic>> get stream;

  void add(double amount, DateTime time);

  Iterable<Energy> getAll();

  void deleteAll();
}
