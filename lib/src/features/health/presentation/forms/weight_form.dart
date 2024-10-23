import "package:dart_date/dart_date.dart";
import "package:flutter/material.dart";
import "package:numberpicker/numberpicker.dart";
import "package:provider/provider.dart";
import "package:snacktrack/src/extensions/datetime.dart";
import "package:snacktrack/src/features/health/domain/weight_unit.dart";
import "package:snacktrack/src/features/health/services/health_service.dart";
import "package:snacktrack/src/features/settings/services/settings_service.dart";
import "package:snacktrack/src/styles/layout.dart";
import "package:snacktrack/src/utilities/formatting.dart";
import "package:snacktrack/src/widgets/big_heading.dart";
import "package:snacktrack/src/widgets/form_row.dart";

class WeightForm extends StatefulWidget {
  const WeightForm({super.key, required this.targetWeight});

  final double targetWeight;

  @override
  State<WeightForm> createState() => _WeightFormState();
}

class _WeightFormState extends State<WeightForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var date = DateTime.now().date;
  var time = TimeOfDay.now();
  late double weight = widget.targetWeight;

  @override
  Widget build(BuildContext context) {
    final healthService = context.watch<HealthService>();
    final settingsService = context.watch<SettingsService>();

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: Spacing.medium),
              child: BigHeading(title: "Add weight"),
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
                ),
              ],
            ),
            const Divider(),
            FormRow(
              children: [
                const Text("Weight"),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    DecimalNumberPicker(
                      minValue: settingsService.weightUnit == WeightUnit.kilograms ? 40 : 80,
                      maxValue: settingsService.weightUnit == WeightUnit.kilograms ? 200 : 400,
                      value: weight,
                      onChanged: (value) => setState(() => weight = value),
                      itemWidth: 64,
                    ),
                  ],
                ),
                Text(settingsService.weightUnit.shortName),
              ],
            ),
            const Divider(),
            Center(
              child: Container(
                padding: fieldPadding,
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() == true) {
                      healthService.addWeightRecord(weight, date.addTime(time));

                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Add weight"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
