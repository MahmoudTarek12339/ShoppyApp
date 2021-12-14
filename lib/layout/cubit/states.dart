abstract class ShoppyStates{}

class ShoppyInitialState extends ShoppyStates{}
class SocialChangeBottomNavState extends ShoppyStates{}
class SocialReScreenState extends ShoppyStates{}

class ProfileImagePickedSuccessState extends ShoppyStates{}
class ProfileImagePickedErrorState extends ShoppyStates{}
class UserLoggedOutSuccessState extends ShoppyStates{}
class ShoppyChangePasswordVisibilityState extends ShoppyStates{}
class ShoppyChangePasswordLoadingState extends ShoppyStates{}
class ShoppyChangePasswordSuccessState extends ShoppyStates{}
class ShoppyChangePasswordErrorState extends ShoppyStates{
  final String error;
  ShoppyChangePasswordErrorState(this.error);
}
class ShoppyChangeNameLoadingState extends ShoppyStates{}

class ShoppyChangeNameSuccessState extends ShoppyStates{}
class ShoppyChangeNameErrorState extends ShoppyStates{
  final String error;
  ShoppyChangeNameErrorState(this.error);
}
class ShoppyVerifyPasswordSuccessState extends ShoppyStates{}

class ShoppyVerifyPasswordErrorState extends ShoppyStates{
  final String error;
  ShoppyVerifyPasswordErrorState(this.error);
}

class SocialUploadProfileImageLoadingState extends ShoppyStates{}
class SocialUploadProfileImageSuccessState extends ShoppyStates{}
class SocialUploadProfileImageErrorState extends ShoppyStates{
  final String error;
  SocialUploadProfileImageErrorState(this.error);
}
