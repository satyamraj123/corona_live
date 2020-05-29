
import 'screens/home_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'providers/data.dart';
import 'package:flare_loading/flare_loading.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: ChartData()),
          ChangeNotifierProvider.value(value: CardData()),
          ChangeNotifierProvider.value(value: TimeSeries()),
          ChangeNotifierProvider.value(value: DistrictData()),
          ChangeNotifierProvider.value(value: DistrictChartData()),
          ChangeNotifierProvider.value(value: TotalData()),
          

        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              fontFamily: 'CM',
              primaryColor: Colors.white,
              accentColor: Colors.white,
              primarySwatch: Colors.amber),
          home: SplashScreen(),
          ),
        
        //Center(child: FlatButton(child: Text('ge data'),onPressed: _getData,),),),

        );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: FlareLoading(
            name: 'assets/splash_screen.flr',
            fit: BoxFit.cover,
            startAnimation: 'Untitled',
            onError: null,
            onSuccess: (data) {
              setState(() {
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(ctx)=>HomePage()));
              });
              
            }),
      ),
    );
  }
}

