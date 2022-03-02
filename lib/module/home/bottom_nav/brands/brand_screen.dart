
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoppy/layout/cubit/cubit.dart';
import 'package:shoppy/layout/cubit/states.dart';
import 'package:shoppy/model/brand_model.dart';
import 'package:shoppy/model/product_model.dart';
import 'package:shoppy/module/home/bottom_nav/category/category_products_screen.dart';
import 'package:shoppy/shared/components/components.dart';

class BrandScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return  BlocConsumer<ShoppyCubit,ShoppyStates>(
      listener:(context, state) {} ,
      builder: (context, state) {
        var cubit=ShoppyCubit.get(context);
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,

          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
                childAspectRatio: 1/0.9,
                physics: BouncingScrollPhysics(),
                children: List.generate(
                  cubit.brands.length,
                      (index)=>buildBrandItem(
                          context: context,
                          cubit: ShoppyCubit.get(context),
                          brandModel: cubit.brands[index])
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
Widget buildBrandItem({
  required context,
  required BrandModel brandModel,
  required cubit,
})=>InkWell(
  onTap: (){
    List<ProductModel> brandProducts=cubit.products.where((element) => element.brandId==brandModel.brandUId).toList();
    cubit.updateForYouProducts(brandName:brandModel.brandName,brandCategory:null);
    navigateTo(context, CategoryProductsScreen( brandProducts,brandModel.brandName,));
  },
  child: Container(
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),

        image: DecorationImage(
          image: NetworkImage(
            brandModel.brandImage,
          ),
          fit: BoxFit.cover
        ),

    ),
    child:Align(
      alignment: Alignment.bottomCenter,

      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.7),
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Text(
            brandModel.brandName,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
      ),
    ),
  ),
);