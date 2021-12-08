
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shoppy/layout/cubit/states.dart';
import 'package:shoppy/module/home/cart_screen.dart';
import 'package:shoppy/module/home/profile_screen.dart';
import 'package:shoppy/module/login/login_screen.dart';
import 'package:shoppy/module/home/search_screen.dart';
import 'package:shoppy/shared/components/components.dart';

import 'cubit/cubit.dart';

class ShoppyLayout extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context)=>ShoppyCubit(),
      child: BlocConsumer<ShoppyCubit,ShoppyStates>(
        listener: (context,state){},
        builder:(context,state){
          var cubit=ShoppyCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              titleSpacing: 10.0,
              title: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Theme.of(context).iconTheme.color
                ),
                child: InkWell(
                  onTap: () {
                    navigateTo(context, SearchScreen());
                  },
                  child: TextFormField(
                    enabled: false,
                    decoration: InputDecoration(
                      hintText: "Search for Brand",
                      hintStyle: TextStyle(color: Colors.grey),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      navigateTo(context, CartScreen());
                    },
                    icon: FaIcon(
                      FontAwesomeIcons.shoppingCart,
                      color: Theme.of(context).iconTheme.color,
                      size: 25,
                    )),
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: InkWell(
                    child: CircleAvatar(
                      radius: 20.0,
                      backgroundImage: user != null && user!.photoURL != null
                          ? NetworkImage(user!.photoURL.toString()) as ImageProvider
                          : AssetImage('assets/images/default_login2.jpg'),
                    ),
                    onTap: () {
                      if (user == null)
                        navigateTo(context, LoginScreen());
                      else
                        navigateTo(context, ProfileScreen());
                    },
                  ),
                ),
              ],
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
                    icon: FaIcon(FontAwesomeIcons.questionCircle),
                    label: 'help'
                ),
              ],
            )
          );
        }
      ),
    );
  }
}
