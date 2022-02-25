import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shoppy/layout/cubit/states.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:shoppy/model/address_model.dart';
import 'package:shoppy/model/order_model.dart';
import 'package:shoppy/model/product_model.dart';
import 'package:shoppy/model/user_orders_model.dart';
import 'package:shoppy/module/home/bottom_nav/category/category_screen.dart';
import 'package:shoppy/module/home/bottom_nav/help_screen.dart';
import 'package:shoppy/module/home/bottom_nav/home/home_screen.dart';
import 'package:shoppy/module/home/bottom_nav/wish_list_screen.dart';
import 'package:shoppy/shared/components/components.dart';
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
    'Info',
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

  Future<void> signOut()async{
    await FirebaseAuth.instance.signOut().then((value) {
      CacheHelper.removeData(key: 'token').then((value) {
          if(value){
            emit(UserLoggedOutSuccessState());
          }
        }).catchError((onError){
          emit(UserLoggedOutErrorState(onError.toString()));
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
    bool increase=false;

    if(cart.where((element) => element.productUid==orderModel.productUid&& element.color==orderModel.color&& element.size==orderModel.size).isNotEmpty) {
      int index=cart.indexWhere((element) => element.productUid==orderModel.productUid&& element.color==orderModel.color&& element.size==orderModel.size);
      cart[index].quantity+=1;
      cartTotal+=orderModel.price;
      increase=true;
    }
    else{
      cart.add(orderModel);
      cartTotal+=orderModel.price;
    }
    emit(ShoppyUpdateCartState());
    addProductToCartFB(orderModel,increase);
  }
  void removeProductFromCart(OrderModel orderModel){
    int quantity=cart[cart.indexWhere((element) => element.productUid==orderModel.productUid&& element.color==orderModel.color&& element.size==orderModel.size)].quantity;
    if(quantity>1){
      cart[cart.indexWhere((element) => element.productUid==orderModel.productUid&& element.color==orderModel.color&& element.size==orderModel.size)].quantity-=1;
      print('decreased');
      emit(ShoppyUpdateCartState());
      addProductToCartFB(orderModel, true);
    }
    else{
      cart.removeWhere((element) => element.productUid==orderModel.productUid&& element.color==orderModel.color&& element.size==orderModel.size);
      print('removed');
      emit(ShoppyUpdateCartState());
      removeOneProductFromCartFb(orderModel);
    }
    cartTotal-=orderModel.price;
  }
  void removeOneProductFromCart(OrderModel orderModel){
    cartTotal-=orderModel.price*orderModel.quantity;
    cart.removeWhere((element) => element.productUid==orderModel.productUid&& element.color==orderModel.color&& element.size==orderModel.size);
    print('removed');
    emit(ShoppyUpdateCartState());
    removeOneProductFromCartFb(orderModel);
  }
  void clearCart(){
    cartTotal=0;
    cart.clear();
    emit(ShoppyUpdateCartState());
    clearCartFB();
  }

  void addProductToCartFB(OrderModel orderModel,bool increase)async{
    if(FirebaseAuth.instance.currentUser!=null){
      int index=cart.indexWhere((element) => element.productUid==orderModel.productUid&& element.color==orderModel.color&& element.size==orderModel.size);

      if(increase){
        await FirebaseFirestore.instance
            .collection('customers')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('Cart')
            .doc(cart[index].cartId)
            .set(cart[index].toMap())
            .then((value) {
          emit(ShoppyAddToCartSuccessState());
        }).catchError((error) {
          print(error.toString());
          emit(ShoppyAddToCartErrorState(error.toString()));
        });
      }
      else{
        var doc = FirebaseFirestore.instance
            .collection('customers')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('Cart')
            .doc();
        cart[index].setUid(doc.id);
        doc.set(cart[index].toMap()).then((value) {
          emit(ShoppyAddToCartSuccessState());
        }).catchError((error) {
          print(error.toString());
          emit(ShoppyAddToCartErrorState(error.toString()));
        });
      }
    }
  }
  void removeOneProductFromCartFb(OrderModel orderModel)async{
    if(FirebaseAuth.instance.currentUser!=null) {
      await FirebaseFirestore.instance
          .collection('customers')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('Cart')
          .doc(orderModel.cartId)
          .delete()
          .then((value) {
            emit(ShoppyRemoveFromCartSuccessState());
          })
          .catchError((error){
        emit(ShoppyRemoveFromCartErrorState(error.toString()));
      }
      );

    }
  }
  void clearCartFB()async{
    if(FirebaseAuth.instance.currentUser!=null){
      await FirebaseFirestore.instance
          .collection('customers')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('Cart')
          .get()
          .then((value){
            value.docs.forEach((element) {
              element.reference.delete();
            });
            emit(ShoppyClearCartSuccessState());
          })
          .catchError((error){
              emit(ShoppyClearCartErrorState(error.toString()));
          }
      );
    }
  }
  void getCart()async {
    if (FirebaseAuth.instance.currentUser != null) {
      await FirebaseFirestore.instance
          .collection('customers')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('Cart')
          .get()
          .then((value) {
        value.docs.forEach((element) {
          cart.add(OrderModel.fromJson(element.data())..setUid(element.id));
          cartTotal+=element.data()['price']*element.data()['quantity'];
        });
        emit(ShoppyAddToCartSuccessState());
      })
          .catchError((error) {
        emit(ShoppyAddToCartErrorState(error.toString()));
      });
    }
  }

  //Add Product To Wish List
  List<String> favorites=[];
  void updateWishList({required String productUid})async{
    if(favorites.contains(productUid)){
      favorites.remove(productUid);
    }
    else{
      favorites.add(productUid);
    }
    emit(ShoppyUpdateFavoriteState());
    updateWishListFB(productUid: productUid);
  }
  void updateWishListFB({required String productUid})async{
    if(FirebaseAuth.instance.currentUser!=null){
      final snapShot = await FirebaseFirestore.instance
          .collection('customers')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('favorites')
          .doc(productUid)
          .get();
      if (snapShot.exists) {
        FirebaseFirestore.instance
            .collection('customers')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('favorites')
            .doc(productUid)
            .delete()
            .then((value) {
          emit(ShoppyRemoveFromFavoriteSuccessState());
        }).catchError((error) {
          print(error.toString());
          emit(ShoppyRemoveFromFavoriteErrorState(error.toString()));
        });
      }
      else {
        FirebaseFirestore.instance
            .collection('customers')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('favorites')
            .doc(productUid)
            .set({'isFavorite': true}).then((value) {
          emit(ShoppyAddToFavoriteSuccessState());
        }).catchError((error) {
          print(error.toString());
          emit(ShoppyAddToFavoriteErrorState(error.toString()));
        });
      }
    }
  }
  void getFavorites(){
    if(FirebaseAuth.instance.currentUser!=null){
      favorites.clear();
      FirebaseFirestore.instance.collection('customers')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('favorites')
          .get()
          .then((value) {
        value.docs.forEach((element) {
          favorites.add(element.id);
        });
        emit(ShoppyGetFavoriteSuccessState());
      }).catchError((onError){
        print(onError);
        emit(ShoppyGetFavoriteErrorState(onError.toString()));
      });
    }
  }

  List<ProductModel> searchList=[];
  void addSearchToList(String searchName){
    searchName=searchName.toLowerCase();
    searchList=products.where((value) {
      String searchTitle=value.productName.toLowerCase();
      return searchTitle.contains(searchName);
    }).toList();
    emit(ShoppyUpdateSearchState());
  }
  void clearSearch(){
    searchList.clear();
    emit(ShoppyUpdateSearchState());
  }

  //get All products From fire Base
  List<ProductModel> products=[];
  Future getAllProducts()async{
    products.clear();
    await FirebaseFirestore.instance
        .collection('admins')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        String brandName =element.data()['brandName'];
        String brandId = element.id;
        FirebaseFirestore.instance
            .collection('admins')
            .doc(element.id)
            .collection('products')
            .get().then((value) {
          value.docs.forEach((element2) {
            if(element2.data().isNotEmpty)
              products.add(ProductModel.fromJson(element2.data(), element2.id,brandName,brandId));
          });
        });
      });
      emit(ShoppyGetAllProductsSuccessState());
    }).catchError((onError){
      emit(ShoppyGetAllProductsErrorState(onError.toString()));
    });
  }

  //get user orders

  List<UserOrderModel> userOrders=[];
  void getUserOrders(){
    if(FirebaseAuth.instance.currentUser!=null){
      FirebaseFirestore.instance
          .collection('customers')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('orders')
          .get()
          .then((value) {
        userOrders.clear();
        value.docs.forEach((element) {
          userOrders.add(UserOrderModel.fromJson(element.data(),element.id));
        });
        emit(ShoppyGetOrdersSuccessState());
        print('User Order Length :');
        print(userOrders.length);
      }).catchError((error){
        emit(ShoppyGetOrdersErrorState(error.toString()));
        print(error.toString());
      });
    }
  }

  //send order to firebase
  void sendOrder(UserOrderModel userOrderModel){
    emit(ShoppySendOrderLoadingState());
    var date=DateTime.now().microsecondsSinceEpoch.toString();
    Set brandSet=userOrderModel.orders.map((e) => e.brandId).toSet();

    brandSet.forEach((element) {
      var ord=userOrderModel.orders.where((e) => e.brandId==element).toList();
      UserOrderModel orderModel=UserOrderModel(
          orderState: userOrderModel.orderState,
          orderDate: userOrderModel.orderDate,
          orderPhoto: ord[0].photo,
          orderPrice: userOrderModel.orderPrice,
          orders: ord,
          addressModel: userOrderModel.addressModel,
      );
      orderModel.setBrandId(date);
      var doc=FirebaseFirestore.instance
          .collection('customers')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('orders')
          .doc();
      orderModel.setUserOrderId(doc.id);
      doc.set(orderModel.toMap()).then((value) {
        FirebaseFirestore.instance
            .collection('admins')
            .doc(element)
            .collection('orders')
            .doc('orders')
            .collection('In Progress')
            .doc(date)
            .set(orderModel.toMap()).then((value){
          userOrders.add(orderModel);
          emit(ShoppySendOrderSuccessState());
        }).catchError((error){
          emit(ShoppySendOrderErrorState(error.toString()));
          print(error);
        });
      }).catchError((error){
        emit(ShoppySendOrderErrorState(error.toString()));
        print(error);
      });
    });
    /*FirebaseFirestore.instance
        .collection('customers')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('orders')
        .doc()
        .set(userOrderModel.toMap()).then((value) {
          List<OrderModel> modelOrders=userOrderModel.orders;
          String bId=userOrderModel.orders[0].brandId;
          List<OrderModel> orders=[];
          orders.add(userOrderModel.orders[0]);
          for(int i=1;i<modelOrders.length;i++){
            if(bId==modelOrders[i].brandId){
              orders.add(userOrderModel.orders[i]);
              continue;
            }
            else{

              FirebaseFirestore.instance
                  .collection('admins')
                  .doc(bId)
                  .collection('orders')
                  .doc('orders')
                  .collection('In Progress')
                  .doc(date)
                  .set(element.toMap()).then((value){
                emit(ShoppySendOrderSuccessState());
              }).catchError((error){
                emit(ShoppySendOrderErrorState(error.toString()));
                print(error);
              });
            }
          }
    }).catchError((error){
      emit(ShoppySendOrderErrorState(error.toString()));
      print(error);
    });*/
  }

  void cancelOrder(UserOrderModel userOrderModel){
    String brandId= userOrderModel.orders[0].brandId;
    userOrders.removeWhere((element) => element.userOrderId==userOrderModel.userOrderId);
    emit(ShoppyUpdateOrdersState());
    //remove order from customer fireBase
    FirebaseFirestore.instance
        .collection('customers')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('orders')
        .doc(userOrderModel.userOrderId)
        .delete()
        .then((value){
      //remove order from admin fireBase
        FirebaseFirestore.instance
          .collection('admins')
          .doc(brandId)
          .collection('orders')
          .doc('orders')
          .collection('In Progress')
          .doc(userOrderModel.orderId)
          .delete()
          .then((value) {
            emit(ShoppyRemoveFromOrdersSuccessState());
          }).catchError((error){
            emit(ShoppyRemoveFromOrdersErrorState(error.toString()));
            print(error);
          });
    }).catchError((error){
      emit(ShoppyRemoveFromOrdersErrorState(error.toString()));
      print(error);
    });
  }

  List<AddressModel> userAddresses=[];
  void addAddress(AddressModel addressModel){

    var doc= FirebaseFirestore.instance.collection('customers').doc(FirebaseAuth.instance.currentUser!.uid).collection('addresses').doc();
    addressModel.setId(doc.id);
    userAddresses.add(addressModel);
    emit(ShoppyAddToAddressesLoadingState());

    doc.set(addressModel.toMap()).then((value) {
      emit(ShoppyAddToAddressesSuccessState());
    }).catchError((error){
      print(error.toString());
      emit(ShoppyAddToAddressesErrorState(error.toString()));
    });
  }
  void removeAddress(String uID){
    userAddresses.removeWhere((element) => element.uId==uID);
    emit(ShoppyUpdateAddressesState());
    FirebaseFirestore.instance.collection('customers').doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('addresses')
        .doc(uID)
        .delete()
        .then((value){
      emit(ShoppyRemoveFromAddressesSuccessState());
    }).catchError((error){
      emit(ShoppyRemoveFromAddressesErrorState(error.toString()));
    });
  }
  void getUserAddresses(){
    if(FirebaseAuth.instance.currentUser!=null){
      FirebaseFirestore.instance.collection('customers').doc(FirebaseAuth.instance.currentUser!.uid).collection('addresses').get().then((value) {
        userAddresses.clear();
        value.docs.forEach((element) {
          userAddresses.add(AddressModel.fromJson(element.data()));
          emit(ShoppyGetAddressesSuccessState());
        });
      }).catchError((onError){
        emit(ShoppyGetAddressesErrorState(onError.toString()));
      });
    }
  }

  int radioIndex=0;
  void changeIndex(int value){
    radioIndex=value;
    emit(ShoppyChangeRadioValueState());
  }

  //get user data
  void appStart({required context})async{
    bool connection =await checkInternetConnection();
    if(connection) {
      await getAllProducts();
      getFavorites();
      getUserAddresses();
      getUserOrders();
      getCart();
    }
    else{
      /*defaultSnackBar(
          context: context,
          title: 'Please Check Your Internet Connection',
          color: Colors.red,
      );*/
    }
  }

  //check internet connection
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