import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoppy/layout/cubit/cubit.dart';
import 'package:shoppy/layout/cubit/states.dart';
import 'package:shoppy/layout/shoppy_layout.dart';
import 'package:shoppy/shared/components/components.dart';

import 'package:shoppy/module/home/bottom_nav/home/home_screen.dart';

class AccountInfoScreen extends StatelessWidget {
  final TextEditingController nameController=TextEditingController();
  final GlobalKey<FormState> formKey=GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShoppyCubit,ShoppyStates>(
      listener: ((context, state) {
        if(state is ShoppyChangeNameSuccessState){
          defaultSnackBar(
            context: context,
            color: Colors.green,
            title: 'Name Changed Successfully',
          );
          navigateAndFinish(context, ShoppyLayout());
        }
        else if(state is ShoppyChangeNameErrorState){
          defaultSnackBar(
            context: context,
            color: Colors.red,
            title: state.error.toString(),
          );
        }
      }),
      builder: (context,state){
        User? user=FirebaseAuth.instance.currentUser;
        nameController.text='${user!.displayName}';

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            title: Text('Account Info'),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Theme.of(context).focusColor,
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Email',
                    style: Theme.of(context).textTheme.caption!.copyWith(fontSize: 14.0),
                  ),
                  TextFormField(
                    enabled: false,
                    decoration: InputDecoration(
                      hintText: '  '+'${user.email}',
                      hintStyle: Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 18,),
                      disabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Theme.of(context).textTheme.bodyText1!.color??Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                    'Full Name',
                    style: Theme.of(context).textTheme.caption!.copyWith(fontSize: 14.0),
                  ),
                  TextFormField(
                    controller: nameController,
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 18,),
                    decoration: InputDecoration(
                      enabledBorder:UnderlineInputBorder(
                        borderSide: BorderSide(color: Theme.of(context).textTheme.bodyText1!.color??Colors.white),
                      ),
                      focusedBorder:UnderlineInputBorder(
                        borderSide: BorderSide(color: Theme.of(context).textTheme.bodyText1!.color??Colors.white),
                      ),
                      errorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                    ),
                    validator: (value){
                      if(value!.isEmpty){
                        return 'Name must n\'t Be Empty';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 70,),
                  defaultButton(
                    onPressFunction: ()async{
                      if(formKey.currentState!.validate()){
                        ShoppyCubit.get(context).changeName(name: nameController.text);
                      }
                    },
                    text: 'Save',
                    context: context,
                  ),
                  if(state is ShoppyChangeNameLoadingState)
                    LinearProgressIndicator(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
