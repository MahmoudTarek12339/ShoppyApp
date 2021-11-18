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


