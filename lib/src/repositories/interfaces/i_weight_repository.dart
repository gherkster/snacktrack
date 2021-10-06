import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:snacktrack/src/models/weight.dart';

abstract class IWeightRepository {
  ValueListenable<Box<dynamic>> get stream;

  void add(double amount, DateTime time);

  void put(double value, DateTime time);

  Iterable<Weight> getAllRecords();

  double getLatest();

  void deleteAll();
}
