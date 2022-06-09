import 'dart:collection';
import 'package:intl/intl.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class TimeSeriesLineChart extends StatelessWidget {
  final List<charts.Series<TimeSeriesMetrics, DateTime>> tsSeries;
  final bool animate;

  TimeSeriesLineChart(this.tsSeries, {this.animate = false});

  factory TimeSeriesLineChart.withUnformattedData(
      Map<DateTime, double>? rawData) {
    if (rawData != null) {
      return new TimeSeriesLineChart(_formatData(rawData));
    } else
      return new TimeSeriesLineChart(_sampleData());
  }

  static List<charts.Series<TimeSeriesMetrics, DateTime>> _sampleData() {
    final data = [TimeSeriesMetrics(DateTime.now(), 1.0)];
    return [
      new charts.Series<TimeSeriesMetrics, DateTime>(
          data: data,
          id: "Sample Metrics",
          domainFn: (TimeSeriesMetrics metrics, _) => metrics.time,
          measureFn: (TimeSeriesMetrics metrics, _) => metrics.value,
          colorFn: (_, __) => charts.MaterialPalette.yellow.shadeDefault)
    ];
  }

  static List<charts.Series<TimeSeriesMetrics, DateTime>> _formatData(
      Map<DateTime, double> rawData) {
    final List<TimeSeriesMetrics> data = [];
    final sorted = new SplayTreeMap<DateTime, double>.from(
        rawData, (key1, key2) => key1.compareTo(key2));
    sorted.forEach((key, value) {
      if (!value.isNaN) {
        var date = DateTime(key.year, key.month, key.day);
        data.add(new TimeSeriesMetrics(date, value));
      }
    });
    return [
      new charts.Series<TimeSeriesMetrics, DateTime>(
          id: 'Metrics',
          data: data,
          domainFn: (TimeSeriesMetrics metrics, _) => metrics.time,
          measureFn: (TimeSeriesMetrics metrics, _) => metrics.value,
          colorFn: (_, __) => charts.MaterialPalette.black)
    ];
  }

  @override
  Widget build(BuildContext context) {
    final numFormatter = charts.BasicNumericTickFormatterSpec.fromNumberFormat(
        NumberFormat.percentPattern());
    return new charts.TimeSeriesChart(
      tsSeries,
      animate: animate,
      defaultRenderer: charts.LineRendererConfig<DateTime>(),
      dateTimeFactory: const charts.LocalDateTimeFactory(),
      primaryMeasureAxis: charts.NumericAxisSpec(tickFormatterSpec: numFormatter, ),
    );
  }
}

class TimeSeriesMetrics {
  final DateTime time;
  final double value;

  TimeSeriesMetrics(this.time, this.value);
}
