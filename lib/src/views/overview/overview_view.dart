import "dart:math";

import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_expandable_fab/flutter_expandable_fab.dart";
import "package:intl/intl.dart";
import "package:percent_indicator/circular_percent_indicator.dart";
import "package:provider/provider.dart";
import "package:snacktrack/src/models/weight.dart";
import "package:snacktrack/src/viewmodels/interfaces/i_navigation_viewmodel.dart";
import "package:snacktrack/src/viewmodels/interfaces/i_overview_viewmodel.dart";
import "package:snacktrack/src/views/overview/energy_form.dart";
import "package:snacktrack/src/views/overview/target_energy_form.dart";
import "package:syncfusion_flutter_charts/charts.dart";

class OverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        type: ExpandableFabType.up,
        children: [
          Row(
            children: [
              const Text("Add weight"),
              const SizedBox(width: 20),
              FloatingActionButton.small(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EnergyForm(),
                    ),
                  );
                },
                child: const Icon(Icons.scale),
              )
            ],
          ),
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
                return Consumer<INavigationViewModel>(
                  builder: (context, navModel, child) {
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
                          percent:
                              overviewModel.energyCurrentTotalClamped <= 0.005
                                  ? 0.005
                                  : overviewModel.energyCurrentTotalClamped,
                          backgroundColor:
                              const Color.fromARGB(94, 148, 197, 214),
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
                              const Text(
                                "Kilojoules", // TODO: Get string from settings
                                style: TextStyle(
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
                          Text('${model.targetEnergy} kJ'),
                          const Text("Energy goal")
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Column(
                        children: [
                          Text('${model.targetWeight} KG'),
                          const Text("Weight goal")
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
                        intervalType: DateTimeIntervalType.days,
                        interval: 1,
                        // Add some visual padding to the last week of data
                        minimum: DateTime(DateTime.now().year,
                                DateTime.now().month, DateTime.now().day)
                            .add(const Duration(days: -6, hours: -12)),
                        maximum: DateTime(DateTime.now().year,
                                DateTime.now().month, DateTime.now().day)
                            .add(const Duration(hours: 12)),
                        axisLabelFormatter: (axisLabelRenderArgs) {
                          var text = DateFormat("EEE").format(
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
                                '${model.targetWeight} ${model.weightUnit.name}',
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
                        format: "point.y ${describeEnum(model.weightUnit)}",
                      ),
                      series: <CartesianSeries>[
                        SplineSeries<Weight, DateTime>(
                          dataSource: model.recentWeights,
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
}
