import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoppy/module/login/cubit/cubit.dart';
import 'package:shoppy/module/login/cubit/states.dart';
import 'package:shoppy/shared/components/components.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../shared/components/constants.dart';


class ForgetPasswordScreen extends StatelessWidget {
  final formKey=GlobalKey<FormState>();
  final TextEditingController emailController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context)=>ShoppyLoginCubit(),
      child: BlocConsumer<ShoppyLoginCubit,ShoppyLoginStates>(
          listener: (context,state){},
          builder:(context,state){
            return SafeArea(child: Scaffold(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              appBar: AppBar(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                title: Text(
                  'Forget Password',
                  style: TextStyle(
                    color: Theme.of(context).focusColor,
                  ),
                ),
                centerTitle: true,
                elevation: 0,
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color:Theme.of(context).canvasColor,
                  ),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                ),
              ),
              body: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal:20),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: Icon(
                              Icons.close_rounded,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'If you Want to Recover Your Account, then please provide your email Id Below..',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyText1!.color,
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Image.asset(
                          'assets/images/forgetpass copy.png',
                          width: 250,
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        defaultFormField(
                          controller: emailController,
                          type: TextInputType.text,
                          validate:  (value){
                            if(!RegExp(validationEmail).hasMatch(value!)){
                              return 'Enter Valid Email';
                            }
                            return null;
                          },
                          label: '${AppLocalizations.of(context)!.email}',
                          context: context,
                          prefix:Icons.search,
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        defaultButton(
                          text: '${AppLocalizations.of(context)!.send}',
                          onPressFunction: (){
                            if(formKey.currentState!.validate()){
                              String email=emailController.text.toString().trim();
                              ShoppyLoginCubit.get(context).resetPassword( email: email);
                            }
                          },
                          context: context,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ));
          }

      ),
    );
  }
}
