import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
                    progressColor: Colors.blue,
                    animation: true,
                    animationDuration: 500,
                    circularStrokeCap: CircularStrokeCap.round,
                    center: _profileImage,
                  );
                }
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlatButton( // Daily KJ
                    child: Center(
                      child: PreferenceBuilder<int>(
                        preference: prefs.kj,
                        builder: (context, kjStream) => GestureDetector(
                          onLongPress: () {
                            Fluttertoast.showToast(msg: "🥒"); // Gherkin
                          },
                          child: Text(
                            "$kjStream KJ",
                            style: TextStyle(
                              fontFamily: 'Open Sans',
                              fontSize: 20,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        )
                      )
                    ),
                    onPressed: () {},
                  ),
                  FlatButton( // Daily KJ
                    child: Center(
                      child: PreferenceBuilder<double>(
                        preference: prefs.weight,
                        builder: (context, weightStream) => GestureDetector(
                          onLongPress: () {
                            Fluttertoast.showToast(msg: "🚂🚃🚃🚃🚃🚃");
                          },
                          child: Text(
                            "${num.parse(weightStream.toStringAsFixed(2))} KG",
                            style: TextStyle( // TODO Move to variable
                              fontFamily: 'Open Sans',
                              fontSize: 20,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      )
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            Card(
                elevation: 0.0,
                color: Colors.transparent,
                margin: new EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 6.0),
                child: PreferenceBuilder(
                  preference: prefs.weightTarget,
                  builder: (context, weightTarget) => StreamBuilder( // TODO Try avoiding nested streams
                      stream: prefs.weights,
                      builder: (context, weightStream) {
                        switch (weightStream.connectionState) {
                          case ConnectionState.none: return Container(height: 200.0,);
                          case ConnectionState.waiting: return Container(
                            height: 200.0,
                            width: 200.0,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                          default:
                            if (weightStream.hasError) return Text('Error: ${weightStream.data}');
                            else return Container(
                                height: 200.0,
                                child: _buildLineChart(weightStream.data, weightTarget) // TODO Add loading animation if values are being updated
                            );
                        }
                      }
                  )
                )
            ),
          ],
        )
    );
  }
}

_buildLineChart(Weights weights, int weightTarget) {

  List<Weight> weightList = weights.weightList;

  return SfCartesianChart(
    primaryXAxis: DateTimeAxis(
      majorGridLines: MajorGridLines(width: 0),
      interval: 1,
    ),
    primaryYAxis: NumericAxis(
      interval: 1,
    ),
    tooltipBehavior: TooltipBehavior(
      enable: true,
      header: '',
      canShowMarker: false,
      animationDuration: 0,
      elevation: 0,
      format: 'point.y KG',
    ),
    axes: <ChartAxis>[
      NumericAxis(
        name: "xAxis",
        isVisible: false
      ),
    ],
    series: <CartesianSeries>[
      SplineSeries<Weight, DateTime>(
        dataSource: weightList,
        xValueMapper: (Weight weights, _) => new DateTime.fromMicrosecondsSinceEpoch(weights.date),
        yValueMapper: (Weight weights, _) => weights.weight,
        animationDuration: 0, // TODO Fix linechart animating on sliding panel pull, animates when data points values are updated it seems
        color: Colors.blue,
        splineType: SplineType.natural,
        markerSettings: MarkerSettings(isVisible: true),
      ),
      LineSeries<WeightTarget, int>(
        dataSource: [new WeightTarget(1, weightTarget), new WeightTarget(2, weightTarget)],
        xAxisName: "xAxis",
        dashArray: [10, 16],
        enableTooltip: false,
        opacity: 0.7,
        xValueMapper: (WeightTarget data, _) => data.x,
        yValueMapper: (WeightTarget data, _) => data.y,
        animationDuration: 0,
        color: Colors.blue,
      )
    ],
  );
}

class WeightTarget {
int x;
int y;

  WeightTarget(int x, int y) {
    this.x = x;
    this.y = y;
  }
}

