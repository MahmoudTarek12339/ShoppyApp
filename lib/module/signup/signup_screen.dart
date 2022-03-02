import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shoppy/layout/shoppy_layout.dart';
import 'package:shoppy/module/login/login_screen.dart';
import 'package:shoppy/shared/components/components.dart';
import 'package:shoppy/shared/network/local/cache_helper.dart';

import '../../shared/components/constants.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';
import 'image_picker.dart';

class SignupScreen extends StatelessWidget {
  final TextEditingController emailController=TextEditingController();
  final TextEditingController phoneController=TextEditingController();
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
            //offline handling
            if(state is ShoppyInternetNotConnectedState){
              defaultSnackBar(
                  context: context,
                  title: 'you are currently offline',
                  color: Colors.black);
            }

            //signup Successfully
            if(state is ShoppyGoogleLoginSuccessState){
              GoogleSignInAccount? myGoogleUser=ShoppySignupCubit.get(context).myGoogleUser;
              defaultSnackBar(
                context: context,
                color: Colors.green,
                title: 'Welcome ${myGoogleUser!.displayName}',
              );
              CacheHelper.saveData(
                  key: 'uId',
                  value: state.uId).then((value) {
                navigateAndFinish(context,ShoppyLayout());
              });
            }
            else if(state is ShoppyFaceBookLoginSuccessState){
              var userData=ShoppySignupCubit.get(context).faceBookUserData;
              defaultSnackBar(
                context: context,
                color: Colors.green,
                title: 'Welcome ${userData['name']}',
              );
              CacheHelper.saveData(
                  key: 'uId',
                  value: state.uId).then((value) {
                navigateAndFinish(context,ShoppyLayout());
              });
            }
            else if(state is ShoppyGoogleLoginErrorState){
              defaultSnackBar(
                context: context,
                color: Colors.red,
                title: state.error,
              );
            }
            //error SignUp
            else if(state is ShoppyFaceBookLoginErrorState){
              defaultSnackBar(
                context: context,
                color: Colors.red,
                title: state.error,
              );
            }
          },
          builder: (context,state){
            return Scaffold(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              appBar: AppBar(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                          Row(
                            children: [
                              textUtils(
                                fontSize: 28.0,
                                fontWeight: FontWeight.w500,
                                text: 'Sign',
                                color:Theme.of(context).focusColor ,
                              ),
                              textUtils(
                                fontSize: 28.0,
                                fontWeight: FontWeight.w500,
                                text: ' Up',
                                color:Theme.of(context).textTheme.bodyText1!.color ,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 50,
                          ),

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
                                    if(value.toString().length<=2||!RegExp(validationName).hasMatch(value!)){
                                      return 'please enter your name';
                                    }
                                    return null;
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
                                    if(value.toString().length<=2||!RegExp(validationName).hasMatch(value!)){
                                      return 'please enter your name';
                                    }
                                    return null;
                                  },
                                  label: "Last Name",
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.0,),
                          defaultFormField(
                            context: context,
                            controller: phoneController,
                            type: TextInputType.phone,
                            validate: (value){
                              if(value.toString().length!=11){
                                return 'please enter Valid Number';
                              }
                              return null;
                            },
                            label: "Phone Number",
                          ),
                          SizedBox(height: 20.0,),
                          defaultFormField(
                            context: context,
                            controller: emailController,
                            type: TextInputType.emailAddress,
                            validate: (value){
                              if(!RegExp(validationEmail).hasMatch(value!)){
                                return 'please enter your email';
                              }
                              return null;
                            },
                            label: "Email",
                          ),
                          SizedBox(height: 20.0,),
                          defaultFormField(
                            context: context,
                            controller: passwordController,
                            type: TextInputType.visiblePassword,
                            validate: (value){
                              if(value.toString().length<8){
                                return 'Password Must be at least 8 characters';
                              }
                              return null;
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
                              return null;
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

                                  ShoppySignupCubit.get(context).userRegister(
                                    name: firstNameController.text+' '+lastNameController.text,
                                    email: emailController.text,
                                    password: emailController.text,
                                    phone: phoneController.text
                                  );
                                  navigateTo(context, ImagePickingScreen());
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
