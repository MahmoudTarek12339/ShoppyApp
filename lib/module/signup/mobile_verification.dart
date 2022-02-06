import 'package:flutter/material.dart';
import 'package:shoppy/model/user_model.dart';
import 'package:shoppy/module/signup/code_verification.dart';
import 'package:shoppy/shared/components/components.dart';

class MobileVerificationScreen extends StatefulWidget {
  late final UserModel myUser;
  MobileVerificationScreen(UserModel user) {
    myUser=user;
  }
  @override
  _MobileVerificationScreenState createState() => _MobileVerificationScreenState(myUser);
}

class _MobileVerificationScreenState extends State<MobileVerificationScreen> {
  final TextEditingController numberController=TextEditingController();
  GlobalKey<FormState> formKey=GlobalKey<FormState>();
  late UserModel myUser;
  _MobileVerificationScreenState(UserModel user){
    myUser=user;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key:formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mobile Number',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              SizedBox(height: 50.0,),
              Text(
                'Please enter your Mobile phone Number',
                style: Theme.of(context).textTheme.bodyText2
              ),
              SizedBox(height: 15.0,),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: TextFormField(
                  style: TextStyle(color: Theme.of(context).textTheme.bodyText1!.color),
                  decoration: InputDecoration(
                    fillColor: Theme.of(context).primaryColor,
                    hintText:'0123456789',
                    hintStyle: TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0),borderSide: BorderSide(
                      color: Theme.of(context).focusColor,
                    )),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0),borderSide: BorderSide(
                      color: Theme.of(context).focusColor,
                    )),
                    errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0),borderSide: BorderSide(
                      color: Theme.of(context).errorColor,
                    )),
                    focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0),borderSide: BorderSide(
                      color: Theme.of(context).errorColor,
                    )),
                  ),
                ),
              ),
              SizedBox(height: 45.0,),
              defaultButton(
                context: context,
                onPressFunction: ()async{
                  if(formKey.currentState!.validate()){
                    myUser.phone=numberController.text;
                    navigateTo(context,CodeVerificationScreen(myUser));
                  }
                },
                text: 'Send Code',
              ),
            ],
          ),
        ),
      ),

    );
  }
}
