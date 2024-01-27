import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'home.dart';

class SplashScreen extends StatefulWidget {

  var lat;
  var lang;
  SplashScreen({required this.lat, required this.lang});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return  Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.deepOrangeAccent,
            Color(0xff281537),
            // Add more colors if needed
          ],
        ),
      ),
      child: AnimatedSplashScreen(
        splash: Column(
          children: <Widget>[
            Image.asset("assets/splashImg.gif"),
            Text(
              'Aurora Forecast',
              style: GoogleFonts.syne(
                color: Colors.grey.shade300,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.transparent, // Set to transparent
        nextScreen: HomeScreen(lat: widget.lat, lang: widget.lang,),
        splashIconSize: 600,
        splashTransition: SplashTransition.slideTransition,
      ),
    );
  }
}