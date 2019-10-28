import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter/services.dart';
import 'package:percent_indicator/percent_indicator.dart';

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
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

FocusNode textFocus = new FocusNode();

class _HomePageState extends State<HomePage> {

  final double _initFabHeight = 120.0;
  double _fabHeight;
  double _panelHeightOpen = 575.0;
  double _panelHeightClosed = 95.0;

  final List<Widget> _widgetOptions = [
    Center(child: OverviewMenu()),
    Center(child: Text("Numba 2"),),
    Center(child: Text("Numba 3"),),
    Center(child: Text("Numba 4"),),
    Center(child: Text("Numba 5")),
  ];

  int _selectedIndex = 0;
  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState(){
    super.initState();
    _fabHeight = _initFabHeight;
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
            onPanelOpened: () => setState((){
              FocusScope.of(context).requestFocus(textFocus);
            }),
            parallaxEnabled: true,
            parallaxOffset: .5,
            body: _body(),
            panel: _panel(),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0)),
            onPanelSlide: (double pos) => setState((){
              _fabHeight = pos * (_panelHeightOpen - _panelHeightClosed) + _initFabHeight;
              if (pos < 0.9) {
                FocusScope.of(context).requestFocus(FocusNode());
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
                validator: (val) {
                  if(val.length == 0) {
                    return null;
                  } else {
                    return null;
                  }
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

class Weight {
  final int year;
  final int clicks;

  Weight(this.year, this.clicks);
}
var data = [
  new Weight(0, 70),
  new Weight(1, 68),
  new Weight(2, 65),
];
var series = [
  new Series(
    id: 'Clicks',
    colorFn: (_, __) => MaterialPalette.blue.shadeDefault,
    domainFn: (Weight clickData, _) => clickData.year,
    measureFn: (Weight clickData, _) => clickData.clicks,
    data: data,
  ),
];
var chart = new LineChart(
  series,
  animate: true,
  primaryMeasureAxis: new NumericAxisSpec(
    viewport: NumericExtents(50.0, 80.0),
  ),
  domainAxis: new NumericAxisSpec( // TODO DateTimeAxisSpec
    viewport: NumericExtents(0.0, 5.0),
  ),
);

class OverviewMenu extends StatefulWidget {
  @override
  OverviewMenuState createState() {
    return OverviewMenuState();
  }
}
class OverviewMenuState extends State<OverviewMenu> {

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        CircularPercentIndicator(
          radius: 200.0,
          lineWidth: 6.0,
          percent: 0.5,
          progressColor: Colors.blueAccent,
          animation: true,
          animationDuration: 1000,
          circularStrokeCap: CircularStrokeCap.round,
          center: Card(
            child: CircleAvatar(
              radius: 80,
              backgroundImage: NetworkImage('https://i.kinja-img.com/gawker-media/image/upload/c_lfill,w_768,q_90/txthbfekk2a1garzhu0j.jpg'),
            ),
            elevation: 20.0,
            shape: CircleBorder(),
            clipBehavior: Clip.antiAlias,
          ),
        ),
        Center(
          child: Container(
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              title: new Center(child: Text("7000 KJ")),
              subtitle: new Center(child: Text("Intake for today")),
            ),
          ),
        ),
        Card( // TODO Remove card if possible
            elevation: 0.0,
            color: Colors.transparent,
            margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: Container(
            height: 200.0,
            child: chart
          )
        ),
      ],
    );
  }
}
