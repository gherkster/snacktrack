import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:snacktrack/src/viewmodels/interfaces/i_history_viewmodel.dart";
//import "package:syncfusion_flutter_calendar/calendar.dart";

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  //List<Appointment> appointmentDetails = <Appointment>[];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Consumer<IHistoryViewModel>(
          builder: (context, model, child) {
            return SizedBox(
              height: 400,
              // child: SfCalendar(
              //   view: CalendarView.month,
              //   dataSource: model.appointmentDataSource,
              //   onTap: _calendarTapped,
              // ),
            );
          },
        ),
        // SizedBox(
        //   height: 150, // TODO calculate
        //   child: GridView.builder(
        //     itemCount: appointmentDetails.length,
        //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        //       childAspectRatio: 30.0 / 10.0,
        //       crossAxisCount: 2,
        //     ),
        //     itemBuilder: (BuildContext context, int index) {
        //       return Padding(
        //         padding: const EdgeInsets.all(5),
        //         child: Card(
        //             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        //             child: InkWell(
        //               customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        //               child: ListTile(
        //                 dense: true,
        //                 title: Text(
        //                   appointmentDetails[index].subject,
        //                   textAlign: TextAlign.center,
        //                 ),
        //               ),
        //               onTap: () {},
        //             )),
        //       );
        //     },
        //   ),
        // ),
      ],
    );
  }

  // void _calendarTapped(CalendarTapDetails calendarTapDetails) {
  //   if (calendarTapDetails.targetElement == CalendarElement.calendarCell) {
  //     setState(() {
  //       appointmentDetails = calendarTapDetails.appointments!.cast<Appointment>();
  //     });
  //   }
  // }
}
