import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:snacktrack/ext/flutter_number_picker/flutter_number_picker.dart';
import 'package:snacktrack/src/models/weight.dart';
import 'package:snacktrack/src/viewmodels/interfaces/i_navigation_viewmodel.dart';
import 'package:snacktrack/src/viewmodels/interfaces/i_overview_viewmodel.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class OverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          const SizedBox(height: 80.0), // TODO calculate
          Consumer<IOverviewViewModel>(
            builder: (context, overviewModel, child) {
              return Consumer<INavigationViewModel>(
                builder: (context, navModel, child) {
                  return CircularPercentIndicator(
                    radius: 200.0,
                    lineWidth: 16.0,
                    percent: overviewModel.energyCurrentTotalClamped,
                    progressColor: overviewModel.energyCurrentTotal > overviewModel.energyTarget ? Colors.red : Colors.blue,
                    animation: true,
                    animateFromLastPercent: true,
                    circularStrokeCap: CircularStrokeCap.round,
                    center: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: Text(overviewModel.energyCurrentTotal.toString(), style: const TextStyle(fontSize: 30)),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(overviewModel.energyTarget.toString(), style: const TextStyle(fontSize: 16)),
                        )
                      ],
                    ),
                  );
                },
              );
            },
          ),
          Center(child: Consumer<IOverviewViewModel>(
            builder: (context, model, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomDecimalNumberPicker(
                    initialValue: Decimal.parse(model.weightCurrent.toString()),
                    minValue: Decimal.parse(model.weightMinSelectable.toString()),
                    maxValue: Decimal.parse(model.weightMaxSelectable.toString()),
                    step: Decimal.parse("0.1"),
                    roundingPlaces: 1,
                    incrementSpeedMilliseconds: 200,
                    onValue: (value) => model.weightCurrent = value.toDouble(),
                  ),
                  CustomDecimalNumberPicker(
                    initialValue: Decimal.parse(model.weightTarget.toString()),
                    minValue: Decimal.parse(model.weightMinSelectable.toString()),
                    maxValue: Decimal.parse(model.weightMaxSelectable.toString()),
                    step: Decimal.parse("0.1"),
                    roundingPlaces: 1,
                    incrementSpeedMilliseconds: 200,
                    onValue: (value) => model.weightTarget = value.toDouble(),
                  ),
                ],
              );
            },
          )),
          Card(
            elevation: 0.0,
            color: Colors.transparent,
            margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Container(
                  height: 200,
                  padding: const EdgeInsets.fromLTRB(4.0, 4.0, 10.0, 4.0),
                  child: Consumer<IOverviewViewModel>(
                    builder: (context, model, child) {
                      return SfCartesianChart(
                        primaryXAxis: DateTimeAxis(majorGridLines: MajorGridLines(width: 0), intervalType: DateTimeIntervalType.days, interval: 1),
                        primaryYAxis: NumericAxis(
                            plotBands: [
                              PlotBand(
                                isVisible: true,
                                start: model.weightTarget,
                                end: model.weightTarget,
                                dashArray: [10, 21],
                                borderWidth: 2,
                                borderColor: Colors.blue,
                                opacity: 0.5,
                              ),
                            ],
                            minorTicksPerInterval:
                                1), // Both 2nd digit of min and max (ie min 40<-, max 80<-) need to be 5 or 0 if setting manually, can't be different
                        tooltipBehavior: TooltipBehavior(
                          enable: true,
                          header: '',
                          canShowMarker: false,
                          animationDuration: 0,
                          elevation: 0,
                          format: 'point.y ${describeEnum(model.weightUnit)}',
                        ),
                        series: <CartesianSeries>[
                          SplineSeries<Weight, DateTime>(
                            dataSource: model.weightAllRecentValues,
                            xValueMapper: (Weight _weights, _) => _weights.time,
                            yValueMapper: (Weight _weights, _) => _weights.weight,
                            color: Colors.blue,
                            splineType: SplineType.monotonic,
                            markerSettings: MarkerSettings(isVisible: true),
                          ),
                        ],
                      );
                    },
                  )),
            ),
          ),
        ],
      ),
    );
  }
}

class WeightTarget {
  DateTime time;
  double target;

  WeightTarget(this.time, this.target);
}
