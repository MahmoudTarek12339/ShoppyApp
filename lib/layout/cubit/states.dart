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

class ShoppyUpdateFavoriteState extends ShoppyStates{}

class ShoppyGetFavoriteSuccessState extends ShoppyStates{}
class ShoppyGetFavoriteErrorState extends ShoppyStates{
  final String error;
  ShoppyGetFavoriteErrorState(this.error);
}

class ShoppyAddToFavoriteSuccessState extends ShoppyStates{}
class ShoppyAddToFavoriteErrorState extends ShoppyStates{
  final String error;
  ShoppyAddToFavoriteErrorState(this.error);
}

class ShoppyRemoveFromFavoriteSuccessState extends ShoppyStates{}
class ShoppyRemoveFromFavoriteErrorState extends ShoppyStates{
  final String error;
  ShoppyRemoveFromFavoriteErrorState(this.error);
}



class ShoppyGetAllProductsSuccessState extends ShoppyStates{}
class ShoppyGetAllProductsErrorState extends ShoppyStates{
  final String error;
  ShoppyGetAllProductsErrorState(this.error);
}


class ShoppyUpdateCartState extends ShoppyStates{}
