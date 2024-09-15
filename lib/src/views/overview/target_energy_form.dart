import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snacktrack/src/viewmodels/interfaces/i_overview_viewmodel.dart';

class TargetEnergyForm extends StatelessWidget {
  const TargetEnergyForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Form(
        //key: _formKey,
        child: Consumer<IOverviewViewModel>(
          builder: (context, model, child) {
            return TextFormField(
              //controller: _textEditingController,
              //focusNode: _energyInputFocus,
              style: const TextStyle(fontSize: 24),
              textInputAction: TextInputAction.send,
              // decoration: InputDecoration(
              //   enabledBorder: const OutlineInputBorder(),
              //   labelText: model.energyUnit == EnergyUnit.kj ? "Energy" : "Calories",
              //   fillColor: Colors.white,
              //   border: OutlineInputBorder(
              //     borderRadius: BorderRadius.circular(15.0),
              //   ),
              // ),
              onFieldSubmitted: (energy) {
                // if (_formKey.currentState != null && _formKey.currentState!.validate()) {
                //   model.energyAddRecord(double.parse(energy));

                //   _textEditingController.clear();
                // }
              },
              keyboardType: TextInputType.number,
            );
          },
        ),
      ),
    );
  }
}
