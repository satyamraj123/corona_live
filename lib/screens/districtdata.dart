import 'package:flutter/material.dart';
import '../charts/chart.dart';
import '../widgets/card_item.dart';
import '../providers/data.dart';
import 'package:provider/provider.dart';

class DistrictsData extends StatefulWidget {
final String state;
DistrictsData(this.state);
  @override
  _DistrictsDataState createState() => _DistrictsDataState();
}

class _DistrictsDataState extends State<DistrictsData> {
  var _isSearch=false;
  var search='';
 /*   var _isInit = true;
 @override
  void didChangeDependencies() {
    if (_isInit) {
 
    
      
    }
    _isInit = false;
    super.didChangeDependencies();
  } */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          SizedBox(height: 40,),
        _isSearch?Container()  :Text(
          'Top 5 Affected Districts',
          style: TextStyle(
              fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
          softWrap: true,
          textAlign: TextAlign.center,
        ),
             _isSearch?Container()  :Consumer<DistrictChartData>(builder:(ctx,data,_)=> data.isLoading?Center(child: CircularProgressIndicator(),):
             Chart(data.chartItems)),
SizedBox(height:20),
           Text(
            'District-wise Data',
            style: TextStyle(
                fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
              textAlign: TextAlign.center,
          ),
          Text(widget.state,style:TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.amber),
              textAlign: TextAlign.center,),
          SizedBox(height:20),
          ListTile(
            trailing: IconButton(icon: Icon(Icons.search,color: Colors.white,),onPressed: (){
              FocusScope.of(context).unfocus();
            },),
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
              style: TextStyle(color: Colors.white,fontFamily: 'CM'),
               decoration: InputDecoration(
                      fillColor: Colors.white,
                      hintText: 'Search District',
                      
                      hintStyle: TextStyle(color: Colors.grey,),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.white, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.white, width: 2.0),
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                      ),
                    ),
              
              onChanged: (value) {
                setState(() {
                  search = value;   
                  _isSearch=true;
                  Provider.of<DistrictData>(context).getDistrictData(search: search,state: widget.state);
                  
                });
     
              },
            ),
          ), 
          SizedBox(height: 5),
          //Text('Scroll Down',textAlign: TextAlign.center,style: TextStyle(fontSize: 20,color: Color.fromRGBO(30, 30, 30, 1)),),
          Consumer<DistrictData>(
                  builder:(ctx,data,_)=>
                  data.isLoading?Center(child: CircularProgressIndicator(),):
                   Expanded(
              child: Scrollbar(
                              child: ListView.builder(
                    addAutomaticKeepAlives: true,
                    scrollDirection: Axis.vertical,
                    itemCount: data.items.length,
                    itemBuilder: (ctx, i) {

                      return CardItem(data.items[i]);
                    }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
