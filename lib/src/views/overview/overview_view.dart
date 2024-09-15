import "dart:math";

import "package:flutter/material.dart";
import "package:flutter_expandable_fab/flutter_expandable_fab.dart";
import "package:intl/intl.dart";
import "package:percent_indicator/circular_percent_indicator.dart";
import "package:provider/provider.dart";
import "package:snacktrack/src/models/weight.dart";
import "package:snacktrack/src/viewmodels/interfaces/i_overview_viewmodel.dart";
import "package:snacktrack/src/viewmodels/interfaces/i_settings_viewmodel.dart";
import "package:snacktrack/src/views/overview/energy_form.dart";
import "package:snacktrack/src/views/overview/target_energy_form.dart";
import "package:snacktrack/src/views/overview/weight_form.dart";
import "package:syncfusion_flutter_charts/charts.dart";

class OverviewScreen extends StatelessWidget {
  OverviewScreen({super.key});

  final _fabKey = GlobalKey<ExpandableFabState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        key: _fabKey,
        type: ExpandableFabType.up,
        childrenAnimation: ExpandableFabAnimation.none,
        overlayStyle: ExpandableFabOverlayStyle(
          color: Colors.white.withOpacity(0.85),
        ),
        openButtonBuilder: DefaultFloatingActionButtonBuilder(
          child: const Icon(Icons.add),
        ),
        distance: 80,
        children: [
          Row(
            children: [
              const Text("Record Weight"),
              const SizedBox(width: 16),
              FloatingActionButton.small(
                heroTag: null,
                onPressed: () {
                  closeFabMenu();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WeightForm(),
                    ),
                  );
                },
                child: const Icon(Icons.scale_rounded),
              )
            ],
          ),
          Row(
            children: [
              Text(
                'Record ${context.watch<ISettingsViewmodel>().energyUnit.longName}',
              ),
              const SizedBox(width: 16),
              FloatingActionButton.small(
                heroTag: null,
                onPressed: () {
                  closeFabMenu();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EnergyForm(),
                    ),
                  );
                },
                child: const Icon(Icons.restaurant_rounded),
              ),
            ],
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 24,
            ),
            Consumer<IOverviewViewModel>(
              builder: (context, overviewModel, child) {
                return Ink(
                  width: 260,
                  height: 260,
                  child: InkWell(
                    onTap: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TargetEnergyForm()),
                      ),
                    },
                    borderRadius: BorderRadius.circular(400),
                    radius: 300,
                    child: CircularPercentIndicator(
                      radius: 100.0,
                      lineWidth: 12.0,
                      percent: overviewModel.energyCurrentTotalClamped <= 0.005
                          ? 0.005
                          : overviewModel.energyCurrentTotalClamped,
                      backgroundColor: const Color.fromARGB(94, 148, 197, 214),
                      progressColor: overviewModel.currentEnergyTotal >
                              overviewModel.targetEnergy
                          ? Colors.red
                          : const Color.fromRGBO(70, 100, 159, 1),
                      animation: true,
                      animateFromLastPercent: true,
                      circularStrokeCap: CircularStrokeCap.round,
                      center: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(overviewModel.currentEnergyTotal.toString(),
                              style: const TextStyle(
                                fontSize: 44,
                                fontWeight: FontWeight.w700,
                                height: 1.1,
                                color: Color.fromRGBO(70, 100, 159, 1),
                              )),
                          Text(
                            overviewModel.energyUnit.longName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              height: 1.1,
                              color: Color.fromRGBO(70, 100, 159, 1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            Center(child: Consumer<IOverviewViewModel>(
              builder: (context, model, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Column(
                        children: [
                          Text(
                            '${model.targetEnergy}',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Text(
                            'Target ${model.energyUnit.shortName}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    TextButton(
                      onPressed: () {},
                      child: Column(
                        children: [
                          Text(
                            '${model.targetWeight}',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Text(
                            'Target ${model.weightUnit.shortName}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            )),
            const SizedBox(
              height: 12,
            ),
            Card(
              elevation: 1.0,
              // TODO: Get from theme
              color: Colors.grey[25],
              margin:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Container(
                height: 200,
                padding: const EdgeInsets.fromLTRB(8.0, 8.0, 12.0, 8.0),
                child: Consumer<IOverviewViewModel>(
                  builder: (context, model, child) {
                    return SfCartesianChart(
                      primaryXAxis: DateTimeAxis(
                        majorGridLines: const MajorGridLines(width: 0),
                        intervalType: DateTimeIntervalType.months,
                        interval: 1,
                        minimum: model.minChartDate,
                        maximum: model.maxChartDate,
                        axisLabelFormatter: (axisLabelRenderArgs) {
                          var text = DateFormat("MMM").format(
                              DateTime.fromMillisecondsSinceEpoch(
                                  axisLabelRenderArgs.value.toInt()));
                          return ChartAxisLabel(text, null);
                        },
                      ),
                      primaryYAxis: NumericAxis(
                        isVisible: true,
                        maximum: max(
                                model.targetWeight,
                                model.maximumRecentWeight ??
                                    model.targetWeight) +
                            2,
                        majorGridLines:
                            const MajorGridLines(color: Colors.transparent),
                        majorTickLines:
                            const MajorTickLines(color: Colors.transparent),
                        labelPosition: ChartDataLabelPosition.inside,
                        labelStyle: const TextStyle(color: Colors.transparent),
                        plotBands: [
                          PlotBand(
                            start: model.targetWeight,
                            end: model.targetWeight,
                            shouldRenderAboveSeries: true,
                            dashArray: const [6, 16],
                            borderColor: Colors.blue,
                            opacity: 0.5,
                            text:
                                '${model.targetWeight} ${model.weightUnit.shortName}',
                            verticalTextAlignment:
                                model.maximumRecentWeight != null &&
                                        model.targetWeight >
                                            model.maximumRecentWeight! + 1
                                    ? TextAnchor.start
                                    : TextAnchor.end,
                            verticalTextPadding:
                                model.maximumRecentWeight != null &&
                                        model.targetWeight >
                                            model.maximumRecentWeight! + 1
                                    ? "-4px"
                                    : "8px",
                            horizontalTextAlignment: TextAnchor.start,
                            horizontalTextPadding: "8px",
                          ),
                        ],
                        //minorTicksPerInterval: 1,
                      ),
                      // Both 2nd digit of min and max (ie min 40<-, max 80<-) need to be 5 or 0 if setting manually, can't be different
                      tooltipBehavior: TooltipBehavior(
                        enable: true,
                        header: "",
                        canShowMarker: false,
                        animationDuration: 0,
                        elevation: 0,
                        format: "point.y ${model.weightUnit.shortName}",
                      ),
                      series: <CartesianSeries>[
                        SplineSeries<Weight, DateTime>(
                          dataSource: model.recentDailyWeights,
                          xValueMapper: (Weight weights, _) => weights.time,
                          yValueMapper: (Weight weights, _) => weights.weight,
                          emptyPointSettings: const EmptyPointSettings(
                            mode: EmptyPointMode.average,
                          ),
                          color: Colors.blue,
                          splineType: SplineType.monotonic,
                          markerSettings: const MarkerSettings(
                            isVisible: true,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void closeFabMenu() {
    if (_fabKey.currentState != null && _fabKey.currentState!.isOpen) {
      _fabKey.currentState!.toggle();
    }
  }
}
