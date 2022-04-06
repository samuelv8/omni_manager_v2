/// Bar chart example
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class SimpleBarChart extends StatelessWidget {
  final List<charts.Series<dynamic, String>> seriesList;
  final bool? animate;

  SimpleBarChart(this.seriesList, {this.animate});

  /// Creates a [BarChart] with sample data and no transition.
  factory SimpleBarChart.withSampleData() {
    return new SimpleBarChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  factory SimpleBarChart.withUnformattedData(Map<String, double>? rawData) {
    if (rawData != null) {
      return new SimpleBarChart(
        _formatData(rawData),
        animate: false,
      );
    } else return new SimpleBarChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      seriesList,
      animate: animate,
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<OrdinalMetrics, String>> _createSampleData() {
    final data = [
      new OrdinalMetrics('Trabalho Diretoria', 5),
      new OrdinalMetrics('Seu trabalho', 25),
      new OrdinalMetrics('Alocação', 100),
      new OrdinalMetrics('Motivação', 75),
    ];

    return [
      new charts.Series<OrdinalMetrics, String>(
        id: 'Metrics',
        colorFn: (_, __) => charts.MaterialPalette.yellow.shadeDefault,
        domainFn: (OrdinalMetrics metrics, _) => metrics.label,
        measureFn: (OrdinalMetrics metrics, _) => metrics.metric,
        data: data,
      )
    ];
  }

  /// Create one series with List<Map> data
  static List<charts.Series<OrdinalMetrics, String>> _formatData(
      Map<String, double> rawData) {
    final List<OrdinalMetrics> data = [];
    rawData.forEach((key, value) {
      data.add(new OrdinalMetrics(key, value));
    });

    return [
      new charts.Series<OrdinalMetrics, String>(
        id: 'Metrics',
        colorFn: (_, __) => charts.MaterialPalette.yellow.shadeDefault,
        domainFn: (OrdinalMetrics metrics, _) => metrics.label,
        measureFn: (OrdinalMetrics metrics, _) => metrics.metric,
        data: data,
      )
    ];
  }
}

/// Sample ordinal data type.
class OrdinalMetrics {
  final String label;
  final double metric;

  OrdinalMetrics(this.label, this.metric);
}
