import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:snacktrack/src/features/meals/domain/food.dart';
import 'package:snacktrack/src/features/meals/domain/meal.dart';
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
  final dropDownKey = GlobalKey<DropdownSearchState<Food>>();

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
                child: DropdownSearch<Food>.multiSelection(
                  compareFn: (item1, item2) => item1.id == item2.id,
                  key: dropDownKey,
                  items: (filter, s) async {
                    if (filter != "") {
                      return await mealService.searchFoods(filter);
                    }
                    return [];
                  },
                  itemAsString: (food) => food.name,
                  // Prefill foods for an edit scenario
                  selectedItems: widget.meal?.foods ?? [],
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
                              label: Text("${item.quantity} ${item.unit} ${item.name}"),
                              onSelected: (value) async => {
                                await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(item.name),
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
                                                      autofocus: true,
                                                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                                      keyboardType: TextInputType.number,
                                                      initialValue: item.quantity.toString(),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 12,
                                                  ),
                                                  Text(item.unit),
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
                                                          item.kilojoulesPerUnit, settingsService.energyUnit)
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
                        title: Text(item.name),
                        subtitle: Text(item.category),
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
