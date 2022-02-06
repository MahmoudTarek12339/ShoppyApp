import 'package:flutter/material.dart';

import '../../../shared/components/components.dart';

class CategoriesScreen extends StatelessWidget {

  final List<String> imageCategory = [
    'assets/categories/shirt2.jpg',
    'assets/categories/t-shirt.jpg',
    'assets/categories/dresses.jpg',
    'assets/categories/pants.jpg',
    'assets/categories/shorts.jpg',
    'assets/categories/jacket.jpg',
    'assets/categories/skirt.jpg',
    'assets/categories/children.jpg',
    'assets/categories/shoes.jpg',
    'assets/categories/accessories.jpg',
  ];
  final List<String> categoriesNameList=[
    'Shirts',
    'T-shirts',
    'Dresses',
    'Pants',
    'Shorts',
    'Jackets',
    'Skirts',
    'Children',
    'Shoes',
    'Accessories',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: EdgeInsets.only(left: 15,top: 15,right: 10),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 15,top: 15),
                child: textUtils(
                  text: 'Category',
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  color:Theme.of(context).textTheme.bodyText1!.color,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            categoryWidget(),
          ],
        ),
      ),
    );
  }
  Widget categoryWidget()=>Expanded(
    child: ListView.separated(
      itemBuilder: (context,index)=>InkWell(
        onTap: (){
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
                categoriesNameList[index],
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
      itemCount: 10
    ),
  );
}
