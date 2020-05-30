import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

class Data {
  final String place;
  final int activecases;
  final int confirmedcases;
  final int deaths;
  final int deltaconfirmed;
  final int deltadeaths;
  final int deltarecovered;
  final int recovered;
  final String lastupdatedtime;

  Data(
      {@required this.activecases,
      this.confirmedcases,
      this.deaths,
      this.deltaconfirmed,
      this.deltadeaths,
      this.deltarecovered,
      this.lastupdatedtime,
      this.recovered,
      @required this.place});
}

class TotalData with ChangeNotifier {
  List<Data> _items = [];
  List<Data> get items {
    return [..._items];
  }

  var isLoading = false;

  Future<void> getTotalData(BuildContext context,bool isLoading2) async {
  
    void _showErrorDialog(String message1,String message2) {
         if(isLoading2){
 Navigator.of(context).canPop()? Navigator.of(context).pop():null;
      } 
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(message2),
        content: Text(message1, style: TextStyle(color: Colors.black)),
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
    var data;
    isLoading = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try{
      isLoading2&&Navigator.of(context).canPop()?Navigator.of(context).pop():null;
    final response = await http.get('https://api.covid19india.org/data.json');
    
     data = json.decode(response.body);
    prefs.setString("lastLoadedData", json.encode(data));
    prefs.setString("lastLoadedDate","${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}");
    data=json.decode(prefs.getString("lastLoadedData"));
  
    }on SocketException{
if (prefs.containsKey("lastLoadedDate")){
print(prefs.getString('lastLoadedDate'));
data=json.decode(prefs.getString("lastLoadedData"));
_showErrorDialog('Check Your Internet Connection\n' +
              'showing results from - ' +
              prefs.getString('lastLoadedDate'),'Loaded Old Data');
              
}
else{
print('no internet');
_showErrorDialog('Unable to Load Data, check your internet connection','An Error Occured!');
//alertdialog
}
    }
   if(data==null){
     isLoading=true;
     return;
   }
        
    final List<Data> loadedData = [];

    data['statewise'].forEach((element) {
      if (data['statewise'].indexOf(element) == 0)
        loadedData.add(Data(
          activecases: int.parse(element['active']),
          place: element['state'],
          deltaconfirmed: int.parse(element['deltaconfirmed']),
          confirmedcases: int.parse(element['confirmed']),
          deaths: int.parse(element['deaths']),
          deltadeaths: int.parse(element['deltadeaths']),
          recovered: int.parse(element['recovered']),
          deltarecovered: int.parse(element['deltarecovered']),
          lastupdatedtime: element['lastupdatedtime'],
        ));
    });

    _items = loadedData;
    isLoading = false;
    notifyListeners();
  }
}

class DistrictData with ChangeNotifier {
  var isLoading = false;
  List<Data> _items = [];
  List<Data> get items {
    return [..._items];
  }

  Future<void> getDistrictData({String state, String search}) async {
    isLoading = true;
    var data;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try{
    final response = await http
        .get('https://api.covid19india.org/v2/state_district_wise.json');
     data = json.decode(response.body);
     prefs.setString("lastDistrictData", json.encode(data));
    prefs.setString("lastLoadedDate","${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}");
    data=json.decode(prefs.getString("lastDistrictData"));
    }on SocketException{
if (prefs.containsKey("lastLoadedDate")){
print(prefs.getString('lastLoadedDate'));
data=json.decode(prefs.getString("lastDistrictData"));
}
else{
print('no internet');
//alertdialog
}
    }

    final List<Data> loadedData = [];

    data.forEach((element) {
      if (element['state'] == state)
        element['districtData'].forEach((e) {
          if (e['district'].toString().trim().toLowerCase().contains(search))
            loadedData.add(Data(
              confirmedcases: e['confirmed'],
              place: e['district'],
              activecases: e['active'],
              deaths: e['deceased'],
              deltaconfirmed: e['delta']['confirmed'],
              deltadeaths: e['delta']['deceased'],
              deltarecovered: e['delta']['recovered'],
              recovered: e['recovered'],
            ));

          _items = loadedData;
          isLoading = false;
          notifyListeners();
        });
    });
  }
}

class DistrictChartData with ChangeNotifier {
  var isLoading = false;
  List<Data> _chartItems = [];
  List<Data> get chartItems {
    return [..._chartItems];
  }

  Future<void> getDistrictChartData({String state}) async {
        isLoading = true;
    var data;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try{
    final response = await http
        .get('https://api.covid19india.org/v2/state_district_wise.json');
     data = json.decode(response.body);
     prefs.setString("lastDistrictData", json.encode(data));
    prefs.setString("lastLoadedDate","${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}");
    data=json.decode(prefs.getString("lastDistrictData"));
    }on SocketException{
if (prefs.containsKey("lastLoadedDate")){
print(prefs.getString('lastLoadedDate'));
data=json.decode(prefs.getString("lastDistrictData"));
}
else{
print('no internet');
//alertdialog
}
    }

    final List<Data> loadedData = [];

    data.forEach((element) {
      List<int> _top5 = [0, 0, 0, 0, 0];
      if (element['state'] == state)
        element['districtData'].forEach((e) {
          if (e['active'] >= _top5[0] &&
              e['active'] >= _top5[1] &&
              e['active'] >= _top5[2] &&
              e['active'] >= _top5[3] &&
              e['active'] >= _top5[4]) {
            _top5[4] = _top5[3];
            _top5[3] = _top5[2];
            _top5[2] = _top5[1];
            _top5[1] = _top5[0];
            _top5[0] = e['active'];
          }

          if (e['active'] < _top5[0] &&
              e['active'] >= _top5[1] &&
              e['active'] >= _top5[2] &&
              e['active'] >= _top5[3] &&
              e['active'] >= _top5[4]) {
            _top5[4] = _top5[3];
            _top5[3] = _top5[2];
            _top5[2] = _top5[1];

            _top5[1] = e['active'];
          }

          if (e['active'] < _top5[0] &&
              e['active'] < _top5[1] &&
              e['active'] >= _top5[2] &&
              e['active'] >= _top5[3] &&
              e['active'] >= _top5[4]) {
            _top5[4] = _top5[3];
            _top5[3] = _top5[2];

            _top5[2] = e['active'];
          }

          if (e['active'] < _top5[0] &&
              e['active'] < _top5[1] &&
              e['active'] < _top5[2] &&
              e['active'] >= _top5[3] &&
              e['active'] >= _top5[4]) {
            _top5[4] = _top5[3];

            _top5[3] = e['active'];
          }

          if (e['active'] < _top5[0] &&
              e['active'] < _top5[1] &&
              e['active'] < _top5[2] &&
              e['active'] < _top5[3] &&
              e['active'] >= _top5[4]) {
            _top5[4] = e['active'];
          }
        });
      _top5.sort();
      if (element['state'] == state)
        element['districtData'].forEach((i) {
          if (_top5.contains(i['active']) && loadedData.length <= 5) {
            loadedData.add(Data(
              place: i['district'],
              activecases: i['active'],
            ));
          }
        });

      _chartItems = loadedData;
      isLoading = false;
      notifyListeners();
    });
  }
}

class TimeData {
  final String date;
  final int cases;
  TimeData({this.date, this.cases});
}

class TimeSeries with ChangeNotifier {
  var isLoading = false;
  List<TimeData> _activecasesTimeItems = [];
  List<TimeData> get activecasesTimeItems {
    return [..._activecasesTimeItems];
  }

  List<TimeData> _confirmedcasesTimeItems = [];
  List<TimeData> get confirmedcasesTimeItems {
    return [..._confirmedcasesTimeItems];
  }

  List<TimeData> _deceasedcasesTimeItems = [];
  List<TimeData> get deceasedcasesTimeItems {
    return [..._deceasedcasesTimeItems];
  }

  List<TimeData> _recoveredcasesTimeItems = [];
  List<TimeData> get recoveredcasesTimeItems {
    return [..._recoveredcasesTimeItems];
  }

  Future<void> getTimeData(BuildContext context, bool isLoading2) async {
     var data;
    isLoading = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try{
  final response = await http.get('https://api.covid19india.org/data.json');
    data = json.decode(response.body);
   prefs.setString("lastLoadedData", json.encode(data));
    prefs.setString("lastLoadedDate","${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}");
    data=json.decode(prefs.getString("lastLoadedData"));
    
    }on SocketException{
if (prefs.containsKey("lastLoadedDate")){
print(prefs.getString('lastLoadedDate'));
data=json.decode(prefs.getString("lastLoadedData"));
}
else{
print('no internet');
//alertdialog
}
    }
  
    List<TimeData> loadedData = [];

    data['cases_time_series'].forEach((element) {
      if (data['cases_time_series'].indexOf(element) > 51)
        loadedData.add(TimeData(
          cases: int.parse(element['totalconfirmed']),
          date: element['date'].toString().trim(),
        ));
    });
    _confirmedcasesTimeItems = loadedData;
    loadedData = [];
    data['cases_time_series'].forEach((element) {
      if (data['cases_time_series'].indexOf(element) > 51)
        loadedData.add(TimeData(
          cases: int.parse(element['totaldeceased']),
          date: element['date'].toString().trim(),
        ));
    });
    _deceasedcasesTimeItems = loadedData;
    loadedData = [];
    data['cases_time_series'].forEach((element) {
      if (data['cases_time_series'].indexOf(element) > 51)
        loadedData.add(TimeData(
          cases: int.parse(element['totalrecovered']),
          date: element['date'].toString().trim(),
        ));
    });
    _recoveredcasesTimeItems = loadedData;
    loadedData = [];

    data['cases_time_series'].forEach((element) {
      if (data['cases_time_series'].indexOf(element) > 51)
        loadedData.add(TimeData(
          cases: int.parse(element['totalconfirmed']) -
              int.parse(element['totaldeceased']) -
              int.parse(element['totalrecovered']),
          date: element['date'].toString().trim(),
        ));
    });
    _activecasesTimeItems = loadedData;

    isLoading = false;
    notifyListeners();
    
  }
}

class CardData with ChangeNotifier {
  var isLoading = false;
  List<Data> _items = [];
  List<Data> get items {
    return [..._items];
  }

  Future<void> getData({String search}) async {
    var data;
    isLoading = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try{
    final response = await http.get('https://api.covid19india.org/data.json');
    data = json.decode(response.body);
    prefs.setString("lastLoadedData", json.encode(data));
    prefs.setString("lastLoadedDate","${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}");
    data=json.decode(prefs.getString("lastLoadedData"));
    }on SocketException{
if (prefs.containsKey("lastLoadedDate")){
print(prefs.getString('lastLoadedDate'));
data=json.decode(prefs.getString("lastLoadedData"));
}
else{
print('no internet');
//alertdialog
}
    }
   
    final List<Data> loadedData = [];

    data['statewise'].forEach((element) {
      if (search != '') {
        if (data['statewise'].indexOf(element) > 0 &&
            element['state'].toString().toLowerCase().contains(search))
          loadedData.add(
            Data(
                activecases: int.parse(element['active']),
                place: element['state'],
                deltaconfirmed: int.parse(element['deltaconfirmed']),
                confirmedcases: int.parse(element['confirmed']),
                deaths: int.parse(element['deaths']),
                deltadeaths: int.parse(element['deltadeaths']),
                recovered: int.parse(element['recovered']),
                deltarecovered: int.parse(element['deltarecovered']),
                lastupdatedtime: element['lastupdatedtime']),
          );
      } else {
        if (data['statewise'].indexOf(element) > 0)
          loadedData.add(
            Data(
                activecases: int.parse(element['active']),
                place: element['state'],
                deltaconfirmed: int.parse(element['deltaconfirmed']),
                confirmedcases: int.parse(element['confirmed']),
                deaths: int.parse(element['deaths']),
                deltadeaths: int.parse(element['deltadeaths']),
                recovered: int.parse(element['recovered']),
                deltarecovered: int.parse(element['deltarecovered']),
                lastupdatedtime: element['lastupdatedtime']),
          );
      }
    });

    _items = loadedData;
    isLoading = false;
    notifyListeners();
  }
}

class ChartData with ChangeNotifier {
  var isLoading = false;
  List<Data> _chartItems = [];

  List<Data> get chartItems {
    return [..._chartItems];
  }

  Future<void> getChartData() async {
    var data;
    isLoading = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try{
    final response = await http.get('https://api.covid19india.org/data.json');
    data = json.decode(response.body);
    prefs.setString("lastLoadedData", json.encode(data));
    prefs.setString("lastLoadedDate","${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}");
    data=json.decode(prefs.getString("lastLoadedData"));
    }on SocketException{
if (prefs.containsKey("lastLoadedDate")){
print(prefs.getString('lastLoadedDate'));
data=json.decode(prefs.getString("lastLoadedData"));
}
else{
print('no internet');
//alertdialog
}
    }
    final List<Data> loadedData = [];

    data['statewise'].forEach((element) {
      if (data['statewise'].indexOf(element) <= 5 &&
          data['statewise'].indexOf(element) > 0)
        loadedData.add(Data(
            activecases: int.parse(element['active']),
            place: element['state']));
    });
    _chartItems = loadedData.reversed.toList();
    isLoading = false;
    notifyListeners();
  }
}
