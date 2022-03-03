import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:shoppy/shared/components/components.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'camera_screen.dart';
class PosesGuideScreen extends StatefulWidget {
  final double height;
  final int clothing;
  final String category;

  PosesGuideScreen(this.height, this.clothing,this.category);

  @override
  State<PosesGuideScreen> createState() => _PosesGuideScreenState();
}

class _PosesGuideScreenState extends State<PosesGuideScreen> {
  final List<Map<String,String>> poses=[
    {
      'title':'Correct Front Pose',
      'image':'assets/poses/frontCorrect.png',
    },
    {
      'title':'Wrong Front Pose',
      'image':'assets/poses/frontWrong.png',
    },
    {
      'title':'Wrong Front Pose',
      'image':'assets/poses/frontWrong2.png',
    },
    {
      'title':'Wrong Front Pose',
      'image':'assets/poses/frontWrong3.png',
    },
    {
      'title':'Correct Side Pose',
      'image':'assets/poses/sideCorrect.png',
    },
    {
      'title':'Wrong Side Pose',
      'image':'assets/poses/sideWrong.png',
    },
    {
      'title':'Wrong Side Pose',
      'image':'assets/poses/sideWrong2.png',
    },
    {
      'title':'Wrong Side Pose',
      'image':'assets/poses/sideWrong3.png',
    },
  ];

  var guideController = PageController();

  int currentIndex=0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar:AppBar(
          backgroundColor: Theme.of(context).focusColor,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                    itemBuilder: (context,index)=>posesCart(
                        context: context,
                        pose: poses[index]
                    ),
                    controller: guideController,
                    itemCount: poses.length,
                    onPageChanged: (int index) {
                      setState(() {
                        if(index<poses.length)
                          currentIndex=index;
                        else {
                         // navigateTo(context, CameraScreen(height: widget.height, clothing: widget.clothing, category: widget.category));
                        }
                      });
                    }
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 5.0,right: 5,left: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15.0,left: 10),
                      child: SmoothPageIndicator(
                          controller: guideController,
                          count:poses.length,
                          effect: ScrollingDotsEffect(
                            dotColor: Theme.of(context).focusColor,
                            dotHeight: 7.5,
                            dotWidth: 7.5,
                            activeDotColor: Theme.of(context).focusColor,
                            spacing: 5,
                          )
                      ),
                    ),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        currentIndex>0?
                        TextButton(
                          child: Text(
                            'Back',
                            style: Theme.of(context).textTheme.bodyText1!.copyWith(color:Theme.of(context).focusColor),
                          ),
                          onPressed: (){
                            setState(() {
                              if(currentIndex>0){
                                currentIndex--;
                                guideController.animateToPage(currentIndex,duration: Duration(milliseconds: 500), curve: Curves.fastLinearToSlowEaseIn);
                              }},
                            );
                          },
                        )
                            :SizedBox(),
                        TextButton(
                          child: Text(
                            currentIndex==poses.length-1?'Continue':'Next',
                            style: Theme.of(context).textTheme.bodyText1!.copyWith(color:Theme.of(context).focusColor),
                          ),
                          onPressed: ()async{
                            if(currentIndex<poses.length-1) {
                              setState(() {
                                currentIndex++;
                                guideController.animateToPage(currentIndex,
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.fastLinearToSlowEaseIn);
                              });}
                            else {
                              try {
                                final cameras = await availableCameras();
                                final firstCamera = cameras.first;
                                navigateTo(context, CameraScreen(height: widget.height, clothing: widget.clothing, category: widget.category,camera: firstCamera,));
                              } on CameraException catch (e) {
                                print(e.description);
                              }
                            }
                          },
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  Widget posesCart({
    required context,
    required Map<String,String> pose,
})=>Column(
    children: [
      SizedBox(height: 5,),
      Text(
        pose['title']??'null',
        style: Theme.of(context).textTheme.bodyText1,
        textAlign: TextAlign.center,
      ),
      SizedBox(height: 10,),
      Expanded(
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: AssetImage(
                  pose['image']??'',
                ),
                fit: BoxFit.fill,
              )
          ),
        ),
      ),

    ],
  );
}
