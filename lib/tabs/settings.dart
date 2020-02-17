import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';
import 'package:snacktrack/auth.dart';
import 'package:snacktrack/tools/http_request.dart';
import 'package:snacktrack/tools/stored_prefs.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class Settings extends StatefulWidget {
  @override
  SettingsState createState() {
    return SettingsState();
  }
}

class SettingsState extends State<Settings> {

  @override
  Widget build(BuildContext context) {

    final prefs = Provider.of<Prefs>(context);
    int _currentTarget = prefs.weightTarget.getValue();

    return Material(
      child: Container(
        height: MediaQuery.of(context).size.height * 3 / 4,
        child: ListView(
          //shrinkWrap: true,
          children: <Widget>[
            ListTile(
              subtitle: Text("Units"), // TODO Reduce tile height
            ),
            ListTile(
                title: Text("Energy"),
                subtitle: Text("Kilojoules"),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              RadioListTile(
                                title: Text("Kilojoules"),
                                value: "",
                              ),
                              RadioListTile(
                                title: Text("Calories"),
                                value: "",
                              ),
                            ],
                          ),
                        );
                      }
                  );
                }
            ),
            ListTile(
                title: Text("Weight"),
                subtitle: Text("Kilograms"),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              RadioListTile(
                                title: Text("Kilograms"),
                                value: "",
                              ),
                              RadioListTile(
                                title: Text("Pounds"),
                                value: "",
                              ),
                            ],
                          ),
                        );
                      }
                  );
                }
            ),
            ListTile(
              subtitle: Text("Targets"),
            ),
            ListTile(
              title: Text("Energy Target"),
              subtitle: Text("8500 KJ"),
            ),
            ListTile(
                title: Text("Weight Target"),
                subtitle: Text("${prefs.weightTarget.getValue()} KG"), // TODO Use lbs if set above
                onTap: () {
                  showDialog<int>(
                      context: context,
                      builder: (BuildContext context) {
                        return NumberPickerDialog.integer(
                          title: Text("Target Weight"),
                          initialIntegerValue: _currentTarget, // TODO Set to current
                          minValue: 0,
                          maxValue: 200,

                        );
                      }
                  ).then((weightTarget) {
                    if (weightTarget != null) {
                      setState(() {
                        _currentTarget = weightTarget;
                        prefs.weightTarget.setValue(weightTarget);
                      });
                    }
                  });
                }
            ),
            ListTile(
              subtitle: Text("Account"),
            ),
            ListTile(
              title: Text("Sign Out"),
              subtitle: Text("Patrick Benter"), // TODO Get name
            ),
            ListTile(
              title: Text("Update Weight Data"),
              onTap: () {
                HttpRequest request = new HttpRequest();
                request.fetchNewWeightData();
              },
            ),
            ListTile(
              title: Text("Log Out"),
              onTap: () {
                Auth auth = new Auth();
                auth.signOutWithGoogle();
                Navigator.pushReplacementNamed(context, '/loginSignupPage');
              },
            )
          ]),
      )
    );
  }

  _updateWeightTarget(int target) async {
    StreamingSharedPreferences preferences = await StreamingSharedPreferences.instance;
    Prefs prefs = new Prefs(preferences);

    prefs.weightTarget.setValue(target);
  }

}
