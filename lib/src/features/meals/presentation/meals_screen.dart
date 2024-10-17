import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:snacktrack/src/extensions/iterable.dart";
import "package:snacktrack/src/features/meals/domain/meal.dart";
import "package:snacktrack/src/features/meals/presentation/forms/create_meal_form.dart";
import "package:snacktrack/src/features/meals/services/meal_service.dart";
import "package:snacktrack/src/features/settings/services/settings_service.dart";
import "package:snacktrack/src/styles/layout.dart";
import "package:snacktrack/src/utilities/unit_conversion.dart";
import "package:snacktrack/src/widgets/app_bar_menu.dart";
import "package:snacktrack/src/widgets/big_heading.dart";

class MealsScreen extends StatelessWidget {
  const MealsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mealService = context.watch<MealService>();
    final settingsService = context.watch<SettingsService>();

    return Scaffold(
      appBar: AppBar(
        actions: [
          AppBarMenu(
            menuItems: [
              MenuItemButton(
                child: const Text('Manage foods'),
                onPressed: () {},
              ),
            ],
          )
        ],
      ),
      resizeToAvoidBottomInset: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        label: const Text("Create meal"),
        icon: const Icon(Icons.add),
        onPressed: () => {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const CreateMealForm();
              },
            ),
          )
        },
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.medium),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BigHeading(title: "Meals"),
              FutureBuilder<List<Meal>>(
                future: mealService.getMeals(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const CircularProgressIndicator();
                    default:
                      if (snapshot.hasError) {
                        return Text("Error ${snapshot.error}");
                      } else {
                        var meals = snapshot.data ?? [];
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: meals.length,
                          itemBuilder: (context, index) {
                            final mealEnergy = convertKilojoulesToPreferredUnits(
                                meals[index].mealFoods.map((f) => f.totalKilojoules).sum(), settingsService.energyUnit);
                            return ListTile(
                              title: Text(meals[index].name),
                              subtitle: Text("$mealEnergy ${settingsService.energyUnit.longName}"),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return CreateMealForm(meal: meals[index]);
                                    },
                                  ),
                                );
                              },
                            );
                          },
                        );
                      }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
