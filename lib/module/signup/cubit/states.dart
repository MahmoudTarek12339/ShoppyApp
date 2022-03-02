abstract class ShoppySignupStates{}
class ShoppySignupInitialState extends ShoppySignupStates{}
class ShoppySignupLoadingState extends ShoppySignupStates{}
class ShoppySignupSuccessState extends ShoppySignupStates{}
class ShoppySignupErrorState extends ShoppySignupStates{
  final String error;
  ShoppySignupErrorState(this.error);
}

class ShoppyPhoneVerificationLoadingState extends ShoppySignupStates{}
class ShoppyPhoneVerificationSuccessState extends ShoppySignupStates{}
class ShoppyPhoneVerificationErrorState extends ShoppySignupStates{
  final String error;
  ShoppyPhoneVerificationErrorState(this.error);
}


class ShoppyCreateSuccessState extends ShoppySignupStates{
  final String uId;
  ShoppyCreateSuccessState(this.uId);
}
class ShoppyCreateErrorState extends ShoppySignupStates{
  final String error;
  ShoppyCreateErrorState(this.error);
}

class ShoppyChangePasswordVisibilityState extends ShoppySignupStates{}

class ShoppyGoogleLoginLoadingState extends ShoppySignupStates{}
class ShoppyGoogleLoginSuccessState extends ShoppySignupStates{
  final String uId;
  ShoppyGoogleLoginSuccessState(this.uId);
}
class ShoppyGoogleLoginErrorState extends ShoppySignupStates{
  final String error;
  ShoppyGoogleLoginErrorState(this.error);
}

class ShoppyFaceBookLoginLoadingState extends ShoppySignupStates{}
class ShoppyFaceBookLoginSuccessState extends ShoppySignupStates{
  final String uId;
  ShoppyFaceBookLoginSuccessState(this.uId);
}
class ShoppyFaceBookLoginErrorState extends ShoppySignupStates{
  final String error;
  ShoppyFaceBookLoginErrorState(this.error);
}

class ShoppyInternetConnectedState extends ShoppySignupStates{}
class ShoppyInternetNotConnectedState extends ShoppySignupStates{}
