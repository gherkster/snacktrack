import 'package:flutter/material.dart';
import 'package:snacktrack/auth.dart';
import 'package:snacktrack/tools/database.dart';

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
      child: ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.person_outline),
            title: Text('Sign Out'),
            onTap: _signOut,
          ),
          ListTile(
            leading: Icon(Icons.delete_forever),
            title: Text('Clear Database'),
            onTap: _deleteAll,
          )
        ],
        )
    );
  }

  _deleteAll() {
    Database db = new Database();
    db.delete();
  }

  _signOut() {
    var auth = new Auth();
    auth.emailSignOut();
    Navigator.pushNamed(context, '/loginSignupPage');
  }
}