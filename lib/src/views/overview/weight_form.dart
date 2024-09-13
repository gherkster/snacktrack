import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snacktrack/src/viewmodels/interfaces/i_navigation_viewmodel.dart';

class WeightForm extends StatelessWidget {
  const WeightForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        //key: _formKey,
        child: Consumer<INavigationViewModel>(
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
              onFieldSubmitted: (weight) {
                // if (_formKey.currentState != null && _formKey.currentState!.validate()) {
                //   model.energyAddRecord(double.parse(energy));

                //   _textEditingController.clear();
                // }
              },
              // TODO: This validates energy, should this navigation viewmodel even exist?
              validator: (value) => model.validator(value),
              keyboardType: TextInputType.number,
            );
          },
        ),
      ),
    );
  }
}
