import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snacktrack/src/features/meals/services/meal_service.dart';
import 'package:snacktrack/src/widgets/big_heading.dart';

class CreateMealForm extends StatefulWidget {
  const CreateMealForm({super.key});

  @override
  State<CreateMealForm> createState() => _CreateMealFormState();
}

class _CreateMealFormState extends State<CreateMealForm> {
  final formKey = GlobalKey<FormState>();
  final dropDownKey = GlobalKey<DropdownSearchState>();

  final fieldPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8);

  @override
  Widget build(BuildContext context) {
    final mealService = context.watch<MealService>();

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
              Padding(
                padding: fieldPadding,
                child: DropdownSearch<String>.multiSelection(
                  key: dropDownKey,
                  items: (filter, s) => ["Test", "Test 2"],
                  decoratorProps: const DropDownDecoratorProps(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text("Ingredients"),
                    ),
                  ),
                  dropdownBuilder: (context, selectedItems) {
                    return Wrap(
                      spacing: 12,
                      children: selectedItems
                          .map(
                            (item) => InputChip(
                              label: Text(item),
                              onSelected: (value) => {},
                              onDeleted: () => dropDownKey.currentState?.removeItem(item),
                            ),
                          )
                          .toList(),
                    );
                  },
                  popupProps: PopupPropsMultiSelection.bottomSheet(
                    bottomSheetProps: const BottomSheetProps(showDragHandle: true),
                    showSearchBox: true,
                    searchFieldProps: const TextFieldProps(
                      autofocus: true,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text("Search for ingredients"),
                      ),
                    ),
                    listViewProps: const ListViewProps(
                      padding: EdgeInsets.only(left: 16, right: 16, top: 16),
                    ),
                    // Select immediately on click, without requiring a separate confirmation.
                    onItemAdded: (selectedItems, addedItem) {
                      dropDownKey.currentState?.changeSelectedItems(selectedItems);
                    },
                    onItemRemoved: (selectedItems, removedItem) {
                      dropDownKey.currentState?.changeSelectedItems(selectedItems);
                    },
                    // Hide the default confirmation button
                    validationBuilder: (context, items) => Container(),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: FilledButton(
                    onPressed: () {
                      if (formKey.currentState?.validate() == true) {
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
