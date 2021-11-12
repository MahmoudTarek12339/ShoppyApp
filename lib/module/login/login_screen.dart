import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoppy/module/login/cubit/states.dart';
import 'package:shoppy/module/signup/signup_screen.dart';
import 'package:shoppy/shared/components/components.dart';

import 'cubit/cubit.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController=TextEditingController();
  final TextEditingController passwordController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context)=>ShoppyLoginCubit(),
      child: BlocConsumer<ShoppyLoginCubit,ShoppyLoginStates>(
          listener: (context,state){

          },
          builder: (context,state){
            return Scaffold(
              backgroundColor: Colors.black,
              appBar: AppBar(
                backgroundColor: Colors.black,
                title: Text(
                  'Login',
                  style: TextStyle(
                      color: Colors.white
                  ),
                ),
              ),
              body: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Login with one of The following Options',
                          style: Theme.of(context).textTheme.caption!.copyWith(color: Colors.grey),
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
                                    onPressed: (){},
                                    child:
                                    Text(
                                      'G',
                                      style:TextStyle(
                                        color: Colors.grey[500],
                                        fontSize: 25.0,
                                      ),
                                    ),
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
                                    onPressed: (){},
                                    child:
                                    Text(
                                      'f',
                                      style:TextStyle(
                                        color: Colors.blue,
                                        fontSize: 25.0,

                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20.0,),
                        Text(
                          'Email',
                          style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.white,fontSize: 20.0),
                        ),
                        SizedBox(height: 15.0,),
                        defaultFormField(
                          controller: emailController,
                          type: TextInputType.emailAddress,
                          validate: (value){},
                          label: "Email",
                          containerRadius: 10.0,
                          borderColor: Colors.pink,
                          focusBorderColor: Colors.pinkAccent,
                        ),
                        SizedBox(height: 20.0,),
                        Text(
                          'Password',
                          style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.white,fontSize: 20.0),
                        ),
                        SizedBox(height: 15.0,),
                        defaultFormField(
                          controller: passwordController,
                          type: TextInputType.visiblePassword,
                          validate: (value){},
                          isPassword: ShoppyLoginCubit.get(context).isPassword,
                          label: "Password",
                          containerRadius: 10.0,
                          borderColor: Colors.pink,
                          focusBorderColor: Colors.pinkAccent,
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
                          child: defaultButton(
                            onPressFunction: () {  },
                            text: 'LOGIN',
                            backgroundColor: Colors.pink,
                            radius: 15.0
                          ),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Don\'t have an account?',
                              style: TextStyle(color: Colors.white),

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
            );
          }
          ),
    );
  }
}
