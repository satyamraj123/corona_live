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
  var districtsearch;
  var statesearch;
  String userDistrict = '';
  SharedPreferences prefs;
  @override
  Future<void> didChangeDependencies() async {
    isLoading1 = true;

    if (_isInit) {
      SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
      prefs = await SharedPreferences.getInstance();
      await Provider.of<TotalData>(context, listen: true)
          .getTotalData(context, isLoading2);
      prefs.containsKey('userDistrict')
          ? await Provider.of<DistrictData>(context, listen: false)
              .getDistrictData(
                  context: context,
                  search: prefs.getString('userDistrict'),
                  state: prefs.getString('userState'))
          : null;

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
    if (prefs != null) {
      if (prefs.containsKey('userDistrict'))
        userDistrict = prefs.getString('userDistrict');
    }
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
            prefs.containsKey('userDistrict')
                ? await Provider.of<DistrictData>(context, listen: false)
                    .getDistrictData(
                        context: context,
                        search: prefs.getString('userDistrict'),
                        state: prefs.getString('userState'))
                : null;
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
                  Text(
                    'Cases In India:',
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  Container(
                    height: 280,
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
                  Text(
                    prefs == null || !prefs.containsKey('userDistrict')
                        ? 'Enter Your Loaction Details:'
                        : "Cases In $userDistrict :",
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    prefs == null || !prefs.containsKey('userDistrict')
                        ? '(Please enter spellings carefully)'
                        : "",
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  prefs != null && prefs.containsKey('userDistrict')
                      ? RaisedButton(
                          color: Colors.amber,
                          child: Text(
                            "CHANGE LOCATION?",
                            style: TextStyle(color: Colors.black),
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: Text("Are You Sure ?"),
                                content: Text(
                                    'Your Location Details will be deleted.',
                                    style: TextStyle(color: Colors.black)),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    onPressed: () {
                                      Navigator.of(ctx).pop();
                                    },
                                  ),
                                  FlatButton(
                                    child: Text(
                                      'Okay',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    onPressed: () {
                                      Navigator.of(ctx).pop();
                                      setState(() {
                                        prefs.remove('userDistrict');
                                        prefs.remove("userState");
                                      });
                                    },
                                  )
                                ],
                              ),
                            );
                          },
                        )
                      : Container(),
                  Container(
                    height: 281,
                    width: MediaQuery.of(context).size.width,
                    child: Consumer<DistrictData>(
                      builder: (ctx, data, _) => data.isLoading || isLoading1
                          ? Center(child: CircularProgressIndicator())
                          : Column(
                              children: <Widget>[
                                prefs.containsKey('userState')
                                    ? Container()
                                    : Column(
                                        children: <Widget>[
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Container(
                                            height: 80,
                                            width: 300,
                                            child: TextField(
                                              onChanged: (value) {
                                                setState(() {
                                                  statesearch = value;

                                                  //   _isSearch=true;
                                                });
                                              },
                                              cursorColor: Colors.white,
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'CM'),
                                              decoration: InputDecoration(
                                                fillColor: Colors.white,
                                                hintText: 'Enter Your State',
                                                hintStyle: TextStyle(
                                                  color: Colors.grey,
                                                ),
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 10.0,
                                                        horizontal: 20.0),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              32.0)),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.white,
                                                      width: 1.0),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              32.0)),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.white,
                                                      width: 2.0),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              32.0)),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: 80,
                                            width: 300,
                                            child: TextField(
                                              onChanged: (value) {
                                                setState(() {
                                                  districtsearch = value;
                                                });
                                              },
                                              cursorColor: Colors.white,
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'CM'),
                                              decoration: InputDecoration(
                                                fillColor: Colors.white,
                                                hintText: 'Enter Your District',
                                                hintStyle: TextStyle(
                                                  color: Colors.grey,
                                                ),
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 10.0,
                                                        horizontal: 20.0),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              32.0)),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.white,
                                                      width: 1.0),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              32.0)),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.white,
                                                      width: 2.0),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              32.0)),
                                                ),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              FocusScope.of(context).unfocus();

                                              prefs.setString(
                                                  'userState', statesearch);
                                              prefs.setString('userDistrict',
                                                  districtsearch);
                                              await Provider.of<DistrictData>(
                                                      context,
                                                      listen: false)
                                                  .getDistrictData(
                                                      context: context,
                                                      search: districtsearch,
                                                      state: statesearch);
                                            },
                                            child: Container(
                                              height: 40,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: Colors.amber,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  'Done',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                SizedBox(height: 20),
                                /* IconButton(
                                            icon: Icon(
                                              Icons.check_circle_outline,
                                              color: Colors.white,
                                            ),
                                            onPressed: () async {
                                              FocusScope.of(context).unfocus();
                                              setState(() async {
                                                prefs.setString(
                                                    'userState', statesearch);
                                              });
                                            },
                                          ), */

                                data.items.isEmpty == false &&
                                        isLoading1 == false &&
                                        data.isLoading == false &&
                                        (prefs != null &&
                                            prefs.containsKey('userDistrict'))
                                    ? Column(
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
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: <Widget>[
                                                    Text(
                                                      data.items[0]
                                                          .confirmedcases
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 25,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    Text(
                                                      'Confirmed',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ],
                                                ),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    color: Color.fromRGBO(
                                                        50, 50, 50, 1)),
                                              ),
                                              Container(
                                                padding: EdgeInsets.all(10),
                                                margin: EdgeInsets.all(10),
                                                height: 100,
                                                width: 180,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: <Widget>[
                                                    Text(
                                                      data.items[0].deaths
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 25,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    Text(
                                                      'Deaths',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ],
                                                ),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    color: Color.fromRGBO(
                                                        50, 50, 50, 1)),
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
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: <Widget>[
                                                    Text(
                                                      data.items[0].recovered
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 25,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    Text(
                                                      'Recovered',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ],
                                                ),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    color: Color.fromRGBO(
                                                        50, 50, 50, 1)),
                                              ),
                                              Container(
                                                padding: EdgeInsets.all(10),
                                                margin: EdgeInsets.all(10),
                                                height: 100,
                                                width: 180,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: <Widget>[
                                                    Text(
                                                      data.items[0]
                                                          .deltaconfirmed
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 25,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    Text(
                                                      'Increased Today',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 17,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ],
                                                ),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    color: Color.fromRGBO(
                                                        50, 50, 50, 1)),
                                              )
                                            ],
                                          )
                                        ],
                                      )
                                    : Container(),
                                data.items.isEmpty &&
                                        prefs.containsKey('userDistrict') &&
                                        data.isLoading == false
                                    ? Container(
                                      padding: EdgeInsets.all(15),

                                        child: Center(
                                            child: Text(
                                                'You might have entered wrong Location Details.\nPlease check spellings of state and district you have enetered.\nClick on CHANGE LOCATION button above.',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 17))),
                                      )
                                    : Container()
                                /*  Container(
                                       color: Colors.grey,
                                       child: ClipRRect(
                                         
                                         borderRadius: BorderRadius.circular(20),
                                       child: Text('Done',style: TextStyle(color: Colors.amber),),),
                                     ) */
                              ],
                            ),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'Cases Over Time In India:',
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
                        fontSize: 15, color: Color.fromRGBO(70, 70, 70, 1)),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
