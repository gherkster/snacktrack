import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:snacktrack/src/features/meals/domain/meal.dart';
import 'package:snacktrack/src/features/meals/domain/meal_food.dart';
import 'package:snacktrack/src/features/meals/services/meal_service.dart';
import 'package:snacktrack/src/features/settings/services/settings_service.dart';
import 'package:snacktrack/src/utilities/unit_conversion.dart';
import 'package:snacktrack/src/widgets/big_heading.dart';

class CreateMealForm extends StatefulWidget {
  const CreateMealForm({super.key, this.meal});

  final Meal? meal;

  @override
  State<CreateMealForm> createState() => _CreateMealFormState();
}

class _CreateMealFormState extends State<CreateMealForm> {
  final formKey = GlobalKey<FormState>();
  final dropDownKey = GlobalKey<DropdownSearchState<MealFood>>();

  final fieldPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8);

  String name = "";

  @override
  initState() {
    if (widget.meal != null) {
      /// Prefill name for editing scenario. Foods are prefilled below in `selectedItems`.
      name = widget.meal!.name;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mealService = context.watch<MealService>();
    final settingsService = context.watch<SettingsService>();

    final isEditMode = widget.meal != null;

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        actions: isEditMode
            ? [
                MenuAnchor(
                  builder: (context, controller, child) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: IconButton(
                        onPressed: () {
                          if (controller.isOpen) {
                            controller.close();
                          } else {
                            controller.open();
                          }
                        },
                        icon: const Icon(Icons.more_vert),
                      ),
                    );
                  },
                  menuChildren: [
                    MenuItemButton(
                      child: const Text("Delete meal"),
                      onPressed: () async {
                        // TODO: Move into dialogs folder
                        await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Delete '$name'"),
                              content: const Text("Are you sure you want to delete this meal?"),
                              actions: <Widget>[
                                TextButton(
                                  style: TextButton.styleFrom(
                                    textStyle: Theme.of(context).textTheme.labelLarge,
                                  ),
                                  child: Text('Cancel', style: Theme.of(context).textTheme.bodyMedium),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    textStyle: Theme.of(context).textTheme.labelLarge,
                                  ),
                                  child: Text('Delete',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(color: Theme.of(context).colorScheme.error)),
                                  onPressed: () async {
                                    await mealService.deleteMeal(widget.meal!.id);
                                    if (context.mounted) {
                                      // Return to main meal screen
                                      Navigator.of(context)
                                        ..pop()
                                        ..pop();
                                    }
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                )
              ]
            : null,
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: BigHeading(title: isEditMode ? "Edit meal" : "New meal"),
              ),
              const Divider(),
              Padding(
                padding: fieldPadding,
                child: TextFormField(
                  initialValue: name,
                  onSaved: (value) => name = value ?? "",
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Name"),
                  ),
                  textCapitalization: TextCapitalization.sentences,
                  validator: (value) {
                    if (value == null || value == "") {
                      return "Name is required";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: fieldPadding,
                child: DropdownSearch<MealFood>.multiSelection(
                  compareFn: (item1, item2) => item1.food.id == item2.food.id,
                  key: dropDownKey,
                  items: (filter, s) async {
                    if (filter != "") {
                      final foods = await mealService.searchFoods(filter);
                      return foods.map((f) => MealFood(food: f, quantity: 100)).toList();
                    }
                    return [];
                  },
                  itemAsString: (mealFood) => mealFood.food.name,
                  // Prefill foods for an edit scenario
                  selectedItems: widget.meal?.mealFoods ?? [],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Ingredients are required";
                    }
                    return null;
                  },
                  decoratorProps: const DropDownDecoratorProps(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text("Ingredients"),
                    ),
                  ),
                  dropdownBuilder: (context, selectedItems) {
                    return Wrap(
                      spacing: 12,
                      runSpacing: 6,
                      children: selectedItems
                          .map(
                            (item) => InputChip(
                              label: Text("${item.quantity}g ${item.food.name}"),
                              onSelected: (value) async => {
                                await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    final quantityController = TextEditingController();
                                    quantityController.text = item.quantity.toString();

                                    return AlertDialog(
                                      title: Text(item.food.name),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text("Weight"),
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: 56,
                                                    child: TextFormField(
                                                      controller: quantityController,
                                                      autofocus: true,
                                                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                                      keyboardType: TextInputType.number,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 12,
                                                  ),
                                                  const Text("g"),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 24),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text("Energy per 100g"),
                                              Row(
                                                children: [
                                                  Text(convertKilojoulesToPreferredUnits(
                                                          item.food.kilojoulesPer100g, settingsService.energyUnit)
                                                      .toString()),
                                                  const SizedBox(
                                                    width: 12,
                                                  ),
                                                  Text(settingsService.energyUnit.shortName),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          style: TextButton.styleFrom(
                                            textStyle: Theme.of(context).textTheme.labelLarge,
                                          ),
                                          child: Text('Cancel', style: Theme.of(context).textTheme.bodyMedium),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          style: TextButton.styleFrom(
                                            textStyle: Theme.of(context).textTheme.labelLarge,
                                          ),
                                          child: Text(
                                            "Save",
                                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                  color: Theme.of(context).colorScheme.primary,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                          onPressed: () async {
                                            if (dropDownKey.currentState != null) {
                                              final selectedFoods = dropDownKey.currentState!.getSelectedItems;

                                              final updatedFood = selectedFoods.firstWhere((f) => f.id == item.id);
                                              // Only integers can be entered
                                              updatedFood.quantity = int.parse(quantityController.text);

                                              dropDownKey.currentState!.changeSelectedItems(selectedFoods);
                                              // TODO: Is this needed?
                                              item.quantity = int.parse(quantityController.text);
                                            }

                                            if (context.mounted) {
                                              Navigator.of(context).pop();
                                            }
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                )
                              },
                              onDeleted: () => dropDownKey.currentState?.removeItem(item),
                            ),
                          )
                          .toList(),
                    );
                  },
                  popupProps: PopupPropsMultiSelection.bottomSheet(
                    bottomSheetProps: const BottomSheetProps(showDragHandle: true),
                    showSearchBox: true,
                    // Filtering is done in the database query, this disables the substring based default filtering
                    disableFilter: true,
                    searchDelay: const Duration(milliseconds: 250),
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
                    itemBuilder: (context, item, isDisabled, isSelected) {
                      return ListTile(
                        title: Text(item.food.name),
                        subtitle: Text(item.food.category),
                      );
                    },
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
                    onPressed: () async {
                      if (formKey.currentState?.validate() == true) {
                        formKey.currentState!.save();
                        var foods = dropDownKey.currentState?.getSelectedItems ?? [];

                        if (isEditMode) {
                          await mealService.updateMeal(widget.meal!.id, name, foods);
                        } else {
                          await mealService.createMeal(name, foods);
                        }

                        if (context.mounted) {
                          Navigator.pop(context);
                        }
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
