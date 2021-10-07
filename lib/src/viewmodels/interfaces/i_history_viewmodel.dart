import 'package:flutter/foundation.dart';
import 'package:snacktrack/src/models/weight.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

abstract class IHistoryViewModel extends ChangeNotifier {
  List<Weight> energyGetAllRecentValues(int durationInDays);

  List<Weight> weightGetAllRecentValues(int durationInDays);

  AppointmentDataSource get appointmentDataSource;
}

// TODO Remove this and one in concrete implementation and create non-test class in /models
class AppointmentDataSource extends CalendarDataSource {
  AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}
