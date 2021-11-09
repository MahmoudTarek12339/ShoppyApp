import 'package:flutter/material.dart';
import 'package:shoppy/layout/shoppy_layout.dart';
import 'package:shoppy/module/onboarding.dart';
import 'package:flutter/services.dart';
import 'package:shoppy/shared/network/local/cache_helper.dart';

late bool onBoarding;
late Widget startWidget;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  onBoarding=CacheHelper.getData(key: 'onBoarding')??false;
  if(onBoarding)
    startWidget=ShoppyLayout();
  else
    startWidget=OnBoardingScreen();
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
      home:OnBoardingScreen(),
    );
  }
}


