import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoppy/model/user_model.dart';
import 'package:shoppy/module/signup/cubit/states.dart';

class ShoppySignupCubit extends Cubit<ShoppySignupStates>{
  ShoppySignupCubit() : super(ShoppySignupInitialState());

  static ShoppySignupCubit get(context)=>BlocProvider.of(context);

  void userRegister({
    required String name,
    required String email,
    required String password,
    required String phone,

  }){
    emit(ShoppySignupLoadingState());
    FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password).then((value) {
      userCreate(name: name, email: email, phone: phone, uId: value.user!.uid);
    }).catchError((error){
      print(error.toString());
      emit(ShoppySignupErrorState(error.toString()));
    });
  }

  void userCreate({
    required String name,
    required String email,
    required String phone,
    String image='https://i.pinimg.com/564x/47/ba/71/47ba71f457434319819ac4a7cbd9988e.jpg',
    required String uId,
  }){
    UserModel model=UserModel(
        name: name,
        email: email,
        phone:phone,
        uId: uId,
        image: image,
        );
    FirebaseFirestore.instance.collection('customers').doc(uId).set(model.toMap()).then((value) {
      emit(ShoppyCreateSuccessState(uId));
    }).catchError((error){
      emit(ShoppyCreateErrorState(error.toString()));
      print(error.toString());
    });
  }

  late String verificationCode;

  verifyPhone(String phoneNumber,)async{
    emit(ShoppyPhoneVerificationLoadingState());
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+20$phoneNumber',
      verificationCompleted: (PhoneAuthCredential credential)async{
        emit(ShoppyPhoneVerificationSuccessState());
      },
      verificationFailed: (FirebaseAuthException error){
        print(error.toString());
        emit(ShoppyPhoneVerificationErrorState(error.toString()));
      },
      codeSent: (String verificationId,int? resendToken){
        verificationCode=verificationId;
      },
      codeAutoRetrievalTimeout: (String verificationId){
        verificationCode=verificationId;
      },
      timeout:Duration(seconds: 60),
    );
  }
  bool isPassword=true;
  IconData icon=Icons.visibility_outlined;
  void changePasswordVisibility(){
    isPassword=!isPassword;
    icon=isPassword?Icons.visibility_outlined:Icons.visibility_off_outlined;
    emit(ShoppyChangePasswordVisibilityState());
  }
}