import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shoppy/layout/cubit/states.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:shoppy/model/order_model.dart';
import 'package:shoppy/model/product_model.dart';
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

  //reset password
  Future<bool> validatePassword({required String currentPassword})async{
    var fireBaseUser= FirebaseAuth.instance.currentUser;
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


  //Add Product To Cart
  List<OrderModel> cart=[];
  double cartTotal=0;

  void addProductToCart(OrderModel orderModel){
    if(cart.where((element) => element.productUid==orderModel.productUid&& element.color==orderModel.color&& element.size==orderModel.size).isNotEmpty) {
      cart[cart.indexWhere((element) => element.productUid==orderModel.productUid&& element.color==orderModel.color&& element.size==orderModel.size)].quantity+=1;
      cartTotal+=orderModel.price;
      print('increased');
      print(cart[cart.indexWhere((element) => element.productUid==orderModel.productUid&& element.color==orderModel.color&& element.size==orderModel.size)].quantity);
    }
    else{
      cart.add(orderModel);
      cartTotal+=orderModel.price;
      print('added');
    }
    emit(ShoppyUpdateCartState());
  }

  void removeProductFromCart(OrderModel orderModel){
    int quantity=cart[cart.indexWhere((element) => element.productUid==orderModel.productUid&& element.color==orderModel.color&& element.size==orderModel.size)].quantity;
    if(quantity>1){
      cart[cart.indexWhere((element) => element.productUid==orderModel.productUid&& element.color==orderModel.color&& element.size==orderModel.size)].quantity-=1;
      print('decreased');
    }
    else{
      cart.removeWhere((element) => element.productUid==orderModel.productUid&& element.color==orderModel.color&& element.size==orderModel.size);
      print('removed');
    }
    cartTotal-=orderModel.price;
    emit(ShoppyUpdateCartState());
  }

  void removeOneProductFromCart(OrderModel orderModel){
    cartTotal-=orderModel.price*orderModel.quantity;
    cart.removeWhere((element) => element.productUid==orderModel.productUid&& element.color==orderModel.color&& element.size==orderModel.size);
    print('removed');
    emit(ShoppyUpdateCartState());
  }
  void clearCart(){
    cartTotal=0;
    cart.clear();
    emit(ShoppyUpdateCartState());
  }
  //Add Product To Wish List
  List<String> favorites=[''];
  void updateWishList({required String productUid})async{
    final snapShot = await FirebaseFirestore.instance.collection('customers').doc(FirebaseAuth.instance.currentUser!.uid).collection('favorites').doc(productUid).get();
    if(snapShot.exists){
      favorites.remove(productUid);
      emit(ShoppyUpdateFavoriteState());
      FirebaseFirestore.instance.collection('customers').doc(FirebaseAuth.instance.currentUser!.uid).collection('favorites')..doc(productUid).delete().then((value) {
        emit(ShoppyRemoveFromFavoriteSuccessState());
      }).catchError((error){
        print(error.toString());
        emit(ShoppyRemoveFromFavoriteErrorState(error.toString()));
      });
    }
    else {
      favorites.add(productUid);
      emit(ShoppyUpdateFavoriteState());
      FirebaseFirestore.instance.collection('customers').doc(FirebaseAuth.instance.currentUser!.uid).collection('favorites').doc(productUid).set({'isFavorite':true}).then((value) {
        emit(ShoppyAddToFavoriteSuccessState());
      }).catchError((error){
        print(error.toString());
        emit(ShoppyAddToFavoriteErrorState(error.toString()));
      });
    }
    getFavorites();
  }

  //Map<String,List<String>> randValue={'numbers':['1','2','3']};
  void getFavorites(){
    FirebaseFirestore.instance.collection('customers').doc(FirebaseAuth.instance.currentUser!.uid).collection('favorites').get().then((value) {
      favorites.clear();
      value.docs.forEach((element) {
        favorites.add(element.id);
        emit(ShoppyGetFavoriteSuccessState());
      });
    }).catchError((onError){
      emit(ShoppyGetFavoriteErrorState(onError.toString()));
    });
  }

  //get All products From fire Base
  List<ProductModel> products=[];
  void getAllProducts()async{

    if (products.isEmpty) {
      await FirebaseFirestore.instance
          .collection('admins')
          .get()
          .then((value) {
            value.docs.forEach((element) {
              FirebaseFirestore.instance
                  .collection('admins')
                  .doc(element.id)
                  .collection('products')
                  .get().then((value) {
                value.docs.forEach((element2) {
                  if(element2.data().isNotEmpty)
                    products.add(ProductModel.fromJson(element2.data(), element2.id));
                });
              });
            });
            print('This is products:');
            print(products.length);
            emit(ShoppyGetAllProductsSuccessState());
      }).catchError((onError){
        emit(ShoppyGetAllProductsErrorState(onError.toString()));
      });
    }
  }
}