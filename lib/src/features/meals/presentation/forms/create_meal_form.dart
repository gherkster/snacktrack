import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snacktrack/src/extensions/datetime.dart';
import 'package:snacktrack/src/features/health/services/health_service.dart';
import 'package:snacktrack/src/features/settings/services/settings_service.dart';
import 'package:snacktrack/src/widgets/big_heading.dart';

class CreateMealForm extends StatefulWidget {
  const CreateMealForm({super.key});

  @override
  State<CreateMealForm> createState() => _CreateMealFormState();
}

class _CreateMealFormState extends State<CreateMealForm> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final energyInputController = TextEditingController();

  final fieldPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8);

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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: BigHeading(title: "New meal"),
              ),
              const Divider(),
              Padding(
                padding: fieldPadding,
                child: TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Name"),
                  ),
                ),
              ),
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
                          healthService.addEnergyRecord(energy, date.addTime(time));
                        }

                        Navigator.pop(context);
                      }
                    },
                    child: Padding(
                      padding: fieldPadding,
                      child: const Text("Save meal"),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
