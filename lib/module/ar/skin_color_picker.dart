import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shoppy/model/product_model.dart';
import 'package:shoppy/module/ar/virtual_fitting.dart';
import 'package:shoppy/shared/components/components.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SkinColorPicker extends StatefulWidget {
  final ProductModel product;
  final int selectedColor;
  SkinColorPicker(this.product,this.selectedColor);
  @override
  State<SkinColorPicker> createState() => _SkinColorPickerState();
}

class _SkinColorPickerState extends State<SkinColorPicker> {
  PageController pageController = PageController(viewportFraction: 0.75);
  var currentPageValue = 0.0;
  int menuActive = 1;

  @override
  void initState() {
    super.initState();
    pageController.addListener(() {
      setState(() {
        currentPageValue = pageController.page!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).focusColor,
        title: Text('${AppLocalizations.of(context)!.skinColor}'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            '${AppLocalizations.of(context)!.selectSkinColor}',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          SizedBox(
            height: 370,
            child: PageView.builder(
                controller: pageController,
                itemCount: 6,
                itemBuilder: (context, position) {
                  if (position == currentPageValue) {
                    return Transform.scale(
                      scale: 1,
                      child: GamePage(position,widget.product,widget.selectedColor),
                    );
                  } else if (position < currentPageValue) {
                    return Transform.scale(
                      scale: max(1 - (currentPageValue - position), 0.75),
                      child: GamePage(position,widget.product,widget.selectedColor),
                    );
                  } else {
                    return Transform.scale(
                      scale: max(1 - (position - currentPageValue), 0.75),
                      child: GamePage(position,widget.product,widget.selectedColor),
                    );
                  }
                }),
          ),
        ],
      ),
    );
  }
}

class GamePage extends StatelessWidget {
  final int index;
  final ProductModel product;
  final int selectedColor;
  GamePage(this.index,this.product,this.selectedColor);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only( bottom: 30),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: (){
            navigateTo(context, VirtualFittingScreen(index: index,product: product,selectedColor: selectedColor,));
          },
          child: Image.asset(
            'assets/skins/model${index+1}.png',
            height: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}