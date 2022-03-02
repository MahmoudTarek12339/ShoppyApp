import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'states.dart';

class ShoppySignupCubit extends Cubit<ShoppySignupStates>{
  ShoppySignupCubit() : super(ShoppySignupInitialState());

  static ShoppySignupCubit get(context)=>BlocProvider.of(context);

  void userRegister({
    required String name,
    required String email,
    required String password,
    required String phone,
  })async{
    bool connected=await checkInternetConnection();
    if(connected){
      emit(ShoppySignupLoadingState());
      try {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) async {
          User? user = value.user;
          user!.updateDisplayName(name);
          user.updatePhotoURL(
              'https://image.freepik.com/free-photo/medium-shot-happy-man-smiling_23-2148221808.jpg');
          FirebaseFirestore.instance
              .collection('customers')
              .doc(user.uid)
              .set({'phone': phone}).then((value) {
            emit(ShoppyCreateSuccessState(user.uid));
          }).catchError((error) {
            print(error.toString());
            emit(ShoppySignupErrorState(error.toString()));
          });
          emit(ShoppyCreateSuccessState(user.uid));
        }).catchError((error) {
          print(error.toString());
          emit(ShoppySignupErrorState(error.toString()));
        });
      } catch (e) {
        print(e.toString());
        emit(ShoppySignupErrorState('invalid OTP${e.toString()}'));
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

  late String verificationCode;


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