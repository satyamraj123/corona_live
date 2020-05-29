import 'dart:io';
import 'package:flutter/services.dart';



import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../providers/data.dart';
import 'package:provider/provider.dart';
import 'statedata.dart';
import '../charts/time_series_chart.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _isInit = true;
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(message, style: TextStyle(color: Colors.black)),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Okay',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  @override
  Future<void> didChangeDependencies() async {
    if (_isInit) {
SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);      
      try {
        await Provider.of<TotalData>(context, listen: false).getTotalData();
        await Provider.of<TimeSeries>(context, listen: false)
            .getTimeData();
      } on SocketException catch (e) {
        _showErrorDialog('Check Your Internet Connection');
      }
      Navigator.of(context).pop();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: RefreshIndicator(
          color: Colors.amber,
          backgroundColor: Colors.grey,

          onRefresh: ()async{      
            Future.delayed(Duration(seconds: 4),(){
   
      });
      try {
        await Provider.of<TotalData>(context, listen: false).getTotalData();
        await Provider.of<TimeSeries>(context, listen: false)
            .getTimeData();
      } on SocketException catch (e) {
        _showErrorDialog('Check Your Internet Connection');
      }
  
          },
                  child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 40,
                ),
                Text(
                  'COVID-19 TRACKER',
                  style: TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                
                Container(
                  height: 300,
                  width: MediaQuery.of(context).size.width,
                  child: Consumer<TotalData>(
                    builder: (ctx, data, _) =>
                    data.isLoading?Center(child:CircularProgressIndicator()):
                     Column(
                      
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.all(10),
                              height: 100,
                              width: 180,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Text(
                                    data.items[0].confirmedcases.toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                  'Confirmed',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Color.fromRGBO(50, 50, 50, 1)),
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.all(10),
                              height: 100,
                              width: 180,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Text(
                                    data.items[0].deaths.toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    'Deaths',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Color.fromRGBO(50, 50, 50, 1)),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.all(10),
                              height: 100,
                              width: 180,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Text(
                                    data.items[0].recovered.toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    'Recovered',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Color.fromRGBO(50, 50, 50, 1)),
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.all(10),
                              height: 100,
                              width: 180,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Text(
                                    data.items[0].deltaconfirmed.toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    'Increased Today',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Color.fromRGBO(50, 50, 50, 1)),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Cases Over Time :',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.start,
                    )),
                    SizedBox(height: 10,),
                TimeSeriesChart(),
                SizedBox(height: 20,),
                ListTile(
                  subtitle: Text(
                    'Updated recently',
                    style: TextStyle(color: Colors.green, fontSize: 10),
                    textAlign: TextAlign.center,
                  ),
                  trailing: IconButton(
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (ctx) => StateData()));
                      }),
                  title: FlatButton(
                    child: Text(
                      'Go to statewise and districtwise data',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (ctx) => StateData()));
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
