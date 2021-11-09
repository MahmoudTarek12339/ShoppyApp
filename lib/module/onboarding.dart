import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shoppy/layout/shoppy_layout.dart';
import 'package:shoppy/model/onboard_model.dart';
import 'package:shoppy/shared/components/components.dart';
import 'package:shoppy/shared/network/local/cache_helper.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  //hello
  var onBoardController = PageController();
  int currentIndex=0;
  List<OnBoard> list = [
    OnBoard(
        imageUrl: 'assets/images/onboard5.jpg',
        title: 'this is on Board screen Title 1',
        description: 'description 1'),
    OnBoard(
        imageUrl: 'assets/images/onboard5.jpg',
        title: 'on Board Title 2',
        description: 'description 2'),
    OnBoard(
        imageUrl: 'assets/images/onboard4.jpg',
        title: 'on Board Title 3',
        description: 'description 3'),
  ];
  @override
  void initState(){
    super.initState();
    Timer.periodic(Duration(seconds: 5), (timer) {
      currentIndex=((currentIndex+1)%3);
      onBoardController.animateToPage(currentIndex,duration: Duration(milliseconds: 750), curve: Curves.fastLinearToSlowEaseIn);
    }
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          Column(
            children: [
              Expanded(
                flex: 5,
                child: Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    PageView.builder(
                        itemBuilder: (BuildContext context, int index) =>
                            buildBoardingItem(list[index]),
                        controller: onBoardController,
                        itemCount: list.length,
                        physics: BouncingScrollPhysics(),
                        onPageChanged: (int index) {
                          setState(() {
                            currentIndex=index;
                          });
                        }
                        ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 70.0,left: 20),
                      child: SmoothPageIndicator(
                          controller: onBoardController,
                          count: list.length,
                          effect: ScrollingDotsEffect(
                            dotColor: Colors.grey,
                            dotHeight: 7.0,
                            dotWidth: 7.0,
                            activeDotColor: Colors.white,
                            spacing: 5,
                          )),
                    ),
                  ],
                ),
              ),
              Spacer(),
            ],
          ),
          Column(
            children: [
              Spacer(flex: 3,),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topRight: Radius.circular(70.0)),
                    color: Colors.white,
                    border: Border.all(color: Colors.black, width: 1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Center(
                        child: defaultButton(
                          onPressFunction: () {
                            CacheHelper.saveData(key: 'onBoarding', value: true).then((value){
                              if(value==true)
                                navigateAndFinish(context, ShoppyLayout());
                            });
                          },
                          text: 'Get Started',
                          background: Colors.white,
                          buttonColor: Colors.blueGrey,
                        )),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  Widget buildBoardingItem(OnBoard model) => Stack(
        alignment: Alignment.centerLeft,
        children: [
          Image(
            image: AssetImage('${model.imageUrl}'),
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: Container(
              width: 200,
              child: Text(
                '${model.title}',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 25.0,
                ),
              ),
            ),
          ),
        ],
      );
}
