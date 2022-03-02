import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:shoppy/module/login/cubit/states.dart';


class ShoppyLoginCubit extends Cubit<ShoppyLoginStates>{
  ShoppyLoginCubit() : super(ShoppyLoginInitialState());

  static ShoppyLoginCubit get(context)=>BlocProvider.of(context);
  void userLogin({
    required String email,
    required String password,
  })async{
    bool connected=await checkInternetConnection();
    if(connected){
      try {
        emit(ShoppyLoginLoadingState());
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password)
            .then((value) {
          emit(ShoppyLoginSuccessState(value.user!.uid));
        });
      } on FirebaseAuthException catch (e) {
        String message = '';
        if (e.code == 'user-not-found') {
          message = 'No user found for that email.';
        } else if (e.code == 'wrong-password') {
          message = 'Wrong password provided for that user.';
        } else {
          message = e.message.toString();
        }
        emit(ShoppyLoginErrorState(message));
      } catch (e) {
        emit(ShoppyLoginErrorState(e.toString()));
      }
    }
  }

  GoogleSignInAccount? myGoogleUser;
  Future signInWithGoogle() async {
    bool connected=await checkInternetConnection();
    if(connected){
      emit(ShoppyGoogleLoginLoadingState());
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        emit(ShoppyGoogleLoginErrorState('no account selected'));
        return;
      }
      myGoogleUser = googleUser;

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      await FirebaseAuth.instance
          .signInWithCredential(credential)
          .then((value) {
        emit(ShoppyGoogleLoginSuccessState(value.user!.uid));
      }).catchError((onError) {
        emit(ShoppyGoogleLoginErrorState(onError.toString()));
      });
    }
  }
  
  late var faceBookUserData;
  signInWithFacebook() async {
    bool connected=await checkInternetConnection();
    if(connected){
      emit(ShoppyFaceBookLoginLoadingState());
      // Trigger the sign-in flow
      try {
        final LoginResult loginResult = await FacebookAuth.instance.login();
        final userData = await FacebookAuth.instance.getUserData();
        faceBookUserData = userData;
        // Create a credential from the access token
        final OAuthCredential facebookAuthCredential =
            FacebookAuthProvider.credential(loginResult.accessToken!.token);

        // Once signed in, return the UserCredential
        FirebaseAuth.instance
            .signInWithCredential(facebookAuthCredential)
            .then((value) {
          emit(ShoppyFaceBookLoginSuccessState(value.user!.uid));
        }).catchError((onError) {
          emit(ShoppyFaceBookLoginErrorState(onError.toString()));
        });
      } on Exception catch (e) {
        emit(ShoppyFaceBookLoginErrorState(e.toString()));
      }
    }
  }

  void resetPassword({
    required String email
  })async{
    bool connected=await checkInternetConnection();
    if(connected) {
      try {
        await FirebaseAuth.instance
            .sendPasswordResetEmail(
              email: email,
            )
            .then((value) => emit(ShoppyResetPasswordSuccessState()));
      } on FirebaseAuthException catch (e) {
        String message = '';
        if (e.code == 'user-not-found') {
          message = 'No user found for that email.';
        } else {
          message = e.message.toString();
        }
        emit(ShoppyResetPasswordErrorState(message));
      } catch (e) {
        emit(ShoppyResetPasswordErrorState(e.toString()));
      }
    }
  }


  bool isPassword=true;
  IconData icon=Icons.visibility_outlined;
  void changePasswordVisibility(){
    isPassword=!isPassword;
    icon=isPassword?Icons.visibility_outlined:Icons.visibility_off_outlined;
    emit(ShoppyChangePasswordVisibilityState());
  }

  Future<bool> checkInternetConnection() async{
    final ConnectivityResult result = await Connectivity().checkConnectivity();
    bool res=(result == ConnectivityResult.wifi||result ==ConnectivityResult.mobile);
    if(res){
      emit(ShoppyInternetConnectedState());
    }
    else{
      emit(ShoppyInternetNotConnectedState());
    }
    return res;
  }
}