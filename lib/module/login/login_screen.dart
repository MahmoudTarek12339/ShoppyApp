import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shoppy/layout/cubit/cubit.dart';
import 'package:shoppy/layout/shoppy_layout.dart';
import 'package:shoppy/module/login/cubit/states.dart';
import 'package:shoppy/module/signup/signup_screen.dart';
import 'package:shoppy/shared/components/components.dart';
import 'package:shoppy/shared/network/local/cache_helper.dart';

import '../../shared/components/constants.dart';
import 'cubit/cubit.dart';
import 'forgot_password.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


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
            //offline handling
            if(state is ShoppyInternetNotConnectedState){
              defaultSnackBar(
                  context: context,
                  title: 'you are currently offline',
                  color: Colors.black);
            }
            //login successfully
            if(state is ShoppyLoginSuccessState){
              ShoppyCubit.get(context).appStart(context: context);
              CacheHelper.saveData(
                  key: 'uId',
                  value: state.uId).then((value) {
                navigateAndFinish(context,ShoppyLayout());
              });
            }
            else if(state is ShoppyGoogleLoginSuccessState){
              GoogleSignInAccount? myGoogleUser=ShoppyLoginCubit.get(context).myGoogleUser;
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
              var userData=ShoppyLoginCubit.get(context).faceBookUserData;
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
            //login Error
            else if(state is ShoppyLoginErrorState){
              defaultSnackBar(
                context: context,
                color: Colors.red,
                title: state.error,
              );
            }
            else if(state is ShoppyGoogleLoginErrorState){
              defaultSnackBar(
                context: context,
                color: Colors.red,
                title: state.error,
              );
            }
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
              backgroundColor:Theme.of(context).scaffoldBackgroundColor ,
              appBar: AppBar(
                backgroundColor:Theme.of(context).scaffoldBackgroundColor ,
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
                                text: '${AppLocalizations.of(context)!.log}',
                                color:Theme.of(context).focusColor ,
                              ),
                              textUtils(
                                fontSize: 28.0,
                                fontWeight: FontWeight.w500,
                                text: ' ${AppLocalizations.of(context)!.iN}',
                                color:Theme.of(context).textTheme.bodyText1!.color ,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          Text(
                            '${AppLocalizations.of(context)!.loginWithOneOfTheFollowingOptions}',
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
                            '${AppLocalizations.of(context)!.email}',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          SizedBox(height: 15.0,),
                          defaultFormField(
                            context: context,
                            controller: emailController,
                            type: TextInputType.emailAddress,
                            validate: (value){
                              if(value!.isEmpty||!RegExp(validationEmail).hasMatch(value)){
                                return 'Please enter Valid email';
                              }
                              return null;
                            },
                            label: "${AppLocalizations.of(context)!.email}",
                          ),
                          SizedBox(height: 20.0,),
                          Text(
                            '${AppLocalizations.of(context)!.password}',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          SizedBox(height: 15.0,),
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
                            isPassword: ShoppyLoginCubit.get(context).isPassword,
                            label: "${AppLocalizations.of(context)!.password}",
                            suffix: ShoppyLoginCubit.get(context).icon,
                            suffixPressed: () {
                              ShoppyLoginCubit.get(context).changePasswordVisibility();
                            },
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                                onPressed: (){
                                  navigateTo(context,ForgetPasswordScreen());
                                },
                                child: textUtils(
                                  text: '${AppLocalizations.of(context)!.forgetPassword}',
                                  color: Theme.of(context).textTheme.bodyText1!.color,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14.0,
                                )
                            ),
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
                              text: '${AppLocalizations.of(context)!.logIn}',
                            ):Center(child: CircularProgressIndicator()),
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${AppLocalizations.of(context)!.doNotHaveAnAccount}',
                                style: Theme.of(context).textTheme.subtitle1,

                              ),
                              TextButton(onPressed: (){
                                navigateTo(context,SignupScreen());
                              },
                                  child: Text('${AppLocalizations.of(context)!.registerNow}'))
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
