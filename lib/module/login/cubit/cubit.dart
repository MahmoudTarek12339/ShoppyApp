import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoppy/module/login/cubit/states.dart';

class ShoppyLoginCubit extends Cubit<ShoppyLoginStates>{
  ShoppyLoginCubit() : super(ShoppyLoginInitialState());

  static ShoppyLoginCubit get(context)=>BlocProvider.of(context);
  void userLogin({
    required String email,
    required String password,
  }){
    emit(ShoppyLoginLoadingState());
    FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password).then((value) {
      emit(ShoppyLoginSuccessState(value.user!.uid));
    }).catchError((error){
      print(error.toString());
      emit(ShoppyLoginErrorState(error.toString()));
    });
  }

  bool isPassword=true;
  IconData icon=Icons.visibility_outlined;
  void changePasswordVisibility(){
    isPassword=!isPassword;
    icon=isPassword?Icons.visibility_outlined:Icons.visibility_off_outlined;
    emit(ShoppyChangePasswordVisibilityState());
  }
}