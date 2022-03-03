
import 'package:flutter/material.dart';
import 'package:shoppy/module/home/product_screen/size_guide/poses_guide_screen.dart';
import 'package:shoppy/shared/components/components.dart';

class GuideScreen extends StatefulWidget {
  final double height;
  final int clothing;
  final String category;
  GuideScreen({required this.height,required this.clothing,required this.category});

  @override
  State<GuideScreen> createState() => _GuideScreenState();
}

class _GuideScreenState extends State<GuideScreen> {

  final List guides=[
    'Stand a meter away from the wall',
    'Please Tie your hair',
    'Please wear tight fitted clothing',
    'Your Full body Must Be visible Inside the phone Screen',
    'Ensure your background adjacent with your clothing color',
    'Place the phone at a vertical angle in front of you'
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar:AppBar(
          title: Text('Quick Guide'),
          centerTitle: true,
          backgroundColor: Theme.of(context).focusColor,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 400,
                child: ListView.separated(

                  itemBuilder: (context,index)=>Row(
                    children: [
                      CircleAvatar(
                        child: Text(
                          index.toString(),
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        radius: 12,
                        backgroundColor: Theme.of(context).focusColor,
                      ),
                      SizedBox(width: 10,),
                      Flexible(
                        child: Text(
                          guides[index],
                          style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 18,fontWeight: FontWeight.normal),
                        ),
                      ),
                    ],
                  ),
                  separatorBuilder: (context,index)=>SizedBox(height: 15,),
                  itemCount: guides.length,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: defaultButton(
                  text: 'Continue',
                  onPressFunction: (){
                    navigateTo(context, PosesGuideScreen(widget.height,widget.clothing,widget.category));
                  },
                  context: context,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget guideCart({
    required context,
    required String image,
    required String title,
})=>Column(
    children: [
      SizedBox(height: 15,),
      Text(
        title,
        style: Theme.of(context).textTheme.bodyText1,
        textAlign: TextAlign.center,
      ),
      Expanded(
        child: Image.network(
          'https://images.unsplash.com/photo-1519658422992-0c8495f08389?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8N3x8cG9pbnRpbmclMjB1cHxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60'
        ),
      )
    ],
  );
}
