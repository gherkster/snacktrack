import 'package:charts_flutter/flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:snacktrack/database.dart';
import 'package:transparent_image/transparent_image.dart';

import 'package:snacktrack/auth.dart';

class Overview extends StatefulWidget {
  @override
  OverviewState createState() {
    return OverviewState();
  }
}
class OverviewState extends State<Overview> {

  /*void read() async {
    final results = await FitKit.read(
      DataType.WEIGHT,
      DateTime.now().subtract(Duration(days:90)),
      DateTime.now(),
    );
    print(results);
  }*/

  @override
  void initState() {
    super.initState();
  }

  String photoUrl;
   Future<String> _getImage() async {
    Auth auth = Auth();
    FirebaseUser user = await auth.getCurrentUser();
    photoUrl = user.photoUrl.substring(0, user.photoUrl.length - 4) + "512" ;
    // TODO If null, use placeholder
    return photoUrl;
  }

  @override
  Widget build(BuildContext context) {

    return Material(
        child: Column(
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
              center: FutureBuilder<String>(
                future: _getImage(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  else {
                    return Card(
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(snapshot.data.toString()),
                        radius: 80.0,
                        ),
                      elevation: 20.0,
                      shape: CircleBorder(),
                      clipBehavior: Clip.antiAlias,
                    );
                  }
                },
              )
            ),
            Center(
              child: Container(
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  title: new Center(
                    child: FutureBuilder(
                      future: _getKJToday(),
                      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting: return Text('Loading...');
                          default:
                            if (snapshot.hasError) {
                              return Text('Error: Cannot get KJ');
                            }
                            else return Text(snapshot.data);
                        }
                      },
                    ),
                      //child: Text("7000 KJ")
                  ),
                  // TODO Save data locally and sync new values to allow app to work outside internet
                  subtitle: new Center(child: Text("Intake for today")),
                ),
              ),
            ),
            Card( // TODO Remove card if possible
                elevation: 0.0,
                color: Colors.transparent,
                margin: new EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 6.0),
                child: Container(
                    height: 200.0,
                    child: chart
                )
            ),
          ],
        )
    );
  }
}

int value;
Future<String> _getKJToday() async { // TODO Use local storage value in case no internet, only write collection to database once a day as backup with total, avoids doing lots of small writes
                                      // TODO Do same with reads, is reading only for backup?
  Database db = new Database();
  value = await db.read('kj-intakes');
  return value.toString();
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