import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoppy/module/login/login_screen.dart';
import 'package:shoppy/shared/components/components.dart';

import 'cubit/cubit.dart';
import 'cubit/states.dart';

class SignupScreen extends StatelessWidget {
  final TextEditingController emailController=TextEditingController();
  final TextEditingController passwordController=TextEditingController();
  final TextEditingController numberController=TextEditingController();
  final TextEditingController firstNameController=TextEditingController();
  final TextEditingController lastNameController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context)=>ShoppySignupCubit(),
      child: BlocConsumer<ShoppySignupCubit,ShoppySignupStates>(
          listener: (context,state){

          },
          builder: (context,state){
            return Scaffold(
              backgroundColor: Colors.black,
              appBar: AppBar(
                backgroundColor: Colors.black,
                title: Text(
                  'Sign up',
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
                          'Sign up with one of The following Options',
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
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    'First Name',
                                    style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.white,fontSize: 15.0),
                                  ),
                                  SizedBox(height: 15.0,),
                                  defaultFormField(
                                    controller: firstNameController,
                                    type: TextInputType.name,
                                    validate: (value){},
                                    label: "First Name",
                                    containerRadius: 10.0,
                                    borderColor: Colors.pink,
                                  ),
                                ],
                              crossAxisAlignment: CrossAxisAlignment.start,
                              ),
                            ),
                            SizedBox(width: 20.0,),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Last Name',
                                    style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.white,fontSize: 15.0),
                                  ),
                                  SizedBox(height: 15.0,),
                                  defaultFormField(
                                    controller: lastNameController,
                                    type: TextInputType.name,
                                    validate: (value){},
                                    label: "Last Name",
                                    containerRadius: 10.0,
                                    borderColor: Colors.pink,


                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15.0,),
                        Text(
                          'Email',
                          style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.white,fontSize: 15.0),
                        ),
                        SizedBox(height: 15.0,),
                        defaultFormField(
                          controller: emailController,
                          type: TextInputType.emailAddress,
                          validate: (value){},
                          label: "Email",
                          containerRadius: 10.0,
                          borderColor: Colors.pink,


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
                          isPassword: ShoppySignupCubit.get(context).isPassword,
                          label: "Password",
                          containerRadius: 10.0,
                          borderColor: Colors.pink,
                          suffix: ShoppySignupCubit.get(context).icon,
                          suffixPressed: () {
                            ShoppySignupCubit.get(context).changePasswordVisibility();
                          },
                        ),

                        SizedBox(
                          height: 25.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: defaultButton(
                              onPressFunction: () {  },
                              text: 'Create Account',
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
                              'already have account!',
                              style: TextStyle(color: Colors.white),

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
            );
          }
      ),
    );
  }
}
