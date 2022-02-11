import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoppy/layout/cubit/cubit.dart';
import 'package:shoppy/layout/cubit/states.dart';
import 'package:shoppy/layout/shoppy_layout.dart';
import 'package:shoppy/module/onboarding.dart';
import 'package:shoppy/shared/bloc_observer.dart';
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
  print("user id is:$uId");

  //enable bloc observer
  Bloc.observer = MyBlocObserver();

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

    return BlocProvider(
      create: (context)=>ShoppyCubit()..getAllProducts(),
      child:BlocConsumer<ShoppyCubit,ShoppyStates>(
        listener:(context,state){},
        builder:(context,state){
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            home:startWidget,
          );
        }
      )
    );
  }
}