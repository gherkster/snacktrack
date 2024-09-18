import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:snacktrack/src/extensions/datetime.dart';
import 'package:snacktrack/src/viewmodels/interfaces/i_overview_viewmodel.dart';
import 'package:snacktrack/src/widgets/big_heading.dart';

class EnergyForm extends StatefulWidget {
  const EnergyForm({super.key});

  @override
  State<EnergyForm> createState() => _EnergyFormState();
}

class _EnergyFormState extends State<EnergyForm> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final energyInputController = TextEditingController();

  final fieldPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8);

  var date = DateTime.now().date;
  var time = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
      ),
      body: Form(
        key: formKey,
        child: Consumer<IOverviewViewModel>(
          builder: (context, model, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: BigHeading(title: "Add energy"),
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
                      const Text("Energy"),
                      Row(
                        children: [
                          SizedBox(
                            width: 72,
                            child: TextFormField(
                              controller: energyInputController,
                              autofocus: true,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          Text(model.energyUnit.shortName),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: FilledButton(
                      onPressed: () {
                        if (formKey.currentState?.validate() == true) {
                          var energy = int.tryParse(energyInputController.text);
                          // Energy should always be valid as the keyboard filter only allows for integer input
                          // However we should still avoid storing empty values
                          if (energy != null && energy > 0) {
                            model.addEnergyRecord(energy, date.addTime(time));
                          }

                          Navigator.pop(context);
                        }
                      },
                      child: Padding(
                        padding: fieldPadding,
                        child: const Text("Add energy"),
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
