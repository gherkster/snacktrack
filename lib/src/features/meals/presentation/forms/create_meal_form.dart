import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snacktrack/src/extensions/datetime.dart';
import 'package:snacktrack/src/features/meals/services/meal_service.dart';
import 'package:snacktrack/src/widgets/big_heading.dart';

class CreateMealForm extends StatefulWidget {
  const CreateMealForm({super.key});

  @override
  State<CreateMealForm> createState() => _CreateMealFormState();
}

class _CreateMealFormState extends State<CreateMealForm> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final energyInputController = TextEditingController();

  final fieldPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8);

  var date = DateTime.now().date;
  var time = TimeOfDay.now();

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
                child: SearchAnchor(
                  builder: (BuildContext context, SearchController controller) {
                    return SearchBar(
                      controller: controller,
                      hintText: "Search foods",
                      padding: const WidgetStatePropertyAll<EdgeInsets>(EdgeInsets.symmetric(horizontal: 16.0)),
                      onTap: () => controller.openView(),
                      onChanged: (_) => controller.openView(),
                      leading: const Icon(Icons.search),
                    );
                  },
                  suggestionsBuilder: (BuildContext context, SearchController controller) {
                    return List<ListTile>.generate(
                      5,
                      (int index) {
                        final String item = 'item $index';
                        return ListTile(
                          title: Text(item),
                          onTap: () {
                            setState(() {
                              controller.closeView(item);
                              // Clear the input field to allow searching for more foods
                              controller.text = "";
                            });
                          },
                        );
                      },
                    );
                  },
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
