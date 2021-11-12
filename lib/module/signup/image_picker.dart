import 'package:flutter/material.dart';
import 'package:shoppy/layout/shoppy_layout.dart';
import 'package:shoppy/shared/components/components.dart';

class ImagePickingScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          TextButton(onPressed: (){
            navigateAndFinish(context, ShoppyLayout());
          }, child: Text(
              'Skip',
              style:TextStyle(color: Colors.pink)
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
                        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                        child: CircleAvatar(
                          minRadius: 90.0,
                          maxRadius: 150.0,
                          backgroundImage: NetworkImage('https://i.pinimg.com/564x/c3/51/18/c3511874093854d317bc7c3927132b7b.jpg')
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: IconButton(
                          onPressed: (){},
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
              child: defaultButton(
                onPressFunction: (){
                },
                text: 'Set Profile Picture',
                backgroundColor: Colors.pink,
                radius: 15.0
              ),
            )
          ],
        ),
      ),
    );
  }
}
