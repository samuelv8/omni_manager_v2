/// Simple pie chart with outside labels example.
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class PieOutsideLabelChart extends StatelessWidget {
  final List<charts.Series<LinearMetrics, int>> seriesList;
  final bool? animate;

  PieOutsideLabelChart(this.seriesList, {this.animate});

  /// Creates a [PieChart] with sample data and no transition.
  factory PieOutsideLabelChart.withSampleData() {
    return new PieOutsideLabelChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  factory PieOutsideLabelChart.withUnformattedData(
      Map<String, double>? rawData) {
    if (rawData != null && rawData.isNotEmpty) {
      return new PieOutsideLabelChart(
        _formatData(rawData),
        animate: false,
      );
    } else
      return new PieOutsideLabelChart(
        _createSampleData(),
        // Disable animations for image tests.
        animate: false,
      );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.PieChart<Object>(seriesList,
        animate: animate,
        // Add an [ArcLabelDecorator] configured to render labels outside of the
        // arc with a leader line.
        //
        // Text style for inside / outside can be controlled independently by
        // setting [insideLabelStyleSpec] and [outsideLabelStyleSpec].
        //
        // Example configuring different styles for inside/outside:
        //       new charts.ArcLabelDecorator(
        //          insideLabelStyleSpec: new charts.TextStyleSpec(...),
        //          outsideLabelStyleSpec: new charts.TextStyleSpec(...)),
        defaultRenderer: new charts.ArcRendererConfig(
            arcWidth: 40,
            arcRendererDecorators: [
              new charts.ArcLabelDecorator(
                  labelPosition: charts.ArcLabelPosition.outside)
            ]));
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<LinearMetrics, int>> _createSampleData() {
    final data = [
      new LinearMetrics(0, 1, "A"),
    ];

    return [
      new charts.Series<LinearMetrics, int>(
        id: 'Metrics',
        colorFn: (_, __) => charts.MaterialPalette.yellow.shadeDefault,
        domainFn: (LinearMetrics metrics, _) => metrics.id,
        measureFn: (LinearMetrics metrics, _) => metrics.metric,
        data: data,
      )
    ];
  }

  /// Create one series with List<Map> data
  static List<charts.Series<LinearMetrics, int>> _formatData(
      Map<String, double> rawData) {
    final List<LinearMetrics> data = [];
    rawData.forEach((key, value) {
      data.add(new LinearMetrics(data.length, value, key));
    });
    return [
      new charts.Series<LinearMetrics, int>(
        id: 'Metrics',
        colorFn: (_, __) => charts.MaterialPalette.yellow.shadeDefault,
        domainFn: (LinearMetrics metrics, _) => metrics.id,
        measureFn: (LinearMetrics metrics, _) => metrics.metric,
        data: data,
        labelAccessorFn: (LinearMetrics row, _) => '${row.label}',
      )
    ];
  }
}

/// Sample linear data type.
class LinearMetrics {
  final int id;
  final double metric;
  final String label;

  LinearMetrics(this.id, this.metric, this.label);
}
