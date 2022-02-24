
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:shoppy/layout/shoppy_layout.dart';
import 'package:shoppy/module/onboarding.dart';
import 'package:shoppy/shared/network/local/cache_helper.dart';
import 'package:shoppy/shared/components/constants.dart';
import 'package:shoppy/shared/styles/colors.dart';


class SplashScreen extends StatefulWidget {
  final bool onBoarding =CacheHelper.getData(key: 'onBoarding')??false;
  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    uId = CacheHelper.getData(key: 'uId');
    late Widget startWidget;

    if(widget.onBoarding) {
       startWidget=ShoppyLayout() ;
    }
    else{
      startWidget=OnBoardingScreen();
    }
    return Scaffold(
      body: AnimatedSplashScreen(
        splashIconSize: double.infinity,
        splashTransition: SplashTransition.fadeTransition,
        splash: Container(
          height: double.infinity,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/png1.png',
                  width: 90,
                  height: 90,
                ),
                Text(
                  'Shoppy App',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.white),
                )
              ],
            ),
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              deepOrange,
              lightOrange,
              Colors.orange,
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          ),
        ),
        nextScreen:startWidget,
        duration: 0,
        backgroundColor: Colors.orange,
      ),
    );
  }
}
