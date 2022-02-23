import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shoppy/layout/cubit/states.dart';
import 'cubit/cubit.dart';

class ShoppyLayout extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShoppyCubit,ShoppyStates>(
      listener: (context,state){},
      builder:(context,state){
        var cubit=ShoppyCubit.get(context);
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: cubit.currentIndex==0?null:
          AppBar(
            title: Text(cubit.titles[cubit.currentIndex]),
            centerTitle: true,
            backgroundColor: Theme.of(context).focusColor,
            elevation: 0.0,
          ),
          body: cubit.screens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: cubit.currentIndex,
            onTap: (index){
              cubit.changeBottomNav(index);
            },
            items: [
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                  icon: FaIcon(FontAwesomeIcons.listAlt),
                  label: 'Categories'
              ),
              BottomNavigationBarItem(
                  icon: FaIcon(FontAwesomeIcons.heart),
                  label: 'Wish List'
              ),
              BottomNavigationBarItem(
                  icon: FaIcon(FontAwesomeIcons.infoCircle),
                  label: 'info'
              ),
            ],
          )
        );
      }
    );
  }
}
