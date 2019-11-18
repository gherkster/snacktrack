import 'package:flutter/material.dart';
import 'package:snacktrack/auth.dart';
import 'package:snacktrack/tools/database.dart';
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
          ),
          ListTile(
            title: Text('Print Google Account'),
            onTap: _printGoogleAccount,
          ),
          ListTile(
            title: Text('Update Weight Data'),
            onTap: _printWeightData,
          ),
          ListTile(
            title: Text('Measurement Units'),
            onTap: _printWeightData,
          ),
          ListTile(
            title: Text('Energy Target'),
            onTap: _printWeightData,
          ),
          ListTile(
            title: Text('Weight Target'),
            onTap: _printWeightData,
          ),
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

  _printGoogleAccount() {
    var auth = new Auth();
    print(auth.getGoogleIdentity());
  }

  _printWeightData() async {
    HttpRequest request = new HttpRequest();
    request.fetchNewWeightData();
  }
}