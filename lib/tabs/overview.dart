import 'package:charts_flutter/flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:snacktrack/stored_prefs.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import 'package:snacktrack/database.dart';

import 'package:snacktrack/auth.dart';

class Overview extends StatefulWidget {



  @override
  OverviewState createState() {
    return OverviewState();
  }
}
class OverviewState extends State<Overview> {

  @override
  void initState() {
    super.initState();
    Database db = new Database();
    db.updateTotal();
    db.getWeight();
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

    final prefs = Provider.of<Prefs>(context);

    final _profileImage = FutureBuilder<String>(
      future: _getImage(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        else {
          return Card(
            child: CircleAvatar(
              backgroundImage: NetworkImage(snapshot.data.toString()), // TODO Save image on first login
              radius: 80.0,
            ),
            elevation: 20.0,
            shape: CircleBorder(),
            clipBehavior: Clip.antiAlias,
          );
        }
      },
    );

    return Material(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            PreferenceBuilder<int>(
              preference: prefs.kj,
              builder: (context, kjStream) {
                return CircularPercentIndicator(
                  radius: 200.0,
                  lineWidth: 6.0,
                  percent: (((kjStream).toDouble()) / 8500).clamp(0.0, 1.0),
                  progressColor: Colors.blueAccent,
                  animation: true,
                  animationDuration: 500,
                  circularStrokeCap: CircularStrokeCap.round,
                  center: _profileImage,
                );
              }
            ),
            Center(
              child: Container(
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  title: Center(
                    child: PreferenceBuilder<int>(
                      preference: prefs.kj,
                      builder: (context, kjStream) => Text("$kjStream KJ"),
                    )
                  ),
                  subtitle: new Center(child: Text("Intake for today")),
                ),
              ),
            ),
            Card(
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

class Weight {
  final DateTime date;
  final double weight;

  Weight(this.date, this.weight);
}
var data = [
  new Weight(new DateTime(2910, 11, 8), 70.0),
  new Weight(new DateTime(2910, 11, 7), 69.8),
  new Weight(new DateTime(2910, 11, 6), 69.7),
  new Weight(new DateTime(2910, 11, 5), 69.6),
  new Weight(new DateTime(2910, 11, 4), 69.3),
  new Weight(new DateTime(2910, 11, 3), 69.2),
  new Weight(new DateTime(2910, 11, 2), 69.2),
];
var series = [
  new Series(
    id: 'Clicks',
    colorFn: (_, __) => MaterialPalette.blue.shadeDefault,
    domainFn: (Weight weights, _) => weights.date,
    measureFn: (Weight weights, _) => weights.weight,
    data: data,
  ),
];
var chart = new TimeSeriesChart(
  series,
  animate: false,
  primaryMeasureAxis: new NumericAxisSpec(
    viewport: NumericExtents(71, 68.0), // Set programmatically
    tickProviderSpec: BasicNumericTickProviderSpec(
    )
  ),
  domainAxis: new DateTimeAxisSpec(
    tickProviderSpec: DayTickProviderSpec(increments: [1]),
    tickFormatterSpec: AutoDateTimeTickFormatterSpec(
      day: TimeFormatterSpec(
        format: 'EEE', transitionFormat: 'EEE', noonFormat: 'EEE'
      )
    )
  ),
);
