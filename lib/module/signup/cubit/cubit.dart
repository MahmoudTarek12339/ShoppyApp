import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoppy/module/signup/cubit/states.dart';

class ShoppySignupCubit extends Cubit<ShoppySignupStates>{
  ShoppySignupCubit() : super(ShoppySignupInitialState());

  static ShoppySignupCubit get(context)=>BlocProvider.of(context);
  bool isPassword=true;
  IconData icon=Icons.visibility_outlined;
  void changePasswordVisibility(){
    isPassword=!isPassword;
    icon=isPassword?Icons.visibility_outlined:Icons.visibility_off_outlined;
    emit(ShoppyChangePasswordVisibilityState());
  }
}