//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:shoppy/model/user_model.dart';
import 'package:shoppy/module/signup/cubit/states.dart';

class ShoppySignupCubit extends Cubit<ShoppySignupStates>{
  ShoppySignupCubit() : super(ShoppySignupInitialState());

  static ShoppySignupCubit get(context)=>BlocProvider.of(context);

/*  void userRegister({
    required String name,
    required String email,
    required String password,
  }){
    emit(ShoppySignupLoadingState());
    FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password).then((value) {
      userCreate(name: name, email: email, phone: '', uId: value.user!.uid);
    }).catchError((error){
      print(error.toString());
      emit(ShoppySignupErrorState(error.toString()));
    });
  }

  void userCreate({
    required String name,
    required String email,
    required String phone,
    String image='https://image.freepik.com/free-photo/young-attractive-woman-smiling-feeling-healthy-hair-flying-wind_176420-37515.jpg',
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
      emit(ShoppyCreateSuccessState());
    }).catchError((error){
      print(error.toString());
      emit(ShoppyCreateErrorState(error.toString()));
    });
  }
*/
  bool isPassword=true;
  IconData icon=Icons.visibility_outlined;
  void changePasswordVisibility(){
    isPassword=!isPassword;
    icon=isPassword?Icons.visibility_outlined:Icons.visibility_off_outlined;
    emit(ShoppyChangePasswordVisibilityState());
  }
}