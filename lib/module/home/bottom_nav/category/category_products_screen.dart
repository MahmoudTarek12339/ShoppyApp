import 'package:clippy_flutter/arc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoppy/layout/cubit/cubit.dart';
import 'package:shoppy/layout/cubit/states.dart';
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
                physics: BouncingScrollPhysics(),
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
        cubit.updateForYouProducts(brandName:productModel.brandId,brandCategory:productModel.category);
        navigateTo(context, ProductScreen(productModel));
      },
      child: SizedBox(
        height: 200.0,
        child: Container(
          width: 160.0,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  productModel.offer>0?
                  Padding(
                    padding: const EdgeInsets.only(left: 9),
                    child: Arc(
                      edge: Edge.BOTTOM,
                      arcType: ArcType.CONVEY,
                      height: 8.0,
                      child: Container(
                        color: Colors.redAccent,
                        height: 40,
                        width: 30,
                        child: Center(
                          child: Text(
                            '${productModel.offer}%',
                            style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 10),
                          ),
                        ),
                      ),
                    ),
                  )
                      :SizedBox(),
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
                  loadingBuilder: (context, child, loadingProgress) => loadingProgress==null?child:Center(child: CircularProgressIndicator()),
                  errorBuilder: (context, error, stackTrace) =>new Image.asset('assets/images/default_login2.jpg'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:15,vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${productModel.price}',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      height: 20,
                      width: 39,
                      decoration: BoxDecoration(
                        color: Theme.of(context).focusColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal:3.0 ),
                        child: Row(
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
      ),
    );
  }
}
