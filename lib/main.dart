import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kj_tracker/fabBottomAppBar.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _index = 0;

  final List<Widget> _children = [
    Center(child: Text("Numba 1"),),
    Center(child: Text("Numba 2"),),
    Center(child: Text("Numba 3"),),
    Center(child: new MyCustomForm()),
  ];

  void onTabTapped(int index) {
    setState(() {
      _index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
      stream: Firestore.instance.collection('kj-intakes').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return new Text('Loading...');
        return Scaffold(
          appBar: AppBar(
            title: Text('AppBar Title')
          ),
          body: Center(
            child: (_children[_index]),
          ),
          bottomNavigationBar: FABBottomAppBar(
            centerItemText: 'Add KJ',
            color: Colors.grey,
            selectedColor: Colors.red,
            notchedShape: CircularNotchedRectangle(),
            onTabSelected: onTabTapped,
            items: [
              FABBottomAppBarItem(iconData: Icons.dashboard, text: 'Overview'),
              FABBottomAppBarItem(iconData: Icons.history, text: 'History'),
              FABBottomAppBarItem(iconData: Icons.trending_up, text: 'Graph'),
              FABBottomAppBarItem(iconData: Icons.settings, text: 'Settings'),
            ]
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            tooltip: '🥒', // Gherkin
            child: Icon(Icons.add),
            elevation: 2.0,
          ),
          //body: overviewBody,
        );
      },
    );
  }
}

final overviewBody = Column(
  mainAxisAlignment: MainAxisAlignment.center,
  crossAxisAlignment: CrossAxisAlignment.center,
  children: <Widget>[
    Align(
      alignment: Alignment.center,
      child: Container(
        child: Text(
            "5800 KJ",
          style: new TextStyle(
            fontSize: 60.0,
            color: Colors.white,
            fontFamily: 'Open Sans',
          )
        ),
      )
    )
  ]
);

class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2019, 1),
        lastDate: DateTime(2099));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  TextEditingController kjController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: kjController,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Enter KJ intake';
                }
                return null;
              },
            ),
            SizedBox(height: 20.0),
            RaisedButton(
              onPressed: () {
                _selectDate(context);
              },
              child: Text(new DateFormat('EEEE, dd MMMM yy').format(selectedDate)),
            ),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: RaisedButton(
                  onPressed: () {
                    Firestore.instance.collection('kj-intakes').document().setData({'date': selectedDate, 'kj': kjController.text}); // Add data
                    if (_formKey.currentState.validate()) {
                      Scaffold.of(context)
                          .showSnackBar(SnackBar(content: Text('Processing Data')));
                    }
                  },
                  child: Text('Submit'),
                )
            )
          ],
        )
    );
  }
}
