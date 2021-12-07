import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoppy/layout/cubit/cubit.dart';
import 'package:shoppy/layout/cubit/states.dart';
import 'package:shoppy/layout/shoppy_layout.dart';
import 'package:shoppy/shared/components/components.dart';

class ImagePickingScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>ShoppyCubit(),
      child: BlocConsumer<ShoppyCubit,ShoppyStates>(
        listener: (context,state){
          if(state is SocialUploadProfileImageSuccessState){
            showToast(
                message: 'Picture set successfully',
                state: ToastState.SUCCESS
            );
            navigateAndFinish(context,ShoppyLayout());
          }
          else if(state is SocialUploadProfileImageErrorState){
            showToast(message: state.error, state: ToastState.ERROR);
          }
        },
        builder:(context,state){
          final File? profileImage=ShoppyCubit.get(context).profileImage;
          return Scaffold(
            appBar: AppBar(
              actions: [
                TextButton(onPressed: (){
                  navigateAndFinish(context, ShoppyLayout());
                }, child: Text(
                  'Skip',
                  style:Theme.of(context).textTheme.subtitle1,
                ))
              ],
            ),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: AlignmentDirectional.bottomEnd,
                    children: [
                      CircleAvatar(
                        minRadius: 95.0,
                        maxRadius: 155.0,
                        backgroundColor: Theme.of(context).canvasColor,
                        child: CircleAvatar(
                            minRadius: 90.0,
                            maxRadius: 150.0,
                            backgroundImage: profileImage==null?
                            AssetImage('assets/images/default_login2.jpg'):
                            FileImage(profileImage) as ImageProvider
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: IconButton(
                          onPressed: (){
                            ShoppyCubit.get(context).getProfileImage();
                          },
                          icon: CircleAvatar(
                            radius: 20.0,
                            child: Icon(
                              Icons.camera_alt,
                              size: 16.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30,),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        defaultButton(
                          context: context,
                          onPressFunction: (){
                            if(ShoppyCubit.get(context).profileImage!=null){
                              ShoppyCubit.get(context).uploadProfileImage();
                            }
                            else {
                              navigateAndFinish(context, ShoppyLayout());
                            }
                          },
                          text: 'Set Profile Picture',
                        ),
                        if(state is SocialUploadProfileImageLoadingState)
                          SizedBox(height: 5.0,),
                        if(state is SocialUploadProfileImageLoadingState)
                          LinearProgressIndicator(),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        }

      ),
    );
  }
}
