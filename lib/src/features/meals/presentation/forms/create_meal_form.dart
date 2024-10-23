import "package:dropdown_search/dropdown_search.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:snacktrack/src/features/meals/domain/meal.dart";
import "package:snacktrack/src/features/meals/domain/meal_food.dart";
import "package:snacktrack/src/features/meals/presentation/dialogs/delete_meal_dialog.dart";
import "package:snacktrack/src/features/meals/presentation/dialogs/food_weight_dialog.dart";
import "package:snacktrack/src/features/meals/services/meal_service.dart";
import "package:snacktrack/src/styles/layout.dart";
import "package:snacktrack/src/widgets/app_bar_menu.dart";
import "package:snacktrack/src/widgets/big_heading.dart";

class CreateMealForm extends StatefulWidget {
  const CreateMealForm({super.key, this.meal});

  final Meal? meal;

  @override
  State<CreateMealForm> createState() => _CreateMealFormState();
}

class _CreateMealFormState extends State<CreateMealForm> {
  final formKey = GlobalKey<FormState>();
  final dropDownKey = GlobalKey<DropdownSearchState<MealFood>>();

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
    final isEditMode = widget.meal != null;

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        actions: isEditMode
            ? [
                AppBarMenu(
                  menuItems: [
                    MenuItemButton(
                      child: const Text("Delete meal"),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return DeleteMealDialog(
                              mealName: name,
                              onConfirm: () async {
                                await mealService.deleteMeal(widget.meal!.id);
                                if (context.mounted) {
                                  // Return to main meal screen
                                  Navigator.of(context)
                                    ..pop()
                                    ..pop();
                                }
                              },
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
                padding: const EdgeInsets.symmetric(horizontal: Spacing.medium),
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
                              onSelected: (value) => {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return FoodWeightDialog(
                                      initialQuantity: item.quantity,
                                      food: item.food,
                                      onConfirm: (quantity) {
                                        if (dropDownKey.currentState != null) {
                                          final selectedFoods = dropDownKey.currentState!.getSelectedItems;

                                          final updatedFood = selectedFoods.firstWhere((f) => f.id == item.id);
                                          updatedFood.quantity = quantity;

                                          dropDownKey.currentState!.changeSelectedItems(selectedFoods);
                                        }

                                        if (context.mounted) {
                                          Navigator.of(context).pop();
                                        }
                                      },
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
                      padding: EdgeInsets.symmetric(horizontal: Spacing.medium),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text("Search for ingredients"),
                      ),
                    ),
                    listViewProps: const ListViewProps(
                      padding: EdgeInsets.only(left: Spacing.medium, right: Spacing.medium, top: Spacing.medium),
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
                child: Container(
                  width: double.infinity,
                  padding: fieldPadding,
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
                    child: const Text("Save meal"),
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
