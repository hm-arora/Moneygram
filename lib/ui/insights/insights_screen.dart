import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moneygram/core/theme/moneygram_theme.dart';
import 'package:moneygram/ui/base_screen.dart';
import 'package:moneygram/utils/analytics_helper.dart';
import 'package:moneygram/viewmodels/insights_viewmodel.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartSampleData {
  DateTime x;
  double y;
  ChartSampleData({required this.x, required this.y});
}

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  late InsightsViewModel _insightsViewModel;

  @override
  Widget build(BuildContext context) {
    return BaseScreen<InsightsViewModel>(onModelReady: (model) {
      this._insightsViewModel = model;
      this._insightsViewModel.init();
    }, builder: (context, model, child) {
      return _body();
    });
  }

  Scaffold _body() {
    return Scaffold(
        backgroundColor: context.appHomeScreenBgColor,
        appBar: AppBar(
            title: Text(
          "Insights",
          style: TextStyle(
              color: context.appPrimaryColor,
              fontSize: 24,
              fontWeight: FontWeight.w600),
        )),
        body: SafeArea(
            child: Container(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 64),
            child: _content(),
          ),
        )));
  }

  Widget _content() {
    return Container(
        child: SfCartesianChart(
            plotAreaBorderWidth: 0,
            primaryXAxis: DateTimeAxis(
              dateFormat: DateFormat.MMMd(),
              majorGridLines: MajorGridLines(width: 0),
              //Hide the axis line of x-axis
            ),
            primaryYAxis: NumericAxis(majorGridLines: MajorGridLines(width: 0)),
            series: <ChartSeries<ChartSampleData, DateTime>>[
          ColumnSeries<ChartSampleData, DateTime>(
              dataSource: _insightsViewModel.chartData,
              xValueMapper: (ChartSampleData data, _) => data.x,
              yValueMapper: (ChartSampleData data, _) => data.y,
              name: 'Gold',
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4), topRight: Radius.circular(4)),
              color: context.appPrimaryColor)
        ]));
  }

  Widget _timeRangeWidget() {
    var leftArrow = InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        AnalyticsHelper.logEvent(
            event: AnalyticsHelper.homePagePreviousTimelineClicked);
        _insightsViewModel.previousDate();
      },
      child: Container(
          height: 36,
          width: 36,
          alignment: Alignment.center,
          child: Icon(Icons.arrow_back,
              color: context.appPrimaryColor.withOpacity(0.5)),
          decoration: BoxDecoration(
              color: context.appBgColor,
              borderRadius: BorderRadius.circular(18))),
    );
    var rightArrow = InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        AnalyticsHelper.logEvent(
            event: AnalyticsHelper.homePageNextTimelineClicked);
        _insightsViewModel.nextDate();
      },
      child: Container(
          height: 36,
          width: 36,
          alignment: Alignment.center,
          child: Icon(Icons.arrow_forward,
              color: context.appPrimaryColor.withOpacity(0.5)),
          decoration: BoxDecoration(
              color: context.appBgColor,
              borderRadius: BorderRadius.circular(18))),
    );
    var rangeWidget = Text(
        "${_insightsViewModel.timeline.decoratedStartTime} - ${_insightsViewModel.timeline.decoratedEndTime}");
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [leftArrow, rangeWidget, rightArrow]));
  }
}
