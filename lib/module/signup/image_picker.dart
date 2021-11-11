import 'package:flutter/material.dart';
import 'package:shoppy/layout/shoppy_layout.dart';
import 'package:shoppy/shared/components/components.dart';

class ImagePickingScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Text(
          'Select Profile Image',
        ),
        titleSpacing: 0,
        actions: [
          TextButton(
              onPressed: (){
                navigateAndFinish(context, ShoppyLayout());
              },
              child: Text(
                'Skip',
                style: TextStyle(color: Colors.red,fontSize: 20.0),
              )
          )
        ],
      ),

    );
  }
}
