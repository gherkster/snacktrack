import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:snacktrack/src/extensions.dart';
import 'package:snacktrack/src/viewmodels/interfaces/i_overview_viewmodel.dart';

class WeightForm extends StatefulWidget {
  const WeightForm({super.key});

  @override
  State<WeightForm> createState() => _WeightFormState();
}

class _WeightFormState extends State<WeightForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var date = DateTime.now().date;
  var time = TimeOfDay.now();
  // TODO: Prepopulate the latest weight to set an accurate default
  var weight = 70.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _formKey,
        child: Consumer<IOverviewViewModel>(
          builder: (context, model, child) {
            return Column(
              children: [
                Text("Add weight"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Time"),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () async {
                            var selectedDate = await showDatePicker(
                              context: context,
                              initialDate: date,
                              firstDate: model.today
                                  .copyWith(year: model.today.year - 1),
                              lastDate: model.today,
                            );

                            if (selectedDate == null) {
                              return;
                            }

                            setState(() {
                              date = selectedDate;
                            });
                          },
                          child: Text(
                            createDateLabel(date),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            var selectedTime = await showTimePicker(
                              context: context,
                              initialTime: time,
                            );

                            if (selectedTime == null) {
                              return;
                            }

                            setState(() {
                              time = selectedTime;
                            });
                          },
                          child: Text(time.format(context)),
                        )
                      ],
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Weight"),
                    Text("kg"),
                  ],
                ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() == true) {
                          model.addWeightRecord(weight, date.addTime(time));
                          Navigator.pop(context);
                        }
                      },
                      child: Text("Add weight"),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  String createDateLabel(DateTime dateTime) {
    if (dateTime.date == DateTime.now().date) {
      return "Today";
    } else if (dateTime.date == DateTime.now().date.add(Duration(days: -1))) {
      return "Yesterday";
    }
    return DateFormat.yMMMd().format(dateTime);
  }
}
