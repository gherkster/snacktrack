import 'dart:async';

import 'package:flutter/material.dart';
import 'package:snacktrack/tools/lifecycle_event_handler.dart';
import 'package:snacktrack/tools/stored_prefs.dart';
import 'package:snacktrack/tools/update_data.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:snacktrack/login_register.dart';
import 'package:snacktrack/tabs/overview.dart';
import 'package:snacktrack/tabs/history.dart';
import 'package:snacktrack/tabs/graph.dart';
import 'package:snacktrack/tabs/settings.dart';
import 'package:syncfusion_flutter_core/core.dart';

import 'package:snacktrack/auth/keys.dart';

Future<void> main() async {
  final preferences = await StreamingSharedPreferences.instance;
  final prefs = Prefs(preferences);

  SyncfusionLicense.registerLicense(Keys.SYNCFUSION_KEY);

  runApp(
    Provider<Prefs>.value(value: prefs, child: MyApp()),
  );
}

class MyApp extends StatelessWidget {

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
      debugShowCheckedModeBanner: false,
    );
  }
}

class Router extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Material(
      child: new FutureBuilder( // TODO Save login state to skip frame of login page
        future: FirebaseAuth.instance.currentUser(),
        builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
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

  static final FocusNode textFocus = new FocusNode();
  static final PanelController _pc = new PanelController();
  static final TextEditingController _textController = new TextEditingController();
  static final _formKey = new GlobalKey<FormState>();

  double _panelHeightOpen = 450.0;
  double _panelHeightClosed = 95.0;

  static final Overview _overview = new Overview();
  static final Settings _settings = new Settings();

  final List<Widget> _widgetOptions = [
    Center(child: _overview),
    Center(child: Text("Number 2"),),
    Center(child: Text("Number 3"),),
    Center(child: _settings),
  ];

  int _selectedIndex = 0;
  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(new LifecycleEventHandler(resumeCallBack: () async => UpdateData.updateDataIfNextDay()));
  }

  @override
  Widget build(BuildContext context){

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SlidingUpPanel(
        maxHeight: _panelHeightOpen,
        minHeight: _panelHeightClosed,
        controller: _pc,
        onPanelOpened: () => setState((){
          FocusScope.of(context).requestFocus(textFocus);
        }),
        parallaxEnabled: true,
        parallaxOffset: .5,
        body: _body(), // Content behind sliding panel
        panel: _panel(),
        borderRadius: BorderRadius.only(topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0)),
        onPanelSlide: (double pos) => setState((){
          if (pos < 0.9) {
            FocusScope.of(context).unfocus();
          }
        })
      ),
    );
  }

  Widget _panel(){
    final prefs = Provider.of<Prefs>(context);

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
              Form(
                key: _formKey,
                child: TextFormField(
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
                    focusedBorder: OutlineInputBorder(),
                    labelText: "Enter KJ",
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(),
                    ),
                  ),
                  onFieldSubmitted: (input){
                    if (_formKey.currentState.validate()) {
                      int currentValue = prefs.kj.getValue();
                      prefs.kj.setValue(currentValue + int.parse(input));
                      _textController.clear();
                      _pc.close();
                    }
                  },
                  validator: (value) {
                    if (value.isEmpty || double.parse(value) == 0.0 || double.tryParse(value) == null) {
                      return ('Invalid KJ Intake');
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                ),
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
