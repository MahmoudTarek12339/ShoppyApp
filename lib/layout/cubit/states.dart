abstract class ShoppyStates{}

class ShoppyInitialState extends ShoppyStates{}
class SocialChangeBottomNavState extends ShoppyStates{}
class SocialReScreenState extends ShoppyStates{}

class ProfileImagePickedSuccessState extends ShoppyStates{}
class ProfileImagePickedErrorState extends ShoppyStates{}

class UserLoggedOutSuccessState extends ShoppyStates{}
class UserLoggedOutErrorState extends ShoppyStates{
  final String error;
  UserLoggedOutErrorState(this.error);
}

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

class ShoppyUpdateSearchState extends ShoppyStates{}

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
class ShoppyGetBestSellerProductsSuccessState extends ShoppyStates{}


class ShoppyUpdateCartState extends ShoppyStates{}

class ShoppyAddToCartSuccessState extends ShoppyStates{}
class ShoppyAddToCartErrorState extends ShoppyStates{
  final String error;
  ShoppyAddToCartErrorState(this.error);
}
class ShoppyRemoveFromCartSuccessState extends ShoppyStates{}
class ShoppyRemoveFromCartErrorState extends ShoppyStates{
  final String error;
  ShoppyRemoveFromCartErrorState(this.error);
}
class ShoppyClearCartSuccessState extends ShoppyStates{}
class ShoppyClearCartErrorState extends ShoppyStates{
  final String error;
  ShoppyClearCartErrorState(this.error);
}


class ShoppyAddToAddressesLoadingState extends ShoppyStates{}

class ShoppyAddToAddressesSuccessState extends ShoppyStates{}
class ShoppyAddToAddressesErrorState extends ShoppyStates{
  final String error;
  ShoppyAddToAddressesErrorState(this.error);
}

class ShoppyGetAddressesSuccessState extends ShoppyStates{}
class ShoppyGetAddressesErrorState extends ShoppyStates{
  final String error;
  ShoppyGetAddressesErrorState(this.error);
}

class ShoppyUpdateAddressesState extends ShoppyStates{}

class ShoppyRemoveFromAddressesSuccessState extends ShoppyStates{}
class ShoppyRemoveFromAddressesErrorState extends ShoppyStates{
  final String error;
  ShoppyRemoveFromAddressesErrorState(this.error);
}

class ShoppyChangeRadioValueState extends ShoppyStates{}


class ShoppySendOrderLoadingState extends ShoppyStates{}
class ShoppySendOrderSuccessState extends ShoppyStates{}
class ShoppySendOrderErrorState extends ShoppyStates{
  final String error;
  ShoppySendOrderErrorState(this.error);
}

class ShoppyGetOrdersLoadingState extends ShoppyStates{}
class ShoppyGetOrdersSuccessState extends ShoppyStates{}
class ShoppyGetOrdersErrorState extends ShoppyStates{
  final String error;
  ShoppyGetOrdersErrorState(this.error);
}

class ShoppyUpdateOrdersState extends ShoppyStates{}

class ShoppyRemoveFromInProgressOrdersSuccessState extends ShoppyStates{}
class ShoppyRemoveFromInProgressOrdersErrorState extends ShoppyStates{
  final String error;
  ShoppyRemoveFromInProgressOrdersErrorState(this.error);
}
class ShoppyRemoveFromOrdersSuccessState extends ShoppyStates{}
class ShoppyRemoveFromOrdersErrorState extends ShoppyStates{
  final String error;
  ShoppyRemoveFromOrdersErrorState(this.error);
}
class ShoppyDeleteFromOrdersSuccessState extends ShoppyStates{}
class ShoppyDeleteFromOrdersErrorState extends ShoppyStates{
  final String error;
  ShoppyDeleteFromOrdersErrorState(this.error);
}
class ShoppyInternetConnectedState extends ShoppyStates{}
class ShoppyInternetNotConnectedState extends ShoppyStates{}

class ShoppyAppStartingState extends ShoppyStates{}
class ShoppyLoginFirstState extends ShoppyStates{}

class ShoppyGetBrandSuccessState extends ShoppyStates{}
class ShoppyGetBrandErrorState extends ShoppyStates{
  final String error;
  ShoppyGetBrandErrorState(this.error);
}
class ShoppyCheckOrdersSuccessState extends ShoppyStates{}
class ShoppyChangeVisibilityVirtualSuccessState extends ShoppyStates{}



class ShoppyUpdateForYouSuccessState extends ShoppyStates{}
class ShoppyUpdateForYouErrorState extends ShoppyStates{
  final String error;
  ShoppyUpdateForYouErrorState(this.error);
}

class ShoppyGetForYouSuccessState extends ShoppyStates{}
class ShoppyGetForYouErrorState extends ShoppyStates{
  final String error;
  ShoppyGetForYouErrorState(this.error);
}


class ShoppySendImagesLoadingState extends ShoppyStates{}
class ShoppySendImagesSuccessState extends ShoppyStates{}
class ShoppySendImagesErrorState extends ShoppyStates{
  final String error;
  ShoppySendImagesErrorState(this.error);
}

class ShoppySendSizesSuccessState extends ShoppyStates{}
class ShoppySendSizesErrorState extends ShoppyStates{
  final String error;
  ShoppySendSizesErrorState(this.error);
}

class ShoppyGetSizesSuccessState extends ShoppyStates{}
class ShoppyGetSizesErrorState extends ShoppyStates{
  final String error;
  ShoppyGetSizesErrorState(this.error);
}

class ShoppyCancelSizesSuccessState extends ShoppyStates{}

class ShoppyVirtualSelectionChangeState extends ShoppyStates{}

class ShoppySendVirtualLoadingState extends ShoppyStates{}
class ShoppyGetVirtualSuccessState extends ShoppyStates{}
class ShoppyGetVirtualErrorState extends ShoppyStates{
  final String error;
  ShoppyGetVirtualErrorState(this.error);
}
