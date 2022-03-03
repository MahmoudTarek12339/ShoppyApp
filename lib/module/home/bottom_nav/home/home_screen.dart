import 'package:carousel_slider/carousel_slider.dart';
import 'package:clippy_flutter/arc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shoppy/layout/cubit/cubit.dart';
import 'package:shoppy/layout/cubit/states.dart';
import 'package:shoppy/model/product_model.dart';
import 'package:badges/badges.dart';
import 'package:shoppy/module/home/bottom_nav/category/category_products_screen.dart';
import 'package:shoppy/module/home/bottom_nav/home/cart/cart_screen.dart';
import 'package:shoppy/module/home/profile/profile_screen.dart';
import 'package:shoppy/module/login/login_screen.dart';
import 'package:shoppy/module/home/bottom_nav/home/search_screen.dart';
import 'package:shoppy/shared/components/components.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../product_screen/product_screen.dart';

class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShoppyCubit,ShoppyStates>(
      listener: (context,state){},
      builder: (context,state){
        var cubit=ShoppyCubit.get(context);
        User? user = FirebaseAuth.instance.currentUser;
        return  Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            titleSpacing: 10.0,
            title: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0),
                  color: Theme.of(context).iconTheme.color
              ),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        navigateTo(context, SearchScreen());
                      },
                      child: TextFormField(
                        enabled: false,
                        decoration: InputDecoration(
                          hintText: "Search for Product, Brand",
                          hintStyle: TextStyle(color: Colors.grey),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: InkWell(
                      child: CircleAvatar(
                        radius: 20.0,
                        backgroundImage: user != null && user.photoURL != null
                            ? NetworkImage(user.photoURL.toString()) as ImageProvider
                            : AssetImage('assets/images/default_login2.jpg'),
                      ),
                      onTap: () async{
                        bool connected=await cubit.checkInternetConnection();
                        if(connected){
                          if (user == null)
                            navigateTo(context, LoginScreen());
                          else
                            navigateTo(context, ProfileScreen());
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              Badge(
                position: BadgePosition.topEnd(top: 0, end: 3),
                animationType:BadgeAnimationType.slide,
                badgeContent: Text(
                  cubit.cart.length.toString(),
                  style: TextStyle(color: Colors.white,fontSize: 15),
                ),
                child: IconButton(
                    onPressed: () {
                      navigateTo(context, CartScreen());
                    },
                    icon: FaIcon(
                      FontAwesomeIcons.shoppingCart,
                      color: Theme.of(context).iconTheme.color,
                      size: 25,
                    )),
              ),
            ],
          ),
          body:cubit.products.isEmpty?
          Center(child: CircularProgressIndicator(color: Theme.of(context).focusColor,),)
              :Padding(
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
                      itemBuilder: (context,index)=>index==cubit.forYouProducts.length?
                      buildMoreItem(
                        context: context,
                        products: cubit.forYouProducts,
                        name: "For You"
                      )
                      :buildCardItem(
                        cubit: cubit,
                        context: context,
                        productModel: cubit.forYouProducts[index],
                      ),
                      separatorBuilder: (context,index)=>SizedBox(width: 10.0,),
                      itemCount: cubit.forYouProducts.length+1,
                    ),
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
                        itemBuilder: (context,index)=>index==cubit.products.length?
                        buildMoreItem(
                          context: context,
                          products: [],
                          name: 'Best Sell',
                        )
                            :buildCardItem(
                          cubit: cubit,
                          context: context,
                          productModel: cubit.products[index],
                        ),
                        separatorBuilder: (context,index)=>SizedBox(width: 10.0,),
                        itemCount: cubit.products.length+1
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
                      children: List.generate(
                        cubit.products.length,
                            (index)=>buildCardItem(
                          cubit: cubit,
                          context: context,
                          productModel: cubit.products[index],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  //product code
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

  //more Arrow Icon Code
  Widget buildMoreItem({
    required context,
    required List<ProductModel> products,
    required String name,
  })=> InkWell(
    onTap: (){
      navigateTo(context, CategoryProductsScreen( products,name));
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
