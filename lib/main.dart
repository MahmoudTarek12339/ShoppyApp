import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shoppy/layout/cubit/cubit.dart';
import 'package:shoppy/layout/cubit/states.dart';
import 'package:shoppy/module/spalsh_screen/splash_screen.dart';
import 'package:shoppy/shared/bloc_observer.dart';
import 'package:shoppy/shared/network/local/cache_helper.dart';
import 'package:shoppy/shared/styles/themes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  //cache initializing
  await CacheHelper.init();
  //firebase initializing
  await Firebase.initializeApp();

  //enable bloc observer
  Bloc.observer = MyBlocObserver();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context)=>ShoppyCubit()..appStart(context:context),
      child:BlocConsumer<ShoppyCubit,ShoppyStates>(
        listener:(context,state){},
        builder:(context,state){
          SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle(
              statusBarBrightness:Theme.of(context).primaryColor==Colors.white?Brightness.dark:Brightness.light,
          ));
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            home:SplashScreen(),
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: [
              Locale('en', ''), // English, no country code
              Locale('ar', ''), // Arabic, no country code
            ],
          );
        }
      )
    );
  }
}