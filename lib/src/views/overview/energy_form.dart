import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snacktrack/src/models/energy_unit.dart';
import 'package:snacktrack/src/viewmodels/interfaces/i_navigation_viewmodel.dart';

class EnergyForm extends StatelessWidget {
  const EnergyForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      //key: _formKey,
      child: Row(
        children: [
          Consumer<INavigationViewModel>(
            builder: (context, model, child) {
              return Expanded(
                child: TextFormField(
                  //controller: _textEditingController,
                  //focusNode: _energyInputFocus,
                  style: const TextStyle(fontSize: 24),
                  textInputAction: TextInputAction.send,
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(),
                    labelText: model.energyUnit.longName,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  onFieldSubmitted: (energy) {
                    // if (_formKey.currentState != null && _formKey.currentState!.validate()) {
                    //   model.energyAddRecord(double.parse(energy));

                    //   _textEditingController.clear();
                    // }
                  },
                  validator: (value) => model.validator(value),
                  keyboardType: TextInputType.number,
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
