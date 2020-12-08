import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';
import 'package:snacktrack/src/viewmodels/overview_viewmodel.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:snacktrack/src/models/weight.dart';
import 'package:snacktrack/src/repositories/interfaces/i_energy_repository.dart';
import 'package:snacktrack/src/repositories/interfaces/i_settings_repository.dart';
import 'package:snacktrack/src/repositories/interfaces/i_weight_repository.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class OverviewScreen extends StatefulWidget {
  @override
  _OverviewScreenState createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  OverviewViewModel _overviewViewModel;

  @override
  void didChangeDependencies() {
    if (_overviewViewModel == null) {
      final energyRepository = Provider.of<IEnergyRepository>(context);
      final weightRepository = Provider.of<IWeightRepository>(context);
      final settingsRepository = Provider.of<ISettingsRepository>(context);

      _overviewViewModel = OverviewViewModel(energyRepository, weightRepository, settingsRepository);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          const SizedBox(height: 80.0), // TODO calculate
          ValueListenableBuilder(
              valueListenable: _overviewViewModel.energyStream,
              builder: (BuildContext _, Box __, Widget ___) {
                return CircularPercentIndicator(
                    radius: 200.0,
                    lineWidth: 16.0,
                    percent: _overviewViewModel.energyCurrentTotalClamped,
                    progressColor: _overviewViewModel.energyCurrentTotal > _overviewViewModel.energyTarget ? Colors.red : Colors.blue,
                    animation: true,
                    animateFromLastPercent: true,
                    circularStrokeCap: CircularStrokeCap.round,
                    center: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ValueListenableBuilder(
                            valueListenable: _overviewViewModel.energyStream,
                            builder: (BuildContext context, Box box, Widget child) {
                              return Column(children: [
                                FlatButton(
                                    onPressed: () {}, child: Text(_overviewViewModel.energyCurrentTotal.toString(), style: const TextStyle(fontSize: 30))),
                                FlatButton(
                                  onPressed: () {},
                                  child: Text(_overviewViewModel.energyTarget.toString(), style: const TextStyle(fontSize: 16)),
                                )
                              ]);
                            }),
                      ],
                    ));
              }),
          Center(
              child: ValueListenableBuilder(
            valueListenable: _overviewViewModel.weightStream,
            builder: (BuildContext _, Box __, Widget ___) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ValueListenableBuilder(
                    valueListenable: _overviewViewModel.weightStream,
                    builder: (BuildContext _, Box __, Widget ___) {
                      return FlatButton(
                        onPressed: () {
                          showDialog<double>(
                              context: context,
                              builder: (BuildContext context) {
                                return NumberPickerDialog.decimal(
                                    minValue: 30, maxValue: 200, title: const Text('Current Weight'), initialDoubleValue: _overviewViewModel.weightCurrent);
                              }).then((weightCurrent) {
                            if (weightCurrent != null) {
                              _overviewViewModel.weightCurrent = weightCurrent;
                            }
                          });
                        },
                        child: Text('${_overviewViewModel.weightCurrent.toString()} ${describeEnum(_overviewViewModel.weightUnit)}'),
                      );
                    },
                  ),
                  ValueListenableBuilder(
                    valueListenable: _overviewViewModel.settingsStream,
                    builder: (BuildContext _, Box __, Widget ___) {
                      return FlatButton(
                        onPressed: () {
                          showDialog<double>(
                            context: context,
                            builder: (BuildContext context) {
                              return NumberPickerDialog.decimal(
                                minValue: 40,
                                maxValue: 200,
                                title: const Text('Target Weight'),
                                initialDoubleValue: _overviewViewModel.weightTarget,
                              );
                            },
                          ).then(
                            (weightTarget) {
                              if (weightTarget != null) {
                                _overviewViewModel.weightTarget = weightTarget;
                              }
                            },
                          );
                        },
                        child: Text('${_overviewViewModel.weightTarget.toString()} ${describeEnum(_overviewViewModel.weightUnit)}'),
                      );
                    },
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
                child: ValueListenableBuilder(
                  valueListenable: _overviewViewModel.weightStream,
                  builder: (BuildContext _, Box __, Widget ___) {
                    return ValueListenableBuilder(
                      valueListenable: _overviewViewModel.settingsStream,
                      builder: (BuildContext _, Box __, Widget ___) {
                        return SfCartesianChart(
                          primaryXAxis: DateTimeAxis(majorGridLines: MajorGridLines(width: 0), intervalType: DateTimeIntervalType.days, interval: 1),
                          primaryYAxis: NumericAxis(
                              plotBands: [
                                PlotBand(
                                  isVisible: true,
                                  start: _overviewViewModel.weightTarget,
                                  end: _overviewViewModel.weightTarget,
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
                            format: 'point.y ${describeEnum(_overviewViewModel.weightUnit)}',
                          ),
                          series: <CartesianSeries>[
                            SplineSeries<Weight, DateTime>(
                              dataSource: _overviewViewModel.weightAllRecentValues,
                              xValueMapper: (Weight _weights, _) => _weights.time,
                              yValueMapper: (Weight _weights, _) => _weights.weight,
                              color: Colors.blue,
                              splineType: SplineType.monotonic,
                              markerSettings: MarkerSettings(isVisible: true),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
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
