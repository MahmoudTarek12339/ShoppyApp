import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shoppy/layout/cubit/cubit.dart';
import 'package:shoppy/layout/cubit/states.dart';
import 'package:shoppy/layout/shoppy_layout.dart';
import 'package:shoppy/module/home/profile/user_managment/user_orders/orders_screen.dart';
import 'package:shoppy/module/home/profile/user_managment/reset_password_screen.dart';
import 'package:shoppy/module/home/profile/user_managment/user_addresses/saved_addresses_screen.dart';
import 'package:shoppy/module/home/profile/user_managment/account_info_screen.dart';

import 'package:shoppy/shared/components/components.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>ShoppyCubit(),
      child: BlocConsumer<ShoppyCubit,ShoppyStates>(
        listener: (context,state){
          if(state is UserLoggedOutSuccessState){
            navigateAndFinish(context,ShoppyLayout());
            defaultSnackBar(
              context: context,
              color: Colors.green,
              title: 'Logged out successfully',
            );
          }
          else if(state is UserLoggedOutErrorState){
            navigateAndFinish(context,ShoppyLayout());
            defaultSnackBar(
              context: context,
              color: Colors.red,
              title: state.error,
            );
          }
        },
        builder: (context,state){
          User? user = FirebaseAuth.instance.currentUser;
          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: AppBar(
              backgroundColor: Theme.of(context).focusColor,
              title: Text('Profile'),
              centerTitle: true,
            ),
            body: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 75.0,
                    backgroundImage:  user!.photoURL != null
                        ? NetworkImage(user.photoURL.toString()) as ImageProvider
                        : AssetImage('assets/images/default_login2.jpg'),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    user.displayName.toString(),
                    style: Theme.of(context).textTheme.bodyText1,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  MaterialButton(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    elevation: 1.0,
                    onPressed: (){
                      navigateTo(context, AccountInfoScreen());
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Account info',
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        Spacer(),
                        Icon(Icons.arrow_forward_ios_outlined,color: Theme.of(context).iconTheme.color,),
                      ],
                    ),
                  ),
                  MaterialButton(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    elevation: 1.0,
                    onPressed: (){
                      navigateTo(context, SavedAddressesScreen());
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Saved Addresses',
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        Spacer(),
                        Icon(Icons.arrow_forward_ios_outlined,color: Theme.of(context).iconTheme.color,),
                      ],
                    ),
                  ),
                  MaterialButton(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    elevation: 1.0,
                    onPressed: (){
                      navigateTo(context, ResetPasswordScreen());
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Change Password',
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        Spacer(),
                        Icon(Icons.arrow_forward_ios_outlined,color: Theme.of(context).iconTheme.color,),
                      ],
                    ),
                  ),
                  MaterialButton(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    elevation: 1.0,
                    onPressed: (){
                      navigateTo(context, OrdersScreen());
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Orders',
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        Spacer(),
                        Icon(Icons.arrow_forward_ios_outlined,color: Theme.of(context).iconTheme.color,),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextButton(
                      onPressed: (){
                        ShoppyCubit.get(context).signOut();
                      },
                      child: Row(
                        mainAxisAlignment:MainAxisAlignment.center,
                        children: [
                          Text(
                            'Log out',
                            style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Theme.of(context).focusColor),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          FaIcon(FontAwesomeIcons.signOutAlt,color: Theme.of(context).focusColor,size: 17,)
                        ],
                      ),

                    ),
                ],
              ),
            )
          );
        },
      ),
    );
  }
}
