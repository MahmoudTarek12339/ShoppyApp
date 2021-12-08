import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoppy/model/user_model.dart';
import 'package:shoppy/module/signup/cubit/cubit.dart';
import 'package:shoppy/module/signup/cubit/states.dart';
import 'package:shoppy/module/signup/image_picker.dart';
import 'package:shoppy/shared/components/components.dart';
import 'package:shoppy/shared/network/local/cache_helper.dart';

class CodeVerificationScreen extends StatelessWidget {
  final UserModel myUser;
  CodeVerificationScreen(this.myUser);

  final TextEditingController firstDigitController = TextEditingController();
  final TextEditingController secondDigitController = TextEditingController();
  final TextEditingController thirdDigitController = TextEditingController();
  final TextEditingController forthDigitController = TextEditingController();
  final TextEditingController fifthDigitController = TextEditingController();
  final TextEditingController sixthDigitController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
    create: (BuildContext context) =>ShoppySignupCubit()..verifyPhone(myUser.phone!),
      child: BlocConsumer<ShoppySignupCubit,ShoppySignupStates>(
        listener: (context,state){
          if(state is ShoppyCreateSuccessState){
            CacheHelper.saveData(
                key: 'uId',
                value: state.uId).then((value) {
              navigateAndFinish(context, ImagePickingScreen());
            });
          }
          if(state is ShoppyCreateErrorState){
            showToast(
                message: state.error,
                state: ToastState.ERROR);
          }
        },
        builder: (context,state){
          return Scaffold(
            body:Padding(
              padding: EdgeInsets.symmetric(vertical: 24, horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Verification',
                    style: Theme
                        .of(context)
                        .textTheme
                        .subtitle2,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Enter your Verification code number",
                    style: Theme
                        .of(context)
                        .textTheme
                        .headline1,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 28,
                  ),
                  Container(
                    padding: EdgeInsets.all(18),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.black12)
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: _textFieldOTP(
                                  context: context,
                                  first: true,
                                  last: false,
                                  controller: firstDigitController,
                                )
                            ),
                            SizedBox(width: 1.0,),
                            Expanded(
                                child: _textFieldOTP(
                                  context: context,
                                  first: false,
                                  last: false,
                                  controller: secondDigitController,
                                )
                            ),
                            SizedBox(width: 1.0,),
                            Expanded(
                                child: _textFieldOTP(
                                  context: context,
                                  first: false,
                                  last: false,
                                  controller: thirdDigitController,
                                )
                            ),
                            SizedBox(width: 1.0,),
                            Expanded(
                                child: _textFieldOTP(
                                  context: context,
                                  first: false,
                                  last: false,
                                  controller: forthDigitController,
                                )
                            ),
                            SizedBox(width: 1.0,),
                            Expanded(
                                child: _textFieldOTP(
                                  context: context,
                                  first: false,
                                  last: false,
                                  controller: fifthDigitController,
                                )
                            ),
                            SizedBox(width: 1.0,),
                            Expanded(
                                child: _textFieldOTP(
                                  context: context,
                                  first: false,
                                  last: true,
                                  controller: sixthDigitController,
                                )
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 22,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async{
                              String verificationCode = firstDigitController.text +
                                  secondDigitController.text +
                                  thirdDigitController.text +
                                  forthDigitController.text+
                                  fifthDigitController.text +
                                  sixthDigitController.text;
                              ShoppySignupCubit.get(context).userRegister(
                                  name: myUser.name??'123',
                                  email: myUser.email??'123',
                                  password: myUser.password??'123',
                                  phone: myUser.phone??'123',
                                  sms: verificationCode
                              );
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Theme
                                  .of(context)
                                  .buttonColor),
                              shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24.0),
                                ),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(14.0),
                              child: Text(
                                'Verify',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  Text(
                    "Didn't you receive any code?",
                    style: Theme
                        .of(context)
                        .textTheme
                        .headline1,
                    textAlign: TextAlign.center,
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "Resend New Code",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  Widget _textFieldOTP({bool? first, last, controller,required context}) {
    return Container(
      height: 85,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: TextField(
          autofocus: true,
          controller: controller,
          onTap: () {},
          onChanged: (value) async{
            if (value.length == 1 && last == false) {
              FocusScope.of(context).nextFocus();
            }
            if (value.length == 0 && first == false) {
              FocusScope.of(context).previousFocus();
            }
            if (value.length == 1 && last == true) {
              String verificationCode = firstDigitController.text +
                  secondDigitController.text + thirdDigitController.text +
                  forthDigitController.text + fifthDigitController.text +
                  sixthDigitController.text;
              ShoppySignupCubit.get(context).userRegister(
                name: myUser.name??'123',
                email: myUser.email??'123',
                password: myUser.password??'123',
                phone: myUser.phone??'123',
                sms: verificationCode
              );
            }
          },
          showCursor: false,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme
                .of(context)
                .primaryColor,
          ),
          keyboardType: TextInputType.number,
          maxLength: 1,
          decoration: InputDecoration(
            hintText: '*',
            counter: Offstage(),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: Colors.black87),
                borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: Colors.blue),
                borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
    );
  }
}
