import '../providers/data.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Chart extends StatefulWidget {
  final List<Data> data;
  Chart(this.data);
  @override
  _ChartState createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 20,
        ),
        Container(
          color: Colors.black,
          margin: EdgeInsets.all(5),
          alignment: Alignment.topCenter,
          height: 250,
          width: MediaQuery.of(context).size.width,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: SfCartesianChart(

                  margin: EdgeInsets.fromLTRB(0, 0, 40, 0),
                  primaryXAxis: CategoryAxis(
                    majorGridLines: MajorGridLines(color: Colors.white),
                  ),
                  plotAreaBorderColor: Colors.amber,
                  borderColor:  Color.fromRGBO(50, 50, 50, 1),
                  
                  plotAreaBackgroundColor: Colors.white,
                  backgroundColor: Color.fromRGBO(30, 30, 30, 1),
                  borderWidth: 10,
                  tooltipBehavior: TooltipBehavior(enable: true),
                  palette: <Color>[
                    Colors.amber
                  ],
                  series: <ChartSeries<Data, String>>[
                    BarSeries<Data, String>(
                        name: 'Active Cases',
                        dataSource: <Data>[...widget.data],
                        animationDuration: 8000,
                        xValueMapper: (Data data, _) => data.place,
                        yValueMapper: (Data data, _) => data.activecases,
                        // Enable data label
                        dataLabelSettings: DataLabelSettings(isVisible: true))
                  ])),
        ),
      ],
    );
  }
}
