import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shoppy/layout/shoppy_layout.dart';
import 'package:shoppy/module/onboarding.dart';
import 'package:flutter/services.dart';
import 'package:shoppy/shared/components/constants.dart';
import 'package:shoppy/shared/network/local/cache_helper.dart';
import 'package:shoppy/shared/styles/themes.dart';

late bool onBoarding;
late Widget startWidget;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  //cache initializing
  await CacheHelper.init();

  //firebase initializing
  await Firebase.initializeApp();
  //get user uId
  uId = CacheHelper.getData(key: 'uId');

  //check if on boarding is done
  onBoarding=CacheHelper.getData(key: 'onBoarding')??false;
  if(onBoarding)
    startWidget=ShoppyLayout();
  else
    startWidget=OnBoardingScreen();

  //get mobile device mode
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //hide status bar
    SystemChrome.setEnabledSystemUIOverlays(
        [
          SystemUiOverlay.bottom, //This line is used for showing the bottom bar
        ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      home:startWidget,
    );
  }
}


