import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoppy/layout/cubit/cubit.dart';
import 'package:shoppy/layout/cubit/states.dart';
import 'package:shoppy/shared/components/components.dart';

class ResetPasswordScreen extends StatelessWidget {
  final TextEditingController currentPasswordController=TextEditingController();
  final TextEditingController newPasswordController=TextEditingController();
  final TextEditingController confirmNewPasswordController=TextEditingController();
  final GlobalKey<FormState> formKey=GlobalKey<FormState>();
  bool validPass=true;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>ShoppyCubit(),
      child: BlocConsumer<ShoppyCubit,ShoppyStates>(
        listener: (context,state){
          if(state is ShoppyChangePasswordSuccessState){
            showToast(message: 'Password Chaged Successfully', state: ToastState.SUCCESS);
            Navigator.pop(context);
          }
          else if(state is ShoppyChangePasswordErrorState){
            showToast(
                message: state.error.toString(),
                state: ToastState.ERROR
            );
            Navigator.pop(context);
          }
          else if(state is ShoppyVerifyPasswordSuccessState){
            validPass=true;
            formKey.currentState!.validate();
          }
          else if(state is ShoppyVerifyPasswordErrorState){
            showToast(
                message: state.error.toString(),
                state: ToastState.ERROR
            );
            validPass=false;
            formKey.currentState!.validate();
          }
        },
        builder: (context,state){
          return Scaffold(
            appBar: AppBar(
              title: Text('Reset Password'),
            ),
            body: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Container(
                      child: defaultFormField(
                        onTap: (){
                          validPass=true;
                        },
                        context: context,
                        controller: currentPasswordController,
                        type: TextInputType.visiblePassword,
                        validate: (value){
                          if(value!.isEmpty){
                            return 'password mustn\'t be empty';
                          }
                          else if(!validPass){
                            return 'password is not true';
                          }
                          else if(value.length<8){
                            return 'password is too short';
                          }
                        },
                        isPassword: ShoppyCubit.get(context).isPassword,
                        label: "Current Password",
                        suffix: ShoppyCubit.get(context).icon,
                        suffixPressed: () {
                          ShoppyCubit.get(context).changePasswordVisibility(1);
                        },
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Container(
                      child: defaultFormField(
                        context: context,
                        controller: newPasswordController,
                        type: TextInputType.visiblePassword,
                        validate: (value){
                          if(value!.isEmpty){
                            return 'password mustn\'t be empty';
                          }
                          else if(value==currentPasswordController.text){
                            return 'new password cannot be same as old password';
                          }
                          else if(value.length<8){
                            return 'password is too short';
                          }
                        },
                        isPassword: ShoppyCubit.get(context).isPassword2,
                        label: "Password",
                        suffix: ShoppyCubit.get(context).icon2,
                        suffixPressed: () {
                          ShoppyCubit.get(context).changePasswordVisibility(2);
                        },
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Container(
                      child: defaultFormField(
                        context: context,
                        controller: confirmNewPasswordController,
                        type: TextInputType.visiblePassword,
                        validate: (value){
                          if(value!.isEmpty){
                            return 'password mustn\'t be empty';
                          }
                          else if(value!=currentPasswordController.text){
                            return 'not Match';
                          }
                          else if(value.length<8){
                            return 'password is too short';
                          }
                        },
                        isPassword: ShoppyCubit.get(context).isPassword3,
                        label: "Confirm new Password",
                        suffix: ShoppyCubit.get(context).icon3,
                        suffixPressed: () {
                          ShoppyCubit.get(context).changePasswordVisibility(3);
                        },
                      ),
                    ),
                    SizedBox(height: 15.0,),
                    Container(
                      height: 40.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Theme.of(context).buttonColor,
                      ),

                      child: MaterialButton(
                        onPressed: ()async{
                          if(formKey.currentState!.validate()&&
                              await ShoppyCubit.get(context).validatePassword(currentPassword: currentPasswordController.text.toString()))
                          {
                            ShoppyCubit.get(context).changePassword(password: newPasswordController.text);
                          }
                        },
                        clipBehavior: Clip.antiAlias,
                        child: state is ShoppyChangePasswordLoadingState?
                          Center(child: CircularProgressIndicator()):Text(
                              'Change Password',
                              style: TextStyle(
                                color: Theme.of(context).iconTheme.color,
                              ),)
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
