import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snacktrack/src/viewmodels/history_viewmodel.dart';
import 'package:snacktrack/src/repositories/interfaces/i_energy_repository.dart';
import 'package:snacktrack/src/repositories/interfaces/i_settings_repository.dart';
import 'package:snacktrack/src/repositories/interfaces/i_weight_repository.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  HistoryViewModel _historyViewModel;
  List<Appointment> appointmentDetails;

  @override
  void didChangeDependencies() {
    if (_historyViewModel == null) {
      final energyRepository = Provider.of<IEnergyRepository>(context);
      final weightRepository = Provider.of<IWeightRepository>(context);
      final settingsRepository = Provider.of<ISettingsRepository>(context);

      _historyViewModel = HistoryViewModel(energyRepository, weightRepository, settingsRepository);
    }
  }

  @override
  void initState() {
    appointmentDetails = <Appointment>[];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 400,
          child: SfCalendar(
            view: CalendarView.month,
            dataSource: _historyViewModel.appointmentDataSource,
            onTap: _calendarTapped,
          ),
        ),
        Container(
          height: 150, // TODO calculate
          child: GridView.builder(
            itemCount: appointmentDetails.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 30.0 / 10.0,
              crossAxisCount: 2,
            ),
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: EdgeInsets.all(5),
                child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                    child: InkWell(
                      customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                      child: ListTile(
                        dense: true,
                        title: Text(
                          appointmentDetails[index].subject,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      onTap: () {},
                    )),
              );
            },
          ),
        ),
      ],
    );
  }

  void _calendarTapped(CalendarTapDetails calendarTapDetails) {
    if (calendarTapDetails.targetElement == CalendarElement.calendarCell) {
      setState(() {
        appointmentDetails = calendarTapDetails.appointments as List<Appointment>;
      });
    }
  }
}
