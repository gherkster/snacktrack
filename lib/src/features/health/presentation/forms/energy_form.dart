import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:snacktrack/src/extensions/datetime.dart';
import 'package:snacktrack/src/features/health/services/health_service.dart';
import 'package:snacktrack/src/features/settings/services/settings_service.dart';
import 'package:snacktrack/src/styles/layout.dart';
import 'package:snacktrack/src/utilities/formatting.dart';
import 'package:snacktrack/src/widgets/big_heading.dart';
import 'package:snacktrack/src/widgets/form_row.dart';

class EnergyForm extends StatefulWidget {
  const EnergyForm({super.key});

  @override
  State<EnergyForm> createState() => _EnergyFormState();
}

class _EnergyFormState extends State<EnergyForm> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final energyInputController = TextEditingController();

  var date = DateTime.now().date;
  var time = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    final healthService = context.watch<HealthService>();
    final settingsService = context.watch<SettingsService>();

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
      ),
      body: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: Spacing.medium),
              child: BigHeading(title: "Add energy"),
            ),
            const Divider(),
            FormRow(
              children: [
                const Text("Time"),
                Row(
                  children: [
                    TextButton(
                      onPressed: () async {
                        var selectedDate = await showDatePicker(
                          context: context,
                          initialDate: date,
                          firstDate: DateTime.now().date.addYears(-1),
                          lastDate: DateTime.now().date,
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
            const Divider(),
            FormRow(
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
                    Text(settingsService.energyUnit.shortName),
                  ],
                ),
              ],
            ),
            const Divider(),
            Center(
              child: Container(
                padding: fieldPadding,
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    if (formKey.currentState?.validate() == true) {
                      var energy = int.tryParse(energyInputController.text);
                      // Energy should always be valid as the keyboard filter only allows for integer input
                      // However we should still avoid storing empty values
                      if (energy != null && energy > 0) {
                        healthService.addEnergyRecord(energy, date.addTime(time));
                      }

                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Add energy"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
