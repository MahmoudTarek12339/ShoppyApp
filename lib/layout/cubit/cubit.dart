import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shoppy/layout/cubit/states.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:shoppy/module/home/bottom_nav/category_screen.dart';
import 'package:shoppy/module/home/bottom_nav/help_screen.dart';
import 'package:shoppy/module/home/bottom_nav/home_screen.dart';
import 'package:shoppy/module/home/bottom_nav/wish_list_screen.dart';
import 'package:shoppy/shared/network/local/cache_helper.dart';

class ShoppyCubit extends Cubit<ShoppyStates> {
  ShoppyCubit() : super(ShoppyInitialState());
  static ShoppyCubit get(context) => BlocProvider.of(context);


  List<Widget> screens=[
    HomeScreen(),
    CategoriesScreen(),
    WishListScreen(),
    HelpScreen()
  ];
  List<String> titles=[
    'Home',
    'Categories',
    'Wish List',
    'help',
  ];
  int currentIndex=0;
  void changeBottomNav(int index){
    currentIndex=index;
    emit(SocialChangeBottomNavState());
  }
  File? profileImage;
  final picker = ImagePicker();
  Future getProfileImage()async{
    final pickedFile= await picker.getImage(source: ImageSource.gallery);
    if(pickedFile!=null){
      emit(ProfileImagePickedSuccessState());
      profileImage=File(pickedFile.path);
    }
    else{
      emit(ProfileImagePickedErrorState());
      print('No Image Selected.');
    }
  }

  uploadProfileImage(){
    emit(SocialUploadProfileImageLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('customers').child('customers${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!).then((value){
      value.ref.getDownloadURL().then((value) {
        print(value);
        FirebaseAuth.instance.currentUser!.updatePhotoURL(value).then((value){
          emit(SocialUploadProfileImageSuccessState());
        });
      }).catchError((error){
        emit(SocialUploadProfileImageErrorState(error.toString()));
        print(error.toString());
      });
    }).catchError((error){
      emit(SocialUploadProfileImageErrorState(error.toString()));
      print(error.toString());
    });
  }

  void signOut(){
    FirebaseAuth.instance.signOut().then((value) {
      CacheHelper.removeData(key: 'token').then((value) {
          if(value){
            emit(UserLoggedOutSuccessState());
          }
        });
      }
    );
  }
  bool isPassword=true;
  bool isPassword2=true;
  bool isPassword3=true;
  IconData icon=Icons.visibility_outlined;
  IconData icon2=Icons.visibility_outlined;
  IconData icon3=Icons.visibility_outlined;
  void changePasswordVisibility(int num){
    if(num==1) {
      isPassword=!isPassword;
      icon=isPassword?Icons.visibility_outlined:Icons.visibility_off_outlined;
    }
    else if(num==2) {
      isPassword2=!isPassword2;
      icon2=isPassword2?Icons.visibility_outlined:Icons.visibility_off_outlined;
    }
    else if(num==3) {
      isPassword3=!isPassword3;
      icon3=isPassword3?Icons.visibility_outlined:Icons.visibility_off_outlined;
    }
    emit(ShoppyChangePasswordVisibilityState());
  }

  Future<bool> validatePassword({required String currentPassword})async{
    var fireBaseUser=await FirebaseAuth.instance.currentUser;
    var authCredentials=EmailAuthProvider.credential(
        email: fireBaseUser!.email.toString(),
        password: currentPassword);
    try {
    var authResult =await fireBaseUser.reauthenticateWithCredential(authCredentials);
      emit(ShoppyVerifyPasswordSuccessState());
      return authResult.user!= null;
    } on Exception catch (e) {
        emit(ShoppyVerifyPasswordErrorState(e.toString()));
        print(e);
        return false;
    }
  }
  void changePassword({required String password}){
    emit(ShoppyChangePasswordLoadingState());
    FirebaseAuth.instance.currentUser!.updatePassword(password).then((value){
      emit(ShoppyChangePasswordSuccessState());
    }).catchError((error){
      emit(ShoppyChangePasswordErrorState(error.toString()));
      print(error.toString());
    });
  }
  void changeName({required String name}){
    if(name==FirebaseAuth.instance.currentUser!.displayName)
      emit(ShoppyChangeNameErrorState('New Name Mustn\'t be Same as old'));
    else {
      emit(ShoppyChangeNameLoadingState());
      FirebaseAuth.instance.currentUser!.updateDisplayName(name).then((value) {
        emit(ShoppyChangeNameSuccessState());
      }).catchError((error) {
        emit(ShoppyChangeNameErrorState(error.toString()));
        print(error.toString());
      });
    }
  }
}