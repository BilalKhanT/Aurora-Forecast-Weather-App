import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:weatherapp/provider/location_provider.dart';
import 'package:weatherapp/provider/theme_provider.dart';
import 'package:weatherapp/ui_screen/splash.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LocationProvider locationProvider = LocationProvider();
  LocationData locationData = await locationProvider.getLocation();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider<LocationProvider>.value(value: locationProvider),
      ],
      child: MyApp(lat: locationData.latitude, lang: locationData.longitude,),
    ),
  );
}

class MyApp extends StatefulWidget {

  var lat;
  var lang;

  MyApp({
    required this.lat,
    required this.lang,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WeatherApp',
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: SplashScreen(lat: widget.lat, lang: widget.lang,),
    );
  }
}
