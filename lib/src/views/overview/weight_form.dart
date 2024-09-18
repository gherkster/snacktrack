import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';
import 'package:snacktrack/src/extensions/datetime.dart';
import 'package:snacktrack/src/viewmodels/interfaces/i_overview_viewmodel.dart';
import 'package:snacktrack/src/widgets/big_heading.dart';

class WeightForm extends StatefulWidget {
  const WeightForm({super.key, required this.currentWeight});

  final double currentWeight;

  @override
  State<WeightForm> createState() => _WeightFormState();
}

class _WeightFormState extends State<WeightForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final fieldPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8);

  var date = DateTime.now().date;
  var time = TimeOfDay.now();
  late double weight = widget.currentWeight;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
      ),
      body: Form(
        key: _formKey,
        child: Consumer<IOverviewViewModel>(
          builder: (context, model, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: BigHeading(title: "Add weight"),
                ),
                const Divider(),
                Padding(
                  padding: fieldPadding,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Time"),
                      Row(
                        children: [
                          TextButton(
                            onPressed: () async {
                              var selectedDate = await showDatePicker(
                                context: context,
                                initialDate: date,
                                firstDate: model.today.copyWith(year: model.today.year - 1),
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
                              style: Theme.of(context).textTheme.bodyLarge,
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
                            child: Text(
                              time.format(context),
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                const Divider(),
                Padding(
                  padding: fieldPadding,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Weight"),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          DecimalNumberPicker(
                            minValue: model.weightMinSelectable,
                            maxValue: model.weightMaxSelectable,
                            value: weight,
                            onChanged: (value) => setState(() => weight = value),
                            itemWidth: 64,
                          ),
                        ],
                      ),
                      Text(model.weightUnit.shortName),
                    ],
                  ),
                ),
                const Divider(),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: FilledButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() == true) {
                          model.addWeightRecord(weight, date.addTime(time));

                          Navigator.pop(context);
                        }
                      },
                      child: Padding(
                        padding: fieldPadding,
                        child: const Text("Add weight"),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  String createDateLabel(DateTime dateTime) {
    if (dateTime.isToday) {
      return "Today";
    } else if (dateTime.isYesterday) {
      return "Yesterday";
    }
    return DateFormat.MMMd().format(dateTime);
  }
}
