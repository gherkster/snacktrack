import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snacktrack/src/viewmodels/interfaces/i_overview_viewmodel.dart';

class EnergyForm extends StatelessWidget {
  const EnergyForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        //key: _formKey,
        child: Consumer<IOverviewViewModel>(
          builder: (context, model, child) {
            return Column(
              children: [
                Text("Log weight"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Time"),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () => showDatePicker(
                              context: context,
                              firstDate: model.today
                                  .copyWith(year: model.today.year - 1),
                              lastDate: model.today),
                          child: Text("Today"),
                        ),
                        TextButton(
                          onPressed: () => showTimePicker(
                              context: context, initialTime: TimeOfDay.now()),
                          child: Text("11:08 am"),
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
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
