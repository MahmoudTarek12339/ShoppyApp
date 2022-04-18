import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shoppy/layout/cubit/cubit.dart';
import 'package:shoppy/layout/cubit/states.dart';
import 'package:shoppy/shared/components/components.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ShoppyLayout extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShoppyCubit,ShoppyStates>(
      listener: (context,state){
        if(state is ShoppyInternetNotConnectedState){
          defaultSnackBar(
              context: context,
              title: '${AppLocalizations.of(context)!.youAreCurrentlyOffline}',
              color: Colors.black);
        }
        else if(state is ShoppyLoginFirstState){
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return alertLogin(
                  context: context,
                  title: '${AppLocalizations.of(context)!.loginFirstToSaveYourData}'
              );
            },
          );
        }
      },
      builder:(context,state){
        var cubit=ShoppyCubit.get(context);
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: cubit.currentIndex==0?
            null
              :AppBar(
            title: Text(cubit.titles[cubit.currentIndex]),
            centerTitle: true,
            backgroundColor: Theme.of(context).focusColor,
            elevation: 0.0,
          ),
          body:(state is ShoppyInternetNotConnectedState ||state is SocialChangeBottomNavState) && ShoppyCubit.get(context).products.isEmpty?
            buildOffline(context: context,cubit: ShoppyCubit.get(context))
              : cubit.screens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: cubit.currentIndex,
            onTap: (index){
              cubit.changeBottomNav(index);
            },
            items: [
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.home),
                label: '${AppLocalizations.of(context)!.home}',
              ),
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.shopify),
                label: '${AppLocalizations.of(context)!.stores}',
              ),
              BottomNavigationBarItem(
                  icon: FaIcon(FontAwesomeIcons.listAlt),
                  label: '${AppLocalizations.of(context)!.categories}'
              ),
              BottomNavigationBarItem(
                  icon: FaIcon(FontAwesomeIcons.heart),
                  label: '${AppLocalizations.of(context)!.wishList}'
              ),
              BottomNavigationBarItem(
                  icon: FaIcon(FontAwesomeIcons.infoCircle),
                  label: '${AppLocalizations.of(context)!.info}'
              ),
            ],
          )
        );
      }
    );
  }
  Widget buildOffline({required context,required cubit})=>Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FaIcon(
            FontAwesomeIcons.wifi,
            size: 100,
            color: Theme.of(context).focusColor.withOpacity(0.8)
        ),
        Text(
          '${AppLocalizations.of(context)!.whoops}',
          style: Theme.of(context).textTheme.bodyText1,
        ),
        SizedBox(height: 5,),
        Text(
          '${AppLocalizations.of(context)!.slowConnection}',
          style: Theme.of(context).textTheme.caption!.copyWith(fontSize: 16),
        ),
        SizedBox(height: 2,),
        Text(
          '${AppLocalizations.of(context)!.checkInternet}',
          style: Theme.of(context).textTheme.caption!.copyWith(fontSize: 16),
        ),
        SizedBox(height: 15,),
        defaultButton(
          onPressFunction: (){
            cubit.appStart(context:context);
          },
          text: '${AppLocalizations.of(context)!.tryAgain}',
          context: context,
          width: 150
        )
      ],
    ),
  );
}
