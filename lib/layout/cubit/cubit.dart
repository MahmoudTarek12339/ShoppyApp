import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shoppy/layout/cubit/states.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ShoppyCubit extends Cubit<ShoppyStates> {
  ShoppyCubit() : super(ShoppyInitialState());
  static ShoppyCubit get(context) => BlocProvider.of(context);
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

}