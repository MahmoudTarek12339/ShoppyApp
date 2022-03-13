import 'package:clippy_flutter/arc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoppy/layout/cubit/cubit.dart';
import 'package:shoppy/layout/cubit/states.dart';
import 'package:shoppy/model/brand_model.dart';
import 'package:shoppy/model/product_model.dart';
import 'package:shoppy/module/home/bottom_nav/category/category_products_screen.dart';
import 'package:shoppy/module/home/product_screen/product_screen.dart';
import 'package:shoppy/shared/components/components.dart';

class SearchScreen extends StatelessWidget {
  final TextEditingController searchController= TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShoppyCubit,ShoppyStates>(
      listener: (context, state) {

      },
      builder: (context, state) {
        var cubit=ShoppyCubit.get(context);
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: TextFormField(
              controller: searchController,
              cursorColor: Colors.grey,
              style: TextStyle(color: Colors.white),
              autofocus: true,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Search for Product, Store",
                hintStyle: TextStyle(color: Colors.grey),
                suffixIcon: searchController.text.isNotEmpty?IconButton(
                  onPressed: (){
                    searchController.clear();
                    cubit.clearSearch();
                  },
                  icon: Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ):null,
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
              ),
              onChanged: (value){
                if(value.isEmpty){
                  cubit.clearSearch();
                }
                else{
                  cubit.addSearchToList(value);
                }
              },
            ),
            titleSpacing: 0,
          ),
          body: cubit.searchList.isEmpty&&cubit.searchBrand.isEmpty?
              Center(child: Image.asset('assets/images/search_empty_dark.png'))
              :SingleChildScrollView(
                child: Column(
                  children: [
                    cubit.searchBrand.isNotEmpty?
                     Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ' Stores',
                            textAlign: TextAlign.left,
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            child: GridView.count(
                              crossAxisCount: 2,
                              shrinkWrap: true,
                              mainAxisSpacing: 10.0,
                              crossAxisSpacing: 10.0,
                              childAspectRatio: 1/0.9,
                              physics: BouncingScrollPhysics(),
                              children: List.generate(
                                  cubit.searchBrand.length,
                                      (index)=>buildBrandItem(
                                      context: context,
                                      cubit: ShoppyCubit.get(context),
                                      brandModel: cubit.searchBrand[index])
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                        :SizedBox(),
                    cubit.searchList.isNotEmpty?
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            ' Products',
                            textAlign: TextAlign.left,
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            child: GridView.count(
                              crossAxisCount: 2,
                              shrinkWrap: true,
                              mainAxisSpacing: 10.0,
                              crossAxisSpacing: 10.0,
                              childAspectRatio: 1/1.45,
                              physics: NeverScrollableScrollPhysics(),
                              children: List.generate(
                                  cubit.searchList.length,
                                      (index)=>buildCardItem(
                                    cubit: cubit,
                                    context: context,
                                    productModel: cubit.searchList[index],
                                  )),
                            ),
                          ),
                        ],
                      ),
                    )
                        :SizedBox(),
                  ],
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
                  productModel.rate>0?
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
                            '${productModel.offer*100}%',
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
                      '\$ ${productModel.price}',
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

  Widget buildBrandItem({
    required context,
    required BrandModel brandModel,
    required cubit,
  })=>InkWell(
    onTap: (){
      List<ProductModel> brandProducts=cubit.products.where((element) => element.brandId==brandModel.brandUId).toList();
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
}
