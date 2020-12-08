import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:snacktrack/src/models/weight.dart';
import 'package:snacktrack/src/repositories/interfaces/i_energy_repository.dart';
import 'package:snacktrack/src/repositories/interfaces/i_settings_repository.dart';
import 'package:snacktrack/src/repositories/interfaces/i_weight_repository.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class HistoryViewModel {
  final IEnergyRepository _energyRepository;
  final IWeightRepository _weightRepository;
  final ISettingsRepository _settingsRepository;

  HistoryViewModel(this._energyRepository, this._weightRepository, this._settingsRepository);

  ValueListenable<Box<dynamic>> get energyStream => _energyRepository.stream;
  ValueListenable<Box<dynamic>> get weightStream => _weightRepository.stream;
  ValueListenable<Box<dynamic>> get settingsStream => _settingsRepository.stream;

  DateTime get today => DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  List<Weight> energyGetAllRecentValues(int durationInDays) {
    final Iterable<Weight> values = _weightRepository.getAllRecords().where((record) => record.time.isAfter(today.subtract(Duration(days: durationInDays))));
    return values.toList();
  }

  List<Weight> weightGetAllRecentValues(int durationInDays) {
    final Iterable<Weight> values = _weightRepository.getAllRecords().where((record) => record.time.isAfter(today.subtract(Duration(days: durationInDays))));
    return values.toList();
  }

  _AppointmentDataSource get appointmentDataSource {
    final List<Appointment> appointments = [];
    appointments
      ..add(Appointment(
          isAllDay: true, startTime: today.subtract(Duration(days: 1)), endTime: today.subtract(Duration(days: 1)), subject: '8000 KJ', color: Colors.orange))
      ..add(Appointment(isAllDay: true, startTime: today.subtract(Duration(days: 1)), endTime: today.subtract(Duration(days: 1)), subject: '70 KG'))
      ..add(Appointment(isAllDay: true, startTime: today, endTime: today, subject: '4500 KJ'));

    return _AppointmentDataSource(appointments);
  }
}

class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}
