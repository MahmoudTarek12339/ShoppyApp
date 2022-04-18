import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoppy/layout/cubit/cubit.dart';
import 'package:shoppy/layout/cubit/states.dart';
import 'package:shoppy/module/home/bottom_nav/category/category_products_screen.dart';
import 'package:shoppy/shared/components/components.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CategoriesScreen extends StatelessWidget {

  final List<String> imageCategory = [
    'assets/categories/shirt2.jpg',
    'assets/categories/t-shirt.jpg',
    'assets/categories/pants.jpg',
    'assets/categories/shorts.jpg',
    'assets/categories/jacket.jpg',
  ];
  final List<String> categoriesNameList=[
    'Shirts',
    'T-shirts',
    'Pants',
    'Shorts',
    'Jackets',
  ];

  @override
  Widget build(BuildContext context) {
    List<String> categories=[
      '${AppLocalizations.of(context)!.shirts}',
      '${AppLocalizations.of(context)!.tShirts}',
      '${AppLocalizations.of(context)!.pants}',
      '${AppLocalizations.of(context)!.shorts}',
      '${AppLocalizations.of(context)!.jackets}',
    ];
    return BlocConsumer<ShoppyCubit,ShoppyStates>(
      listener: (context,state){},
      builder: (context,state){
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: Padding(
            padding: EdgeInsets.only(left: 15,top: 15,right: 15),
            child: Column(
              children: [
                categoryWidget(
                  cubit: ShoppyCubit.get(context),
                  categories: categories,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  Widget categoryWidget({
  required cubit,
    required List<String> categories,
})=>Expanded(
    child: ListView.separated(
      itemBuilder: (context,index)=>InkWell(
        onTap: (){
          navigateTo(context, CategoryProductsScreen(cubit.products.where((element) => element.category==categoriesNameList[index]).toList(),categoriesNameList[index]));
        },
        child: Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: AssetImage(
                imageCategory[index],
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(left: 10,bottom: 5),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                categories[index],
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
      separatorBuilder: (context,index)=>SizedBox(height: 20,),
      itemCount: imageCategory.length,
    ),
  );
}
