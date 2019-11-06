import 'package:flutter/material.dart';
import 'package:snacktrack/auth.dart';
import 'package:snacktrack/login_register.dart';

class Settings extends StatefulWidget {
  @override
  SettingsState createState() {
    return SettingsState();
  }
}

class SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Material(
        child: RaisedButton(
            onPressed: () => _signOut() // TODO Signout google too
        )
    );
  }

  _signOut() {
    var auth = new Auth();
    auth.emailSignOut();
    Navigator.pushNamed(context, '/loginSignupPage');
  }
}