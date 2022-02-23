import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoppy/layout/cubit/cubit.dart';
import 'package:shoppy/layout/cubit/states.dart';
import 'package:shoppy/model/order_model.dart';
import 'package:shoppy/model/product_model.dart';
import 'package:shoppy/module/home/product_screen/product_screen.dart';
import 'package:shoppy/shared/components/components.dart';
class CategoryProductsScreen extends StatelessWidget {
  final List<ProductModel> myProducts;
  final String title;
  CategoryProductsScreen(this.myProducts,this.title);

  @override
  Widget build(BuildContext context) {
    var cubit=ShoppyCubit.get(context);
    return BlocConsumer<ShoppyCubit,ShoppyStates>(
      listener: (context, state) {},
      builder: (context,state){
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: Theme.of(context).focusColor,
            title: Text(title),
            elevation: 0,
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
                childAspectRatio: 1/1.45,
                physics: NeverScrollableScrollPhysics(),
                children: List.generate(
                  myProducts.length,
                  (index)=>buildCardItem(
                  cubit: cubit,
                  context: context,
                  productModel: myProducts[index],
                )),
              ),
            ),
          ),
        );
      },
    );
  }
  Widget buildCardItem({
    required ProductModel productModel,
    required cubit,
    required context,
  }){
    return InkWell(
      onTap: (){
        navigateTo(context, ProductScreen(productModel));
      },
      child: Container(
        width: 155.0,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 3.0,
                  blurRadius: 5.0
              ),
            ]
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: (){
                      cubit.updateWishList(productUid: productModel.productUid);
                    },
                    icon:cubit.favorites.contains(productModel.productUid)?
                    Icon(
                      Icons.favorite,
                      color: Colors.red,
                    )
                        :Icon(
                      Icons.favorite_outlined,
                      color: Colors.black,
                    )
                ),
                IconButton(
                  onPressed: (){
                    cubit.addProductToCart(
                        OrderModel(
                          productName: productModel.productName,
                          description: productModel.description,
                          productUid: productModel.productUid,
                          quantity: 1,
                          price: productModel.price,
                          photo: productModel.photos[0],
                          size: productModel.sizes[0],
                          color: productModel.colors[0],
                          brandId: productModel.brandId,
                        )
                    );
                  },
                  icon: Icon(
                    Icons.shopping_cart,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            Container(
              width: double.infinity,
              height: 140,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.network(
                productModel.photos[0],
                fit: BoxFit.fitHeight,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:15,vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$ ${productModel.price}',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,

                    ),
                  ),
                  Container(
                    height: 20,
                    width: 45,
                    decoration: BoxDecoration(
                      color: Theme.of(context).focusColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal:3.0 ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          textUtils(
                            text: '${productModel.rate}',
                            fontSize: 13.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          Icon(Icons.star,color: Colors.white,size: 13,),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //more Arrow Icon Code
  Widget buildMoreItem({required context})=> InkWell(
    onTap: (){},
    child: Center(
      child:Icon(
        Icons.arrow_forward,
        size: 50,
        color: Theme.of(context).canvasColor,
      ),
    ),
  );
}
