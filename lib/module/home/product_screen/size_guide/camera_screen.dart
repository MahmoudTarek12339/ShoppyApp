
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoppy/layout/cubit/cubit.dart';
import 'package:shoppy/layout/cubit/states.dart';
import 'package:shoppy/shared/components/components.dart';

class CameraScreen extends StatefulWidget {
  final double height;
  final int clothing;
  final String category;
  final camera;
  CameraScreen({required this.height,required this.clothing,required this.category,required this.camera});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController cameraController;
  late Future<void> _initializeControllerFuture;
  List<String?> sizes=[];
  var image;
  var image2;

  int currentPicture=0;
  bool isFlashOn=false;
  final List<String> model=[
    'assets/poses/frontModel.png',
    'assets/poses/side_model.png'
  ];
  @override
  void initState() {
    super.initState();
    cameraController=CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = cameraController.initialize();
    cameraController.setFlashMode(FlashMode.off);
  }
  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShoppyCubit,ShoppyStates>(
      listener: (context, state) {
        if(state is ShoppySendImagesLoadingState){
          AlertDialog alertUpload = AlertDialog(
            title: Text(
              "Processing",
              style:Theme.of(context).textTheme.bodyText1!.copyWith(color: Theme.of(context).focusColor),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    "Your data is being processed",
                    style:Theme.of(context).textTheme.subtitle1
                ),
                SizedBox(
                  height: 5,
                ),
                CircularProgressIndicator(color: Theme.of(context).focusColor,)
              ],
            ),
            backgroundColor: Theme.of(context).cardColor,
            actions: [
              TextButton(
                child: Text(
                  "Cancel",
                  style: TextStyle(
                    color: Theme.of(context).focusColor,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    currentPicture=0;
                    image=null;
                    image2=null;
                  });
                },
              ),
            ],
            actionsAlignment: MainAxisAlignment.center,
          );
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return alertUpload;
            },
          );
        }
        else if(state is ShoppySendImagesSuccessState){
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
          ShoppyCubit.get(context).setUserSizes(sizes:sizes,index:widget.clothing);
        }
        else if(state is ShoppySendImagesErrorState){
          Navigator.pop(context);
          setState(() {
            currentPicture=0;
            image2=null;
            image=null;
          });
          defaultSnackBar(
              context: context,
              title: 'Error',
              color: Colors.red
          );
        }
      },
      builder: (context,state){
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).focusColor,
              title: Text(currentPicture==0?'Front Picture':'Side Picture'),
              centerTitle: true,
            ),
            body: FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // If the Future is complete, display the preview.
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                          children:[
                            CameraPreview(cameraController),
                            Align(
                              alignment: Alignment.center,
                              child: Image.asset(
                                model[currentPicture],
                                fit: BoxFit.fitHeight,
                                height: 400,
                              ),
                            ),
                            Align(
                              alignment:Alignment.topRight,
                              child: IconButton(
                                icon:isFlashOn?Icon(Icons.flash_off):Icon(Icons.flash_on),
                                onPressed: (){
                                  if(isFlashOn){
                                    setState(() {
                                      cameraController.setFlashMode(FlashMode.off);
                                      isFlashOn=!isFlashOn;
                                    });
                                  }
                                  else{
                                    setState(() {
                                      cameraController.setFlashMode(FlashMode.torch);
                                      isFlashOn=!isFlashOn;
                                    });
                                  }

                                },
                              ),
                            )
                          ]
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: defaultButton(
                            onPressFunction: ()async{
                              if(currentPicture==0){
                                image = await cameraController.takePicture();
                                setState(() {
                                  currentPicture++;
                                });
                              }
                              else{
                                image2=await cameraController.takePicture();
                                sizes=await ShoppyCubit.get(context).sendImages(image, image2, widget.category, widget.height.toString(),);
                                print(sizes);
                              }
                            },
                            text: 'Take Picture',
                            context: context
                        ),
                      )
                    ],
                  );
                } else {
                  // Otherwise, display a loading indicator.
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),

          ),
        );
      },
    );
  }
}

