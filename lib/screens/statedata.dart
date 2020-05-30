import 'package:flutter/material.dart';
import '../charts/chart.dart';
import '../widgets/card_item.dart';
import 'package:provider/provider.dart';
import '../providers/data.dart';
import 'districtdata.dart';

class StateData extends StatefulWidget {
  @override
  _StateDataState createState() => _StateDataState();
}

class _StateDataState extends State<StateData> {
  var _isInit = true;
  var _isSearch=false;
  @override
  Future<void> didChangeDependencies() async{
    if (_isInit) {
     await Provider.of<ChartData>(context, listen: false).getChartData();
      await Provider.of<CardData>(context, listen: false).getData(search: '');
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> gotoDistrictWise(String state, String search) async {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => DistrictsData(state)));
    await Provider.of<DistrictData>(context)
        .getDistrictData(state: state, search: '');
    await Provider.of<DistrictChartData>(context)
        .getDistrictChartData(state: state);
    
  }

  String search = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 40,
          ),
      !_isSearch?    Text(
            'Top 5 Affected States',
            style: TextStyle(
                fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
            softWrap: true,
            textAlign: TextAlign.center,
          ):Container(),
       !_isSearch?    Consumer<ChartData>(
              builder: (ctx, data, _) =>data.isLoading?Center(child: CircularProgressIndicator(),):
               Chart(data.chartItems)):Container(),
   SizedBox(height:10),
          const Text(
            'State-wise Data',
            style: TextStyle(
                fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(height:10),
          ListTile(
            trailing: IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {
                FocusScope.of(context).unfocus();
                setState(() {
                  _isSearch=false;
                });
              },
            ),
            title: TextField(
              onTap: (){
                setState(() {
                 _isSearch=true; 
                });
              },
              onSubmitted: (value){

                setState(() {
                 _isSearch=false; 
                });
              },
              cursorColor: Colors.white,
              textAlign: TextAlign.left,
              style: TextStyle(color: Colors.white, fontFamily: 'CM'),
              decoration: InputDecoration(
                fillColor: Colors.white,
                hintText: 'Search State',
                hintStyle: TextStyle(
                  color: Colors.grey,
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  search = value;
                  _isSearch=true;
                  Provider.of<CardData>(context).getData(search: search);
                  
                });
              },
            ),
          ),
          SizedBox(height: 10),
          Consumer<CardData>(
            builder: (ctx, data, _) => data.isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Expanded(
                    child: Scrollbar(
                     
                                          child: ListView.builder(
                          addAutomaticKeepAlives: true,
                          scrollDirection: Axis.vertical,
                          itemCount: data.items.length,
                          itemBuilder: (ctx, i) {
                            return GestureDetector(
                                onTap: () =>
                                    gotoDistrictWise(data.items[i].place, ''),
                                child: CardItem(data.items[i]));
                          }),
                    ),
                  ),
          )
        ],
      ),
    );
  }
}
