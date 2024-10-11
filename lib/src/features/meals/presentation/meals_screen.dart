import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:snacktrack/src/features/meals/domain/meal.dart";
import "package:snacktrack/src/features/meals/presentation/forms/create_meal_form.dart";
import "package:snacktrack/src/features/meals/services/meal_service.dart";
import "package:snacktrack/src/widgets/big_heading.dart";

class MealsScreen extends StatelessWidget {
  const MealsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mealService = context.watch<MealService>();

    return Scaffold(
      appBar: AppBar(
        actions: [
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
        padding: const EdgeInsets.symmetric(horizontal: 16),
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
                            return ListTile(
                              title: Text(meals[index].name),
                              subtitle: Text(meals[index].foods.map((f) => f.name).toList().toString()),
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
