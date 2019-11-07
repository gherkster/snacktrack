import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter/services.dart';
// import 'package:fit_kit/fit_kit.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:snacktrack/database.dart';

import 'package:snacktrack/login_register.dart';
import 'package:snacktrack/tabs/overview.dart';
import 'package:snacktrack/tabs/history.dart';
import 'package:snacktrack/tabs/graph.dart';
import 'package:snacktrack/tabs/settings.dart';
import 'package:snacktrack/totalValueBloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.grey[200],
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarDividerColor: Colors.black,
    ));

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => Router(),
        '/homepage': (context) => HomePage(), // TODO Descriptions for each
        '/loginSignupPage': (context) => LoginSignupPage(),

        '/overview': (context) => Overview(),
        '/settings': (context) => Settings(),
      },
      //home: Router(),
    );
  }
}

FirebaseAuth _auth = FirebaseAuth.instance;

class Router extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new StreamBuilder(
        stream: _auth.onAuthStateChanged,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return HomePage();
          }
          return LoginSignupPage();
        },
      )
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  FocusNode textFocus = new FocusNode();
  PanelController _pc = new PanelController();
  TextEditingController _textController = new TextEditingController();

  double _panelHeightOpen = 575.0;
  double _panelHeightClosed = 95.0;

  final List<Widget> _widgetOptions = [
    Center(child: Overview()),
    Center(child: Text("Number 2"),),
    Center(child: Text("Number 3"),),
    Center(child: new Settings()),
  ];

  int _selectedIndex = 0;
  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context){
    return Material(
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          SlidingUpPanel(
            maxHeight: _panelHeightOpen,
            minHeight: _panelHeightClosed,
            controller: _pc,
            onPanelOpened: () => setState((){
              FocusScope.of(context).requestFocus(textFocus);
            }),
            parallaxEnabled: true,
            parallaxOffset: .5,
            body: _body(),
            panel: _panel(),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0)),
            onPanelSlide: (double pos) => setState((){
              if (pos < 0.9) {
                FocusScope.of(context).unfocus();
              }
            }),
          ),
        ],
      ),
    );
  }

  Widget _panel(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 12.0,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 30,
              height: 5,
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.all(Radius.circular(12.0))
              ),
            ),
          ],
        ),
        SizedBox(height: 18.0,),
        BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          elevation: 0.0,
          backgroundColor: Colors.white,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              title: Text("Overview"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              title: Text("History"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.trending_up),
              title: Text("Graph"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              title: Text("Settings"),
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.red[800],
          onTap: _onTabTapped,
        ),
        SizedBox(height: 36.0,),
        Container(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: _textController,
                focusNode: textFocus,
                style: TextStyle(
                  fontSize: 28,
                ),
                textInputAction: TextInputAction.send,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 0.0),
                  ),
                  focusedBorder: OutlineInputBorder(

                  ),
                  labelText: "Enter KJ",
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide(),
                  ),
                ),
                onFieldSubmitted: (input){
                  Database db = new Database();
                  db.create('kj-intakes', {
                    'kj': input,
                    'date': DateTime.now()
                  });
                  db.updateTotal();
                  _textController.clear();
                  // TODO Check value received
                  // TODO Last 24 hours is not working properly, last 18 hours
                  _pc.close();
                },
                keyboardType: TextInputType.number,
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _body(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        (_widgetOptions.elementAt(_selectedIndex)),
      ],
    );
  }
}
