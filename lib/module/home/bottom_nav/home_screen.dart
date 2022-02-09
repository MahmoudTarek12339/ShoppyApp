
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoppy/layout/cubit/cubit.dart';
import 'package:shoppy/layout/cubit/states.dart';
import '../../../model/product_model.dart';
import '../../../shared/components/components.dart';
import '../product_screen.dart';

class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShoppyCubit,ShoppyStates>(
      listener: (context,state){},
      builder: (context,state){
        var cubit=ShoppyCubit.get(context);
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //offers
                SizedBox(
                  height: 5,
                ),
                Container(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: CarouselSlider(
                    items:[
                      Image(image:NetworkImage('https://i.pinimg.com/564x/e6/74/8c/e6748c9d19f12257c8b6fa2b2a480dce.jpg'),width: double.infinity,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) => loadingProgress==null?child:Center(child: CircularProgressIndicator()),
                        errorBuilder: (context, error, stackTrace) =>new Image.asset('assets/images/default_login2.jpg'),),
                      Image(image:NetworkImage('https://i.pinimg.com/564x/ae/29/14/ae29149d86039e2c1b536a515bca1eb2.jpg'),width: double.infinity,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) => loadingProgress==null?child:Center(child: CircularProgressIndicator()),
                        errorBuilder: (context, error, stackTrace) =>new Image.asset('assets/images/default_login2.jpg'),),
                      Image(image:NetworkImage('https://i.pinimg.com/564x/b8/af/6b/b8af6b66d8d1aaa3251d5b1ff7cc62c4.jpg'),width: double.infinity,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) => loadingProgress==null?child:Center(child: CircularProgressIndicator()),
                        errorBuilder: (context, error, stackTrace) =>new Image.asset('assets/images/default_login2.jpg'),),
                      Image(image:NetworkImage('https://i.pinimg.com/736x/71/9a/a0/719aa07defbe8a2958ee74602bc19557.jpg'),width: double.infinity,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) => loadingProgress==null?child:Center(child: CircularProgressIndicator()),
                        errorBuilder: (context, error, stackTrace) =>new Image.asset('assets/images/default_login2.jpg'),),
                    ],
                    options: CarouselOptions(
                      height: 150.0,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 3) ,
                      autoPlayAnimationDuration:Duration(seconds: 1),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      scrollDirection: Axis.horizontal,
                      viewportFraction: 1.0,
                      enlargeCenterPage: false,
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),

                //for you
                Text(
                  ' For you',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  height: 230,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context,index)=>index==cubit.products.length?
                        buildMoreItem(context: context)
                        :buildCardItem(
                          onFavoriteTab:(){
                            cubit.updateWishList(productUid: 'productUid');
                          },
                          isFavorite: cubit.favorites.contains('productUid'),
                          image: cubit.products[index].photos[0],
                          price: cubit.products[index].price,
                          rate: cubit.products[index].rate,
                          productId: 1,
                          onTap: (){
                            navigateTo(context, ProductScreen(cubit.products[index]as ProductModel));
                          },
                          context: context
                        ),
                    separatorBuilder: (context,index)=>SizedBox(width: 10.0,),
                    itemCount: cubit.products.length+1,
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),

                //newest
                Text(
                  ' Newest',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  height: 230,
                  width: double.infinity,
                  child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context,index)=>index==4?
                          buildMoreItem(context: context)
                          :buildCardItem(
                          onFavoriteTab:()async{
                            cubit.getAllProducts();
                          },
                          isFavorite: true,
                          image: 'https://fakestoreapi.com/img/71-3HjGNDUL._AC_SY879._SX._UX._SY._UY_.jpg',
                          price: 55.23,
                          rate: 3.9,
                          productId: 1,
                          onTap: (){
                            navigateTo(context, ProductScreen(cubit.products[index]as ProductModel));
                          },
                          context: context),
                      separatorBuilder: (context,index)=>SizedBox(width: 10.0,),
                      itemCount: 5),
                ),
                SizedBox(
                  height: 15.0,
                ),

                //best sell
                Text(
                  ' Best Sell',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  height: 230,
                  child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context,index)=>index==5?
                          buildMoreItem(context: context)
                          :buildCardItem(
                            onFavoriteTab:(){},
                            isFavorite: true,
                            image: 'https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg',
                            price: 55.23,
                            rate: 3.9,
                            productId: 1,
                            onTap: (){
                              navigateTo(context, ProductScreen(cubit.products[index]as ProductModel));
                            },
                            context: context
                      ),
                      separatorBuilder: (context,index)=>SizedBox(width: 10.0,),
                      itemCount: 6
                  ),
                ),

                //random images
                SizedBox(
                  height: 35.0,
                ),
                Text(
                  ' Find your Inspiration',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                SizedBox(
                  height: 15.0,
                ),
                Container(
                  child: GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 10.0,
                    childAspectRatio: 1/1.45,
                    physics: NeverScrollableScrollPhysics(),
                    children: List.generate(12,(index)=>buildCardItem(
                        onFavoriteTab:(){},
                        image: 'https://fakestoreapi.com/img/71YXzeOuslL._AC_UY879_.jpg',
                        price: 55.23,
                        rate: 3.9,
                        productId: 1,
                        isFavorite: true,
                        onTap: (){
                          navigateTo(context, ProductScreen(cubit.products[index]as ProductModel));
                        },
                        context: context)
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  //product code
  Widget buildCardItem({
    required String image,
    required double price,
    required double rate,
    required int productId,
    required bool isFavorite,
    required Function() onTap,
    required Function() onFavoriteTab,
    required context,

  }){
    return InkWell(
      onTap: onTap,
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
                  onPressed: onFavoriteTab,
                  icon:isFavorite?
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
                    //cartController.addProductToCart(productModel);
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
                image,
                fit: BoxFit.fitHeight,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:15,vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$ $price',
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
                            text: '$rate',
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
    onTap: (){

    },
    child: Center(
          child:Icon(
              Icons.arrow_forward,
              size: 50,
              color: Theme.of(context).canvasColor,
          ),
      ),
  );
}
