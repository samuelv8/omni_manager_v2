import 'dart:collection';
import 'package:intl/intl.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class TimeSeriesLineChart extends StatelessWidget {
  final List<charts.Series<TimeSeriesMetrics, DateTime>> tsSeries;
  final bool animate;

  TimeSeriesLineChart(this.tsSeries, {this.animate = false});

  factory TimeSeriesLineChart.withUnformattedData(
      Map<DateTime, double>? rawData, String name) {
    if (rawData != null) {
      return new TimeSeriesLineChart(_formatData(rawData, name));
    } else
      return new TimeSeriesLineChart(_sampleData());
  }

  factory TimeSeriesLineChart.withUnformattedDataFrame(
      Map<String, Map<DateTime, double>>? df, List<String> columns, List<String>? empNames, Map<String, Map<DateTime, double>>? dfsum) {
    if (df != null && !columns.every((element) => element == columns[0]))
      return new TimeSeriesLineChart(_formatDataFrame(df, columns));
    else if (df != null && columns.every((element) => element == columns[0]))
      // return new TimeSeriesLineChart.withUnformattedData(df[columns[0]], columns[0]);
      return new TimeSeriesLineChart(_formatDataFrame(dfsum!, [columns[0], 'AVG']));
    else
      return new TimeSeriesLineChart(_sampleData());
  }

  static List<charts.Series<TimeSeriesMetrics, DateTime>> _sampleData() {
    final data = [TimeSeriesMetrics(DateTime.now(), 1.0)];
    return [
      new charts.Series<TimeSeriesMetrics, DateTime>(
          data: data,
          id: "Sample Metrics",
          domainFn: (TimeSeriesMetrics metrics, _) => metrics.time,
          measureFn: (TimeSeriesMetrics metrics, _) => metrics.value,)
    ];
  }

  static List<charts.Series<TimeSeriesMetrics, DateTime>> _formatDataFrame(
      Map<String, Map<DateTime, double>> df, List<String> columns) {
    final List<charts.Series<TimeSeriesMetrics, DateTime>> data = [];
    columns.forEach((element) {
      var rawData = df[element]!;
      var sorted = new SplayTreeMap<DateTime, double>.from(
          rawData, (key1, key2) => key1.compareTo(key2));
      final List<TimeSeriesMetrics> timeSeries = [];
      sorted.forEach((key, value) {
        if (!value.isNaN) {
          var date = DateTime(key.year, key.month, key.day);
          timeSeries.add(new TimeSeriesMetrics(date, value));
        }
      });
      data.add(new charts.Series<TimeSeriesMetrics, DateTime>(
        data: timeSeries,
        id: element,
        domainFn: (TimeSeriesMetrics metrics, _) => metrics.time,
        measureFn: (TimeSeriesMetrics metrics, _) => metrics.value,
      ));
    });
    return data;
  }

  static List<charts.Series<TimeSeriesMetrics, DateTime>> _formatData(
      Map<DateTime, double> rawData, String name) {
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
          id: name,
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
      primaryMeasureAxis: charts.NumericAxisSpec(
        tickFormatterSpec: numFormatter,
      ),
      behaviors: [new charts.SeriesLegend(
        entryTextStyle: charts.TextStyleSpec(color: charts.MaterialPalette.black),
      )],
    );
  }
}

class TimeSeriesMetrics {
  final DateTime time;
  final double value;

  TimeSeriesMetrics(this.time, this.value);
}
