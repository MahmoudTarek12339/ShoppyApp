import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shoppy/layout/cubit/cubit.dart';
import 'package:shoppy/layout/cubit/states.dart';
import 'package:shoppy/layout/shoppy_layout.dart';
import 'package:shoppy/module/home/profile/orders_screen.dart';
import 'package:shoppy/module/home/profile/reset_password_screen.dart';
import 'package:shoppy/shared/components/components.dart';

class ProfileScreen extends StatelessWidget {
  late String userName;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>ShoppyCubit(),
      child: BlocConsumer<ShoppyCubit,ShoppyStates>(
        listener: (context,state){
          if(state is UserLoggedOutSuccessState){
            navigateAndFinish(context,ShoppyLayout());
            showToast(
                message: 'Logged out successfully',
                state: ToastState.SUCCESS
            );
          }
          else if(state is ShoppyChangeNameSuccessState){
            userName=FirebaseAuth.instance.currentUser!.displayName.toString();
          }
        },
        builder: (context,state){
          User? user = FirebaseAuth.instance.currentUser;
          userName=user!.displayName.toString();
          return Scaffold(
            appBar: AppBar(
              title: Text('Profile'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 75.0,
                    backgroundImage:  user.photoURL != null
                        ? NetworkImage(user.photoURL.toString()) as ImageProvider
                        : AssetImage('assets/images/default_login2.jpg'),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          userName,
                          style: Theme.of(context).textTheme.bodyText1,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        onPressed: (){
                          showNameCustomDialog(context);
                        },
                        icon: FaIcon(
                          FontAwesomeIcons.pen,
                          color: Colors.blueAccent,
                          size: 15,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
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
                            style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.red),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          FaIcon(FontAwesomeIcons.signOutAlt,color: Colors.redAccent,size: 17,)
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
  void showNameCustomDialog(BuildContext context) {
    final TextEditingController nameController=TextEditingController();
    final GlobalKey<FormState> formKey=GlobalKey<FormState>();
    showDialog(
      context: context,
      builder: (context) =>
          BlocProvider(

            create: (BuildContext context)=>ShoppyCubit(),
            child: BlocConsumer<ShoppyCubit,ShoppyStates>(

              listener: (context,state){
                if(state is ShoppyChangeNameSuccessState){
                  showToast(message: 'Name Changed Successfully', state: ToastState.SUCCESS);
                  Navigator.pop(context);
                }
                else if(state is ShoppyChangeNameErrorState){
                  showToast(message: state.error.toString(), state: ToastState.ERROR);
                }
              },
              builder: (context,state){
                return Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)
                  ),
                  child: Form(
                    key: formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          defaultFormField(
                              controller: nameController,
                              type: TextInputType.name,
                              inputColor: Colors.black,
                              borderColor: Colors.black,
                              validate: (value){
                                if (value!.isEmpty) {
                                  return 'please enter your name';
                                }
                              },
                              label: 'Enter your Name',
                              context: context),
                          MaterialButton(
                              color: Colors.amber,
                              onPressed: (){
                                if(formKey.currentState!.validate()){
                                  ShoppyCubit.get(context).changeName(name: nameController.text);
                                }
                              },
                              child: Text('Save')),
                          if(state is ShoppyChangeNameLoadingState)
                            LinearProgressIndicator(),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          )
    );
  }
}
