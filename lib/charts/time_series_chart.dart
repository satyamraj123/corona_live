import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../providers/data.dart';
import 'package:provider/provider.dart';

class TimeSeriesChart extends StatefulWidget {
  @override
  _TimeSeriesChartState createState() => _TimeSeriesChartState();
}

class _TimeSeriesChartState extends State<TimeSeriesChart> {

  @override
  Widget build(BuildContext context) {
    return Consumer<TimeSeries>(
      builder: (ctx, data, _) =>
      data.isLoading?Center(child: CircularProgressIndicator(),):
      Container(
        margin: EdgeInsets.all(10),
          color: Colors.black,
          alignment: Alignment.center,
          height: 500,
          width: MediaQuery.of(context).size.width,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: data.isLoading?Center(child: CircularProgressIndicator(),): SfCartesianChart(
               borderColor: Color.fromRGBO(50, 50, 50, 1),
               /*  title: ChartTitle(
                    text: 'Cases Over Time:',
                    textStyle: ChartTextStyle(
                        color: Colors.white,
                        fontFamily: 'CM',
                        fontSize: 20,
                        fontWeight: FontWeight.bold)), */
                backgroundColor: Color.fromRGBO(35, 35, 35, 1),
                zoomPanBehavior: ZoomPanBehavior(
                    enablePinching: true),
                    primaryXAxis: CategoryAxis(
                    majorGridLines: MajorGridLines(color: Colors.white),
                  ),

                plotAreaBorderColor: Colors.amber,
                plotAreaBackgroundColor: Color.fromRGBO(100, 100, 100, 1),
                borderWidth: 10,
                tooltipBehavior: TooltipBehavior(enable: true,

                ),
              margin: EdgeInsets.fromLTRB(0, 20, 40, 0),
                palette: <Color>[Colors.amber, Colors.red, Colors.green],
                legend: Legend(isVisible: true,overflowMode: LegendItemOverflowMode.wrap,),
                series: <LineSeries<TimeData, String>>[
                  LineSeries<TimeData, String>(
                    width: 5,
                    enableTooltip: true,
                      name: 'Active cases',
                      dataSource: <TimeData>[...data.activecasesTimeItems],
                      animationDuration: 5000,
                      xValueMapper: (TimeData data, _) => data.date,
                      yValueMapper: (TimeData data, _) => data.cases,
                      ),
                  LineSeries<TimeData, String>(
                    width: 5,
                    enableTooltip: true,
                      name: 'Deceased cases',
                      dataSource: <TimeData>[...data.deceasedcasesTimeItems],
                      animationDuration: 5000,
                      xValueMapper: (TimeData data, _) => data.date,
                      yValueMapper: (TimeData data, _) => data.cases,
                      ),
                  LineSeries<TimeData, String>(
                    width: 5,
                    enableTooltip: true,
                      name: 'Recovered cases',
                      dataSource: <TimeData>[...data.recoveredcasesTimeItems],
                      animationDuration: 5000,
                      xValueMapper: (TimeData data, _) => data.date,
                      yValueMapper: (TimeData data, _) => data.cases,
                      dataLabelSettings: DataLabelSettings(isVisible: false)),
                ]),
          )),
    );
  }
}
