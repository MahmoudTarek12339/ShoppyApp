import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shoppy/module/login/cubit/states.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

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

  GoogleSignInAccount? myGoogleUser;
  Future signInWithGoogle() async {
    emit(ShoppyGoogleLoginLoadingState());
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if(googleUser==null){
      emit(ShoppyGoogleLoginErrorState('no account selected'));
      return;
    }
    myGoogleUser=googleUser;

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential).then(
      (value) {
        emit(ShoppyGoogleLoginSuccessState(value.user!.uid));
      }
    ).catchError((onError){
      print(onError.toString());
      emit(ShoppyGoogleLoginErrorState(onError.toString()));
    });
  }
  
  late var faceBookUserData;
  signInWithFacebook() async {
    emit(ShoppyFaceBookLoginLoadingState());
    // Trigger the sign-in flow
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();
      final userData=await FacebookAuth.instance.getUserData();
      faceBookUserData=userData;
      // Create a credential from the access token
      final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);

      // Once signed in, return the UserCredential
      FirebaseAuth.instance.signInWithCredential(facebookAuthCredential).then((value){
        emit(ShoppyFaceBookLoginSuccessState(value.user!.uid));
      }).catchError((onError){
        emit(ShoppyFaceBookLoginErrorState(onError.toString()));
      });
    } on Exception catch (e) {
      emit(ShoppyFaceBookLoginErrorState(e.toString()));
      print(e.toString());
    }
  }

  bool isPassword=true;
  IconData icon=Icons.visibility_outlined;
  void changePasswordVisibility(){
    isPassword=!isPassword;
    icon=isPassword?Icons.visibility_outlined:Icons.visibility_off_outlined;
    emit(ShoppyChangePasswordVisibilityState());
  }
}