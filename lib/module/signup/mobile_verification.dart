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
  List<String> dropDownList=['+1','+2','+3','+4','+20'];
  String dropdownValue='+20';
  GlobalKey<FormState> formKey=GlobalKey<FormState>();
  late UserModel myUser;
  _MobileVerificationScreenState(UserModel user){
    myUser=user;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  controller: numberController,
                  validator: (value){
                    if(value!.isEmpty){
                      return 'please enter your phone number';
                    }
                    else if(value.length<11){
                      return 'this phone number is invalid';
                    }
                  },
                  keyboardType: TextInputType.phone,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    hintText:'0123456789',
                    hintStyle: TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0),borderSide: BorderSide(
                      color: Theme.of(context).backgroundColor,
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
                    prefixIcon:Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: DropdownButton<String>(
                        value: dropdownValue,
                        icon: Icon(Icons.arrow_drop_down),
                        style: TextStyle(color: Colors.grey, fontSize: 18),
                        onChanged: (String? data){
                          setState(() {
                            dropdownValue = data.toString();
                          });
                        },
                        items: dropDownList.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 45.0,),
              defaultButton(
                context: context,
                onPressFunction: (){
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
