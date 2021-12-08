abstract class ShoppyStates{}

class ShoppyInitialState extends ShoppyStates{}
class SocialChangeBottomNavState extends ShoppyStates{}

class ProfileImagePickedSuccessState extends ShoppyStates{}
class ProfileImagePickedErrorState extends ShoppyStates{}

class SocialUploadProfileImageLoadingState extends ShoppyStates{}
class SocialUploadProfileImageSuccessState extends ShoppyStates{}
class SocialUploadProfileImageErrorState extends ShoppyStates{
  final String error;
  SocialUploadProfileImageErrorState(this.error);
}
