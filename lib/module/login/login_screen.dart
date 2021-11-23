import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shoppy/layout/shoppy_layout.dart';
import 'package:shoppy/module/login/cubit/states.dart';
import 'package:shoppy/module/signup/signup_screen.dart';
import 'package:shoppy/shared/components/components.dart';
import 'package:shoppy/shared/network/local/cache_helper.dart';

import 'cubit/cubit.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController=TextEditingController();
  final TextEditingController passwordController=TextEditingController();
  final GlobalKey<FormState> formKey=GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context)=>ShoppyLoginCubit(),
      child: BlocConsumer<ShoppyLoginCubit,ShoppyLoginStates>(
          listener: (context,state){

            if(state is ShoppyLoginSuccessState){
              CacheHelper.saveData(
                  key: 'uId',
                  value: state.uId).then((value) {
                navigateAndFinish(context,ShoppyLayout());
              });
            }
            if(state is ShoppyGoogleLoginSuccessState){
              GoogleSignInAccount? myGoogleUser=ShoppyLoginCubit.get(context).myGoogleUser;
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
              var userData=ShoppyLoginCubit.get(context).faceBookUserData;
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

            if(state is ShoppyLoginErrorState){
              showToast(
                  message: state.error,
                  state: ToastState.ERROR);
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
                  'Login',
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
                            'Login with one of The following Options',
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
                                        ShoppyLoginCubit.get(context).signInWithGoogle();
                                      },
                                      child:FaIcon(FontAwesomeIcons.google,color: Colors.red,size: 25,),
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
                                        ShoppyLoginCubit.get(context).signInWithFacebook();
                                      },
                                      child:FaIcon(FontAwesomeIcons.facebookF,color: Colors.blue,size: 25,),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20.0,),
                          Text(
                            'Email',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          SizedBox(height: 15.0,),
                          defaultFormField(
                            context: context,
                            controller: emailController,
                            type: TextInputType.emailAddress,
                            validate: (value){
                              if(value!.isEmpty){
                                return 'Please enter Your email';
                              }
                            },
                            label: "Email",
                          ),
                          SizedBox(height: 20.0,),
                          Text(
                            'Password',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          SizedBox(height: 15.0,),
                          defaultFormField(
                            context: context,
                            controller: passwordController,
                            type: TextInputType.visiblePassword,
                            validate: (value){
                              if(value!.isEmpty){
                                return 'Please enter your password';
                              }
                            },
                            isPassword: ShoppyLoginCubit.get(context).isPassword,
                            label: "Password",
                            suffix: ShoppyLoginCubit.get(context).icon,
                            suffixPressed: () {
                              ShoppyLoginCubit.get(context).changePasswordVisibility();
                            },
                          ),
                          SizedBox(
                            height: 25.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:
                            state is! ShoppyLoginLoadingState?
                            defaultButton(
                              context: context,
                              onPressFunction: () {
                                if(formKey.currentState!.validate()){
                                  ShoppyLoginCubit.get(context).userLogin(
                                      email: emailController.text,
                                      password: passwordController.text);
                                }
                              },
                              text: 'LOGIN',
                            ):Center(child: CircularProgressIndicator()),
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Don\'t have an account?',
                                style: Theme.of(context).textTheme.subtitle1,

                              ),
                              TextButton(onPressed: (){
                                navigateTo(context,SignupScreen());
                              },
                                  child: Text('Register Now'))
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
