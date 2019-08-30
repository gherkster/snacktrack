import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  void _pushSaved() {

    Navigator.of(context).push(
        MaterialPageRoute<void>(
            builder: (BuildContext context){
              return Scaffold(
                appBar: AppBar(
                  title: Text('Add KJ Intake'),
                ),
                body: MyCustomForm(),
              );
            }
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _pushSaved,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
      body: new IntakeList(),
      // TODO Insert floating action button here?
    );
  }
}

class IntakeList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
      stream: Firestore.instance.collection('kj-intakes').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return new Text('Loading...');
        return new Scaffold(
          backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
          bottomNavigationBar: makeBottom,
          body: overviewBody,
        );
        return new ListView(
          children: snapshot.data.documents.map((document) {
            return new Card(
              child: Padding(
                padding: EdgeInsets.only(
                  top: 6.0, left: 6.0, right: 6.0, bottom: 6.0,
                ),
                child: ExpansionTile(
                  title: Text('TOTAL KJ FOR \$DAY'),
                  children: <Widget>[
                    Text('KJ VALUE 1'),
                    Text('KJ VALUE 2'),
                    Text('KJ VALUE 3'),
                  ],
                ),
              ),
            );
            return new ListTile(
            title: new Text(document['kj'].toString() + "kj"),
        subtitle: new Text(document['date'].toString()),
            );
        }).toList(),
        );
      },
    );
  }
}

final makeBottom = Container(
  height: 55.0,
  child: BottomAppBar(
    color: Color.fromRGBO(58, 66, 86, 1.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.home, color: Colors.white),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.blur_on, color: Colors.white),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.hotel, color: Colors.white),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.account_box, color: Colors.white),
          onPressed: () {},
        )
      ],
    ),
  ),
);

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
