import 'dart:io';
import 'package:flutter/services.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

import '../providers/data.dart';
import 'package:provider/provider.dart';
import 'statedata.dart';
import '../charts/time_series_chart.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var isLoading2 = true;
  var isLoading1 = false;
  var _isInit = true;

  @override
  Future<void> didChangeDependencies() async {
    isLoading1 = true;

    if (_isInit) {
      SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);

      await Provider.of<TotalData>(context, listen: true)
          .getTotalData(context, isLoading2);

      await Provider.of<TimeSeries>(context, listen: false)
          .getTimeData(context, isLoading2);
      /* await Future.delayed(Duration(seconds: 1))
          .then((value) => Navigator.of(context).canPop()?Navigator.of(context).pop():null);  */

    }
    isLoading1 = false;

    isLoading2 = false;

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
          onRefresh: () async {
            isLoading1 = true;
            await Future.delayed(Duration(seconds: 2), () {});

            await Provider.of<TotalData>(context, listen: true)
                .getTotalData(context, false);
            await Provider.of<TimeSeries>(context, listen: false)
                .getTimeData(context, false);
            isLoading1 = false;
          },
          child: Scrollbar(
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
                      builder: (ctx, data, _) => data.isLoading || isLoading1
                          ? Center(child: CircularProgressIndicator())
                          : Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      margin: EdgeInsets.all(10),
                                      height: 100,
                                      width: 180,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          Text(
                                            data.items[0].confirmedcases
                                                .toString(),
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
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Color.fromRGBO(50, 50, 50, 1)),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      margin: EdgeInsets.all(10),
                                      height: 100,
                                      width: 180,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
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
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Color.fromRGBO(50, 50, 50, 1)),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      margin: EdgeInsets.all(10),
                                      height: 100,
                                      width: 180,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
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
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Color.fromRGBO(50, 50, 50, 1)),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      margin: EdgeInsets.all(10),
                                      height: 100,
                                      width: 180,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          Text(
                                            data.items[0].deltaconfirmed
                                                .toString(),
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
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Color.fromRGBO(50, 50, 50, 1)),
                                    )
                                  ],
                                )
                              ],
                            ),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'Cases Over Time :',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.info),
                      color: Colors.amber,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text('Interact with Graph!'),
                            content: Text(
                                '1. Click on the yellow trend line to know the number of active cases in particular date.\n2. Similarly for deceased cases and recovered cases.\n3. Pinch for zooming the graph',
                                style: TextStyle(color: Colors.black)),
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
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TimeSeriesChart(),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color.fromRGBO(35, 35, 35, 1),
                    ),
                    child: Card(
                      color: Color.fromRGBO(20, 20, 20, 1),
                      elevation: 5,
                      child: ListTile(
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
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (ctx) => StateData()));
                            }),
                        title: FlatButton(
                          child: Text(
                            'See Statewise &\n Districtwise Data',
                            style: TextStyle(color: Colors.white, fontSize: 25),
                            textAlign: TextAlign.center,
                          ),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) => StateData()));
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  Text(
                    'Follow me on github @satyamraj123',
                    style: TextStyle(
                        fontSize: 20, color: Color.fromRGBO(25, 25, 25, 1)),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
