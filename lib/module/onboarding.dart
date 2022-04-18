import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shoppy/layout/shoppy_layout.dart';
import 'package:shoppy/model/onboard_model.dart';
import 'package:shoppy/shared/components/components.dart';
import 'package:shoppy/shared/network/local/cache_helper.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OnBoardingScreen extends StatefulWidget {
  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  var onBoardController = PageController();
  int currentIndex=0;

  @override
  void initState(){
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    List<OnBoard> list = [
      OnBoard(
          imageUrl: 'assets/images/easyShopping.json',
          title: '${AppLocalizations.of(context)!.easyShopping}',
          description: '${AppLocalizations.of(context)!.findYourInspirationWithAHugeCollectionOfProductsAndExclusiveBrands}'),
      OnBoard(
          imageUrl: 'assets/images/speedDelivery.json',
          title: '${AppLocalizations.of(context)!.quickDelivery}',
          description: '${AppLocalizations.of(context)!.deliveryWheneverYouOrderWhereverYouAreYourOrderWilBeThereOnTime}'),
      OnBoard(
          imageUrl: 'assets/images/easePayment.json',
          title: '${AppLocalizations.of(context)!.securePayment}',
          description: '${AppLocalizations.of(context)!.yourDataIsSafeWithUs}'),
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: [
          TextButton(
            child: Text(
              '${AppLocalizations.of(context)!.skip}',
              style: Theme.of(context).textTheme.bodyText1!.copyWith(color:Theme.of(context).focusColor),
            ),
            onPressed: (){
              CacheHelper.saveData(key: 'onBoarding', value: true).then((value){
                if(value==true)
                  navigateAndFinish(context, ShoppyLayout());
              });
            },
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              itemBuilder: (context,index)=>onBoard(index,list),
              controller: onBoardController,
              itemCount: list.length,
                onPageChanged: (int index) {
                  setState(() {
                    if(index<3)
                      currentIndex=index;
                    else {
                      CacheHelper.saveData(key: 'onBoarding', value: true).then((value){
                        if(value==true)
                          navigateAndFinish(context, ShoppyLayout());
                      });
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
                      controller: onBoardController,
                      count: list.length,
                      effect: ScrollingDotsEffect(
                        dotColor: Colors.grey,
                        dotHeight: 7.5,
                        dotWidth: 7.5,
                        activeDotColor: Theme.of(context).focusColor,
                        spacing: 5,
                      )
                  ),
                ),
                Spacer(),
                TextButton(
                  child: Text(
                    currentIndex<2?'${AppLocalizations.of(context)!.next}':'${AppLocalizations.of(context)!.start}',
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(color:Theme.of(context).focusColor),
                  ),
                  onPressed: (){
                    setState(() {
                      if(currentIndex<2){
                        currentIndex=(currentIndex+1);
                        onBoardController.animateToPage(currentIndex,duration: Duration(milliseconds: 750), curve: Curves.fastLinearToSlowEaseIn);
                      }
                      else {
                        CacheHelper.saveData(key: 'onBoarding', value: true).then((value){
                        if(value==true)
                          navigateAndFinish(context, ShoppyLayout());
                      });
                      }
                    },);
                  },
                )
              ],
            ),
          )
        ],
      )
    );
  }
  Widget onBoard(int index,List list)=>Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Lottie.asset(
        list[index].imageUrl,
      ),
      SizedBox(
        height: 15,
      ),
      Text(
        list[index].title,
        style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 25,color: Theme.of(context).focusColor.withOpacity(0.85)),
      ),
      SizedBox(
        height: 5,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Text(
          list[index].description,
          style: Theme.of(context).textTheme.caption,
          textAlign: TextAlign.center,
        ),
      ),
    ],
  );
}
