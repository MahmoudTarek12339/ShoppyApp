

import 'package:badges/badges.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:readmore/readmore.dart';
import 'package:shoppy/layout/cubit/cubit.dart';
import 'package:shoppy/layout/cubit/states.dart';
import 'package:shoppy/model/order_model.dart';
import 'package:shoppy/model/product_model.dart';
import 'package:shoppy/module/home/bottom_nav/category/category_products_screen.dart';
import 'package:shoppy/shared/components/components.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';


import '../bottom_nav/home/cart/cart_screen.dart';
import 'size_guide/enter_height_screen.dart';


class ProductScreen extends StatefulWidget {
  final ProductModel productModel;
  int currentSelected=0;
  ProductScreen(this.productModel);
  void customSelect(int index){
    currentSelected=index;
  }
  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  CarouselController carouselController=CarouselController();
  int currentPage=0;
  int currentColor=0;
  List<Color> colorSelected=[
  Color(0xFFff4667),
  Color(0xff685959),
  Color(0xffADA79B),
  Color(0xffA5947F),
  Color(0xff738B71),
  Color(0xff6D454D),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShoppyCubit,ShoppyStates>(
      listener:(context,state){

      } ,
      builder:(context,state){
        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
            statusBarColor: Theme.of(context).primaryColor,
            statusBarIconBrightness:Theme.of(context).primaryColor==Colors.white?Brightness.dark:Brightness.light,
        ));
        return SafeArea(
          child: Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body:Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      imageSlider(),
                      clothesInfo(
                        context: context,
                        title: widget.productModel.productName,
                        description: widget.productModel.description,
                        rate: widget.productModel.rate,
                        cubit: ShoppyCubit.get(context),
                      ),
                      sizeList(recommendedSize:ShoppyCubit.get(context).getRecommendedSize(widget.productModel.category)),
                      addCart(myContext: context,cubit: ShoppyCubit.get(context)),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 25,right: 25,top:20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Theme.of(context).focusColor.withOpacity(0.8),
                            shape: BoxShape.circle,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: Theme.of(context).primaryColor,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                      Badge(
                        position: BadgePosition.topEnd(top: -5, end: -2),
                        animationType:BadgeAnimationType.slide,
                        badgeContent: Text(
                          '${ShoppyCubit.get(context).cart.length}',
                          style: TextStyle(color: Colors.white,fontSize: 12,fontWeight: FontWeight.bold),
                        ),
                        child: InkWell(
                          onTap: (){
                            navigateTo(context, CartScreen());
                          },
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Theme.of(context).focusColor.withOpacity(0.4),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.shopping_cart,
                              color: Theme.of(context).primaryColor,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      } ,
    );
  }


  Widget imageSlider()=>Stack(
    children: [
      CarouselSlider.builder(
        itemCount: widget.productModel.photos.length,
        carouselController: carouselController,
        options:CarouselOptions(
            height: 400,
            autoPlay: true,
            enlargeCenterPage: true,
            enableInfiniteScroll: false,
            autoPlayInterval: Duration(seconds: 2),
            viewportFraction: 1,
            onPageChanged: (index,reason){
              setState(() {
                currentPage=index;
              });
            }
        ),
        itemBuilder: (context,index,realIndex){
          return Container(
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                image: DecorationImage(
                  image: NetworkImage(
                    widget.productModel.photos[index],
                  ),
                  fit: BoxFit.fill,
                )
            ),
          );
        },
      ),
      Positioned(
          bottom: 30,
          left: 180,
          child:AnimatedSmoothIndicator(
            activeIndex: currentPage,
            count: widget.productModel.photos.length,
            effect: ExpandingDotsEffect(
              dotHeight: 10,
              dotWidth: 10,
              activeDotColor: Theme.of(context).focusColor,
              dotColor: Colors.black ,
            ),
          )
      ),
      Positioned(
          bottom: 5,
          right: 10,
          child:Container(
            height: 170,
            width: 50,
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(30),
            ),
            child: ListView.separated(
                itemBuilder: (context,index)=>GestureDetector(
                  onTap: (){
                    setState(() {
                      currentColor=index;
                    });
                  },
                  child: colorPicker(
                      outerBorder: currentColor==index,
                      color: colorSelected[index]
                  ),
                ),
                separatorBuilder: (context,index)=>SizedBox(height: 3,),
                itemCount: colorSelected.length),
          )
      ),
    ],
  );

  Widget colorPicker({
    required outerBorder,
    required color
  }){
    return Container(
      padding: EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: outerBorder?Border.all(color: color,width: 2):null,
      ),
      child:Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }


  Widget clothesInfo({
    required context,
    required title,
    required rate,
    required description,
    required cubit
  })=>Container(
    padding: EdgeInsets.symmetric(horizontal: 25,vertical: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                children: [
                  Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  InkWell(
                    onTap: (){
                      List<ProductModel> brandProducts=cubit.products.where((element) => element.brandId==widget.productModel.brandId).toList();
                      cubit.updateForYouProducts(brandName:widget.productModel.brandId,brandCategory:null);
                      navigateTo(context, CategoryProductsScreen( brandProducts,widget.productModel.brandName,));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Text(
                        widget.productModel.brandName,
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ),
                  ),
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey.withOpacity(0.1),
                child: IconButton(
                    onPressed: (){
                      ShoppyCubit.get(context).updateWishList(productUid: widget.productModel.productUid);
                    },
                    icon:ShoppyCubit.get(context).favorites.contains(widget.productModel.productUid)?
                    Icon(
                      Icons.favorite,
                      color: Colors.red,
                    )
                        :Icon(
                      Icons.favorite_outlined,
                      color: Colors.black,
                    )
                ),
              ),
            )
          ],
        ),
        Row(
          children: [
            textUtils(
              text: '$rate',
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyText1!.color,
            ),
            SizedBox(
              width: 8,
            ),
            RatingBarIndicator(
              rating: widget.productModel.rate,
              itemBuilder: (context, index) => Icon(
                Icons.star,
                size: 20,
                color: Colors.orangeAccent,
              ),
              itemCount: 5,
              itemSize: 20.0,
              unratedColor: Colors.orangeAccent.withAlpha(50),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        ReadMoreText(
          description,
          trimLines: 3,
          trimMode: TrimMode.Line,
          textAlign: TextAlign.justify,
          trimCollapsedText: 'Show More',
          trimExpandedText: 'Show Less',
          lessStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).focusColor,
          ),
          moreStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).focusColor,
          ),
          style: TextStyle(
            fontSize: 16,
            height: 2,
            color: Theme.of(context).textTheme.bodyText1!.color,
          ),
        )
      ],
    ),
  );

  Widget sizeList({
  required String? recommendedSize,
})=>Column(
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 25.0,right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Choose your Size',
              style: Theme.of(context).textTheme.caption,
            ),
            ElevatedButton(
              child: Text(
                'Size Guide',
                style: Theme.of(context).textTheme.subtitle1,
              ),
              style: ElevatedButton.styleFrom(primary: Theme.of(context).cardColor),
              onPressed: (){
                if(FirebaseAuth.instance.currentUser!=null){
                  if (recommendedSize != null) {
                    AlertDialog alertUpload = AlertDialog(
                      title: Text(
                        "Size Guide",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(color: Theme.of(context).focusColor),
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("You already have a recommended size",
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(fontSize: 14)),
                        ],
                      ),
                      backgroundColor: Theme.of(context).cardColor,
                      actions: [
                        TextButton(
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              color: Theme.of(context).focusColor,
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        TextButton(
                          child: Text(
                            "Add New",
                            style: TextStyle(
                              color: Theme.of(context).focusColor,
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            navigateTo(
                                context,
                                EnterHeightScreen(
                                  category: widget.productModel.category,
                                ));
                          },
                        ),
                      ],
                    );
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return alertUpload;
                      },
                    );
                  }
                  else
                    navigateTo(context, EnterHeightScreen(
                      category: widget.productModel.category,
                    ));
                }
                else{
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return alertLogin(
                        context: context,
                        title: 'Login First to Use This Feature'
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
      recommendedSize!=null?
        Padding(
          padding: const EdgeInsets.only(left: 25.0),
          child: Row(
            children: [
              Text(
                'Recommended Size:  ',
                style: Theme
                    .of(context)
                    .textTheme
                    .caption,
              ),
              Text(
                recommendedSize,
                style: Theme
                    .of(context)
                    .textTheme
                    .subtitle1,
              ),
          ],
        ),
      )
          :Container(),

      Container(
        padding: EdgeInsets.symmetric(horizontal: 25,vertical: 10),
        height: 65,
        child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context,index)=>GestureDetector(
              onTap: (){
                setState(() {
                  widget.currentSelected=index;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                decoration: BoxDecoration(
                  color: widget.currentSelected==index? Theme.of(context).focusColor.withOpacity(0.8):Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                      color: Colors.grey.withOpacity(0.4)
                  ),
                ),
                child: Text(
                  widget.productModel.sizes[index],
                  style: TextStyle(
                    color:Theme.of(context).textTheme.bodyText1!.color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            separatorBuilder: (context,index)=>SizedBox(width: 10,),
            itemCount: widget.productModel.sizes.length
        ),
      ),
    ],
  );

  Widget addCart({
    required myContext,
    required cubit,
  })=>Container(
    padding: EdgeInsets.all(25),
    child: Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            textUtils(
                text: 'price',
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.grey
            ),
            Text(
              '\$ ${widget.productModel.price}',
              style: TextStyle(
                color: Theme.of(myContext).textTheme.bodyText1!.color,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                height: 1.5,
              ),
            ),
          ],
        ),
        SizedBox(width: 20,),
        Expanded(
          child: SizedBox(
            height: 60,
            child: ElevatedButton(
              onPressed: (){
                cubit.addProductToCart(
                    OrderModel(
                      photo:widget.productModel.photos[0],
                      description:widget.productModel.description,
                      productName: widget.productModel.productName,
                      productUid: widget.productModel.productUid,
                      quantity: 1,
                      price: widget.productModel.price,
                      size: widget.productModel.sizes[widget.currentSelected],
                      color: widget.productModel.colors[currentColor],
                      brandId: widget.productModel.brandId,
                    )
                );
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 0,
                primary: Theme.of(myContext).focusColor,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Add to Cart',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 10,),
                  Icon(Icons.shopping_cart_outlined,size: 20,),
                ],
              ),
            ),
          ),
        )
      ],
    ),
  );

}
