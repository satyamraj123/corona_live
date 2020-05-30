import 'package:flutter/material.dart';
import '../providers/data.dart';

class CardItem extends StatelessWidget {
  final Data data;
  CardItem(this.data);

  @override
  Widget build(BuildContext context) {
    void _showSnackBar() {
    Scaffold.of(context).removeCurrentSnackBar();
  
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Total active Cases : ' + data.activecases.toString()),
        
      ));
    }

    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Color.fromRGBO(50, 50, 50, 1)),
      margin: EdgeInsets.all(10),
      child: Row(children: <Widget>[
        Column(
          children: <Widget>[
            const SizedBox(
              height: 10,
            ),
            Container(
              alignment: Alignment.center,
              width: 300,
              child: Text(
                data.place,
                softWrap: true,
                textAlign: TextAlign.center,
                overflow: TextOverflow.fade,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Confirmed',
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(width: 100),
                Text(
                  data.deltaconfirmed.toString(),
                  style: TextStyle(color: Colors.white),
                ),
                const Icon(
                  Icons.arrow_upward,
                  color: Colors.red,
                ),
                const SizedBox(width: 20),
                Text(
                  data.confirmedcases.toString(),
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Recovered',
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(width: 105),
                Text(
                  data.deltarecovered.toString(),
                  style: TextStyle(color: Colors.white),
                ),
                const Icon(
                  Icons.arrow_upward,
                  color: Colors.green,
                ),
                const SizedBox(width: 20),
                Text(
                  data.recovered.toString(),
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Deceased',
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(width: 110),
                Text(
                  data.deltadeaths.toString(),
                  style: TextStyle(color: Colors.white),
                ),
                const Icon(Icons.arrow_upward),
                const SizedBox(width: 20),
                Text(
                  data.deaths.toString(),
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            if (data.lastupdatedtime != null)
              Text(
                'Last updated: ' + data.lastupdatedtime,
                style: TextStyle(color: Colors.black),
                textAlign: TextAlign.left,
              ),
            SizedBox(
              height: 10,
            )
          ],
        ),
        SizedBox(width: 30),
        if (data.activecases >= 1000 && data.activecases < 5000)
          CircleAvatar(
            backgroundColor: Colors.yellow,
            radius: 30,
            child: Text('Active Cases:\n'+data.activecases.toString(),style: TextStyle(color: Colors.black,fontSize: 8),textAlign: TextAlign.center,),
          ),
        if (data.activecases >= 5000)
          CircleAvatar(
            backgroundColor: Colors.red,
            radius: 30,
            child: Text('Active Cases:\n'+data.activecases.toString(),style: TextStyle(color: Colors.black,fontSize: 8),textAlign: TextAlign.center,),
          ),
        if (data.activecases < 1000)
          CircleAvatar(
            backgroundColor: Colors.green,
            radius: 30,
            child: Text('Active Cases:\n'+data.activecases.toString(),style: TextStyle(color: Colors.black,fontSize: 8),textAlign: TextAlign.center,),
          ),
      ]),
    );
  }
}
