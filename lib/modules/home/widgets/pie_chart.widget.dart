import 'package:flutter/material.dart';
import 'package:gadeer/helper/app.theme.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PieChartWidget extends StatelessWidget {
  const PieChartWidget({
    Key? key,
    required this.chartPoints,
  }) : super(key: key);

  final List<ChartXPoint> chartPoints;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: SfCircularChart(
          margin: EdgeInsets.symmetric(vertical: 2),
          enableMultiSelection: true,
          legend: Legend(
              padding: 8,
              textStyle: TextStyles.subTitle
                  .copyWith(fontFamily: GoogleFonts.tajawal().fontFamily),
              isVisible: true,
              alignment: ChartAlignment.center,
              overflowMode: LegendItemOverflowMode.scroll),
          series: <CircularSeries>[
            PieSeries<ChartXPoint, String>(
                dataSource: chartPoints,
                explode: true,
                dataLabelSettings: DataLabelSettings(isVisible: true),
                pointColorMapper: (ChartXPoint point, _) => point.color,
                xValueMapper: (ChartXPoint point, _) => point.label.tr,
                yValueMapper: (ChartXPoint point, _) => point.value),
          ]),
    );
  }
}

class ChartXPoint {
  String label;
  int? value;
  Color color;
  ChartXPoint(this.label, this.value, this.color);
}
