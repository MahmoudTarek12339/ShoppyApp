import 'package:flutter/material.dart';
import 'package:shoppy/module/home/product_screen/size_guide/guide_screen.dart';
import 'package:shoppy/shared/components/components.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ClothingSizeScreen extends StatefulWidget {
  final double height;
  final String category;
  ClothingSizeScreen(this.height,this.category);
  @override
  State<ClothingSizeScreen> createState() => _ClothingSizeScreenState();
}

class _ClothingSizeScreenState extends State<ClothingSizeScreen> {
  int selectedIndex=0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).focusColor,
          centerTitle: true,
          title: Text('Size Guide'),
          elevation: 0.0,

        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Text(
                  '${AppLocalizations.of(context)!.whatAreYouWearing}',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: (){
                        setState(() {
                          selectedIndex=0;
                        });
                      },
                      child: Container(
                        height: 380,
                        decoration: BoxDecoration(
                            color: selectedIndex==0?Theme.of(context).focusColor.withOpacity(0.9):null,
                            borderRadius: BorderRadius.circular(20),
                        ),

                        child: Column(
                          children: [
                            Container(
                              height: 350,
                              width: 160,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  image: DecorationImage(
                                    image: AssetImage(
                                      'assets/images/regularSize.jpg',
                                    ),
                                    fit: BoxFit.fitHeight,
                                  )
                              ),
                            ),
                            Text(
                              '${AppLocalizations.of(context)!.regularFit}',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    InkWell(
                      onTap: (){
                        setState(() {
                          selectedIndex=1;
                        });
                      },
                      child: Container(
                        height: 380,
                        decoration: BoxDecoration(
                          color: selectedIndex==1?Theme.of(context).focusColor.withOpacity(0.9):null,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            Container(
                              height: 350,
                              width: 160,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/simple_fit.jpg',
                                    ),
                                    fit: BoxFit.fitHeight,
                                  )
                              ),
                            ),
                            Text(
                              '${AppLocalizations.of(context)!.tightFit}',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 35,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: defaultButton(
                    text: '${AppLocalizations.of(context)!.continueE}',
                    onPressFunction: (){
                      navigateTo(context, GuideScreen(height: widget.height,clothing: selectedIndex,category:widget.category));
                    },
                    context: context,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

}
