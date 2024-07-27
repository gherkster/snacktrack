import "package:flutter/material.dart";
import "package:snacktrack/src/models/weight.dart";
import "package:snacktrack/src/repositories/interfaces/i_energy_repository.dart";
import "package:snacktrack/src/repositories/interfaces/i_settings_repository.dart";
import "package:snacktrack/src/repositories/interfaces/i_weight_repository.dart";
import "package:snacktrack/src/viewmodels/interfaces/i_history_viewmodel.dart";
import "package:syncfusion_flutter_calendar/calendar.dart";

class HistoryViewModel extends ChangeNotifier implements IHistoryViewModel {
  final IEnergyRepository _energyRepository;
  final IWeightRepository _weightRepository;
  final ISettingsRepository _settingsRepository;

  HistoryViewModel(this._energyRepository, this._weightRepository, this._settingsRepository);

  DateTime get _today => DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  @override
  List<Weight> energyGetAllRecentValues(int durationInDays) {
    final Iterable<Weight> values = _weightRepository.getAllRecords().where((record) => record.time.isAfter(_today.subtract(Duration(days: durationInDays))));
    return values.toList();
  }

  @override
  List<Weight> weightGetAllRecentValues(int durationInDays) {
    final Iterable<Weight> values = _weightRepository.getAllRecords().where((record) => record.time.isAfter(_today.subtract(Duration(days: durationInDays))));
    return values.toList();
  }

  @override
  AppointmentDataSource get appointmentDataSource {
    final List<Appointment> appointments = [];
    appointments
      ..add(Appointment(
          isAllDay: true, startTime: _today.subtract(const Duration(days: 1)), endTime: _today.subtract(const Duration(days: 1)), subject: "8000 KJ", color: Colors.orange))
      ..add(Appointment(isAllDay: true, startTime: _today.subtract(const Duration(days: 1)), endTime: _today.subtract(const Duration(days: 1)), subject: "70 KG"))
      ..add(Appointment(isAllDay: true, startTime: _today, endTime: _today, subject: "4500 KJ"));

    return AppointmentDataSource(appointments);
  }
}
