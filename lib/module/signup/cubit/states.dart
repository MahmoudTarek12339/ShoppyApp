abstract class ShoppySignupStates{}
class ShoppySignupInitialState extends ShoppySignupStates{}
class ShoppySignupLoadingState extends ShoppySignupStates{}
class ShoppySignupSuccessState extends ShoppySignupStates{}
class ShoppySignupErrorState extends ShoppySignupStates{
  final String error;
  ShoppySignupErrorState(this.error);
}

class ShoppyCreateSuccessState extends ShoppySignupStates{
}
class ShoppyCreateErrorState extends ShoppySignupStates{
  final String error;
  ShoppyCreateErrorState(this.error);
}

class ShoppyChangePasswordVisibilityState extends ShoppySignupStates{}
