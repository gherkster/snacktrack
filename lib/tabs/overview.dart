import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

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
              center: Card(
                child: CircleAvatar(
                  radius: 80,
                  backgroundImage: NetworkImage(
                      'https://i.kinja-img.com/gawker-media/image/upload/c_lfill,w_768,q_90/txthbfekk2a1garzhu0j.jpg'), // TODO Get image from Google profile, onClick let user change image
                ),
                elevation: 20.0,
                shape: CircleBorder(),
                clipBehavior: Clip.antiAlias,
              ),
            ),
            Center(
              child: Container(
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  title: new Center(child: Text("7000 KJ")),
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