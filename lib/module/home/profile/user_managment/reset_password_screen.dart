import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoppy/layout/cubit/cubit.dart';
import 'package:shoppy/layout/cubit/states.dart';
import 'package:shoppy/shared/components/components.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ResetPasswordScreen extends StatelessWidget {
  final TextEditingController currentPasswordController=TextEditingController();
  final TextEditingController newPasswordController=TextEditingController();
  final TextEditingController confirmNewPasswordController=TextEditingController();
  final GlobalKey<FormState> formKey=GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    bool validPass=true;

    return BlocProvider(
      create: (BuildContext context) =>ShoppyCubit(),
      child: BlocConsumer<ShoppyCubit,ShoppyStates>(
        listener: (context,state){
          if(state is ShoppyChangePasswordSuccessState){
            defaultSnackBar(
              context: context,
              color: Colors.green,
              title: '${AppLocalizations.of(context)!.passwordChangedSuccessfully}',
            );
            Navigator.pop(context);
          }
          else if(state is ShoppyChangePasswordErrorState){
            defaultSnackBar(
              context: context,
              color: Colors.red,
              title: state.error.toString(),
            );
            Navigator.pop(context);
          }
          else if(state is ShoppyVerifyPasswordSuccessState){
            validPass=true;
            formKey.currentState!.validate();
          }
          else if(state is ShoppyVerifyPasswordErrorState){
            defaultSnackBar(
              context: context,
              color: Colors.red,
              title: state.error.toString(),
            );
            validPass=false;
            formKey.currentState!.validate();
          }
        },
        builder: (context,state){
          return Scaffold(
            appBar: AppBar(
              title: Text('Reset Password'),
              centerTitle: true,
              elevation: 0,
              backgroundColor: Theme.of(context).focusColor,
            ),
            body: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0,horizontal: 10),
                child: SingleChildScrollView(
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
                              return '${AppLocalizations.of(context)!.passwordMustBeAtLeastCharacters}';
                            }
                            else if(!validPass){
                              return 'password is not true';
                            }
                            else if(value.length<8){
                              return '${AppLocalizations.of(context)!.passwordMustBeAtLeastCharacters}';
                            }
                            return null;
                          },
                          isPassword: ShoppyCubit.get(context).isPassword,
                          label: "${AppLocalizations.of(context)!.currentPassword}",
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
                              return '${AppLocalizations.of(context)!.passwordMustBeAtLeastCharacters}';
                            }
                            else if(value==currentPasswordController.text){
                              return '${AppLocalizations.of(context)!.newPasswordCannot}';
                            }
                            else if(value.length<8){
                              return '${AppLocalizations.of(context)!.passwordMustBeAtLeastCharacters}';
                            }
                            return null;
                          },
                          isPassword: ShoppyCubit.get(context).isPassword2,
                          label: "${AppLocalizations.of(context)!.password}",
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
                              return '${AppLocalizations.of(context)!.passwordMustBeAtLeastCharacters}';
                            }
                            else if(value!=newPasswordController.text){
                              return '${AppLocalizations.of(context)!.thisNotMatch}';
                            }
                            else if(value.length<8){
                              return '${AppLocalizations.of(context)!.passwordMustBeAtLeastCharacters}';
                            }
                            return null;

                          },
                          isPassword: ShoppyCubit.get(context).isPassword3,
                          label: "${AppLocalizations.of(context)!.confirmPassword}",
                          suffix: ShoppyCubit.get(context).icon3,
                          suffixPressed: () {
                            ShoppyCubit.get(context).changePasswordVisibility(3);
                          },
                        ),
                      ),
                      SizedBox(height: 50.0,),
                      Container(
                        height: 40.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: Theme.of(context).focusColor,
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
                                '${AppLocalizations.of(context)!.save}',
                                style: TextStyle(
                                  color: Theme.of(context).iconTheme.color,
                                ),)
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
