import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:snacktrack/tools/http_request.dart';
import 'package:snacktrack/tools/stored_prefs.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import 'package:snacktrack/auth.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Overview extends StatefulWidget {

  @override
  OverviewState createState() {
    return OverviewState();
  }
}

class ChartData {
  ChartData(this.x, this.y);

  final String x;
  final double y;
}

final List<ChartData> chartData = [
  ChartData('Test', 25),
];

class OverviewState extends State<Overview> {

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

    final prefs = Provider.of<Prefs>(context);
    final request = new HttpRequest();

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
                child: FutureBuilder(
                  future: request.getParsedWeightJson(),
                  builder: (context, weights) {
                    switch (weights.connectionState) {
                      case ConnectionState.none: return Container(height: 200.0,);
                      case ConnectionState.waiting: return Container(
                        height: 200.0,
                        width: 200.0,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                      default:
                        if (weights.hasError) return Text('Error: ${weights.data}');
                        else return Container(
                            height: 200.0,
                            child: _buildLineChart(weights.data)
                        );
                    }
                  },
                )
            ),
          ],
        )
    );
  }
}

_buildLineChart(List<Weight> weights) {

  return SfCartesianChart(
    primaryXAxis: DateTimeAxis(),
    primaryYAxis: NumericAxis(),
    tooltipBehavior: TooltipBehavior(enable: true),
    series: <LineSeries<Weight, DateTime>>[
      LineSeries<Weight, DateTime>(
        dataSource: weights,
        xValueMapper: (Weight weights, _) => weights.date,
        yValueMapper: (Weight weights, _) => weights.weight,
      )
    ],
  );
}

