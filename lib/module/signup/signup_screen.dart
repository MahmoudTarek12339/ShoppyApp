import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shoppy/layout/shoppy_layout.dart';
import 'package:shoppy/model/user_model.dart';
import 'package:shoppy/module/login/login_screen.dart';
import 'package:shoppy/shared/components/components.dart';
import 'package:shoppy/shared/network/local/cache_helper.dart';

import 'cubit/cubit.dart';
import 'cubit/states.dart';
import 'mobile_verification.dart';

class SignupScreen extends StatelessWidget {
  final TextEditingController emailController=TextEditingController();
  final TextEditingController passwordController=TextEditingController();
  final TextEditingController confirmPasswordController=TextEditingController();
  final TextEditingController numberController=TextEditingController();
  final TextEditingController firstNameController=TextEditingController();
  final TextEditingController lastNameController=TextEditingController();
  final GlobalKey<FormState> formKey=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context)=>ShoppySignupCubit(),
      child: BlocConsumer<ShoppySignupCubit,ShoppySignupStates>(
          listener: (context,state){
            if(state is ShoppyGoogleLoginSuccessState){
              GoogleSignInAccount? myGoogleUser=ShoppySignupCubit.get(context).myGoogleUser;
              showToast(
                  message: 'Welcome ${myGoogleUser!.displayName}',
                  state: ToastState.SUCCESS
              );
              CacheHelper.saveData(
                  key: 'uId',
                  value: state.uId).then((value) {
                navigateAndFinish(context,ShoppyLayout());
              });
            }
            if(state is ShoppyFaceBookLoginSuccessState){
              var userData=ShoppySignupCubit.get(context).faceBookUserData;
              showToast(
                  message: 'Welcome ${userData['name']}',
                  state: ToastState.SUCCESS
              );
              CacheHelper.saveData(
                  key: 'uId',
                  value: state.uId).then((value) {
                navigateAndFinish(context,ShoppyLayout());
              });
            }

            if(state is ShoppyGoogleLoginErrorState){
              showToast(
                  message: state.error,
                  state: ToastState.ERROR
              );
            }
            if(state is ShoppyFaceBookLoginErrorState){
              showToast(
                  message: state.error,
                  state: ToastState.ERROR
              );
            }

          },
          builder: (context,state){
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  'Sign up',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
              body: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Sign up with one of The following Options',
                            style: Theme.of(context).textTheme.caption,
                          ),
                          SizedBox(height: 15.0,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 35.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15.0),
                                        border: Border.all(color: Colors.blueGrey)
                                    ),
                                    child: MaterialButton(
                                      onPressed: (){
                                        ShoppySignupCubit.get(context).signInWithGoogle();
                                      },
                                      child: FaIcon(FontAwesomeIcons.google,color: Colors.red,size: 25,),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 20.0,
                                ),
                                Expanded(
                                  child: Container(

                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15.0),
                                        border: Border.all(color: Colors.blueGrey)
                                    ),
                                    child: MaterialButton(
                                      onPressed: (){
                                        ShoppySignupCubit.get(context).signInWithFacebook();
                                      },
                                      child:
                                      FaIcon(FontAwesomeIcons.facebookF,color: Colors.blue,size: 25,),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 25.0,),
                          Row(
                            children: [
                              Expanded(
                                child: defaultFormField(
                                  context: context,
                                  controller: firstNameController,
                                  type: TextInputType.name,
                                  validate: (value){
                                    if(value!.isEmpty){
                                      return 'please enter your name';
                                    }
                                  },
                                  label: "First Name",
                                ),
                              ),
                              SizedBox(width: 20.0,),
                              Expanded(
                                child: defaultFormField(
                                  context: context,
                                  controller: lastNameController,
                                  type: TextInputType.name,
                                  validate: (value){
                                    if(value!.isEmpty){
                                      return 'please enter your name';
                                    }
                                  },
                                  label: "Last Name",
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.0,),
                          defaultFormField(
                            context: context,
                            controller: emailController,
                            type: TextInputType.emailAddress,
                            validate: (value){
                              if(value!.isEmpty){
                                return 'please enter your email';
                              }
                            },
                            label: "Email",
                          ),
                          SizedBox(height: 20.0,),
                          defaultFormField(
                            context: context,
                            controller: passwordController,
                            type: TextInputType.visiblePassword,
                            validate: (value){
                              if(value!.isEmpty){
                                return 'password mustn\'t be empty';
                              }
                              else if(value.length<8){
                                return 'password is too short';
                              }
                            },
                            isPassword: ShoppySignupCubit.get(context).isPassword,
                            label: "Password",
                            suffix: ShoppySignupCubit.get(context).icon,
                            suffixPressed: () {
                              ShoppySignupCubit.get(context).changePasswordVisibility();
                            },
                          ),
                          SizedBox(height: 20.0,),
                          defaultFormField(
                            context: context,
                            controller: confirmPasswordController,
                            type: TextInputType.visiblePassword,
                            validate: (value){
                              if(value!.isEmpty){
                                return 'please confirm your password';
                              }
                              else if(value!=passwordController.text.toString()){
                                return 'this not match';
                              }
                            },
                            isPassword: true,
                            label: "Confirm Password",
                          ),
                          SizedBox(
                            height: 35.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: defaultButton(
                              context: context,
                              onPressFunction: () {
                                if(formKey.currentState!.validate()){
                                  UserModel user=UserModel(
                                    name:firstNameController.text+' '+lastNameController.text,
                                    email: emailController.text,
                                    password: passwordController.text,
                                  );
                                  navigateTo(context, MobileVerificationScreen(user));
                                }
                              },
                              text: 'Create Account',
                            ),
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'already have account!',
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                              TextButton(onPressed: (){
                                navigateAndFinish(context,LoginScreen());
                              },
                                  child: Text('Log in'))
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
      ),
    );
  }
}
