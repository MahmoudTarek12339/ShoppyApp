abstract class ShoppyLoginStates{}
class ShoppyLoginInitialState extends ShoppyLoginStates{}
class ShoppyChangePasswordVisibilityState extends ShoppyLoginStates{}

class ShoppyLoginLoadingState extends ShoppyLoginStates{}
class ShoppyLoginSuccessState extends ShoppyLoginStates{
  final String uId;
  ShoppyLoginSuccessState(this.uId);
}
class ShoppyLoginErrorState extends ShoppyLoginStates{
  final String error;
  ShoppyLoginErrorState(this.error);
}

class ShoppyGoogleLoginLoadingState extends ShoppyLoginStates{}
class ShoppyGoogleLoginSuccessState extends ShoppyLoginStates{
  final String uId;
  ShoppyGoogleLoginSuccessState(this.uId);
}
class ShoppyGoogleLoginErrorState extends ShoppyLoginStates{
  final String error;
  ShoppyGoogleLoginErrorState(this.error);
}

class ShoppyFaceBookLoginLoadingState extends ShoppyLoginStates{}
class ShoppyFaceBookLoginSuccessState extends ShoppyLoginStates{
  final String uId;
  ShoppyFaceBookLoginSuccessState(this.uId);
}
class ShoppyFaceBookLoginErrorState extends ShoppyLoginStates{
  final String error;
  ShoppyFaceBookLoginErrorState(this.error);
}

class ShoppyResetPasswordSuccessState extends ShoppyLoginStates{}
class ShoppyResetPasswordErrorState extends ShoppyLoginStates{
  final String error;
  ShoppyResetPasswordErrorState(this.error);
}

class ShoppyInternetConnectedState extends ShoppyLoginStates{}
class ShoppyInternetNotConnectedState extends ShoppyLoginStates{}
