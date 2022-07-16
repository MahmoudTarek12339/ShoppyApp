

import 'package:badges/badges.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:readmore/readmore.dart';
import 'package:shoppy/layout/cubit/cubit.dart';
import 'package:shoppy/layout/cubit/states.dart';
import 'package:shoppy/model/order_model.dart';
import 'package:shoppy/model/product_model.dart';
import 'package:shoppy/module/ar/skin_color_picker.dart';
import 'package:shoppy/module/home/bottom_nav/category/category_products_screen.dart';
import 'package:shoppy/shared/components/components.dart';
import 'package:shoppy/shared/network/local/cache_helper.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


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
  final GlobalKey _one=GlobalKey();
  final GlobalKey _two=GlobalKey();
  final GlobalKey _three=GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShoppyCubit,ShoppyStates>(
      listener:(context,state){
      } ,
      builder:(context,state){
        final bool showCaseBool =CacheHelper.getData(key: 'Screen2')??true;
        return SafeArea(
          child: ShowCaseWidget(
            onFinish: (){
              CacheHelper.saveData(
                  key: 'Screen2',
                  value: false).then((value){
              });
            },
            builder: Builder(
              builder: (context) {
                if(showCaseBool){
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ShowCaseWidget.of(context)!.startShowCase([_one, _two,_three]);
                  });
                }
                return Scaffold(
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
                            colorList(),
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
                );
              }
            ),
          ),
        );
      } ,
    );
  }

  Widget colorList()=>Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${AppLocalizations.of(context)!.chooseYourColor}',
          style: Theme.of(context).textTheme.caption,
        ),
        SizedBox(
          height: 15,
        ),
        Showcase(
          key: _two,
          description: '${AppLocalizations.of(context)!.pickupColorFromHere}',
          descTextStyle: Theme.of(context).textTheme.bodyText1!.copyWith(color:Colors.white),
          showcaseBackgroundColor: Theme.of(context).focusColor,
          child: Container(
            width: widget.productModel.data[widget.productModel.data.keys.toList()[widget.currentSelected]]!.keys.length*50.0,
            height: 50,
            margin: EdgeInsets.only(left: 5),
            padding: EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(25)
            ),
            child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context,index)=>GestureDetector(
                  onTap: (){
                    setState(() {
                      currentColor=index;
                    });
                  },
                  child: colorPicker(
                    index: index,
                  ),
                ),
                separatorBuilder: (context,index)=>SizedBox(width: 3,),
                itemCount: widget.productModel.data[widget.productModel.data.keys.toList()[widget.currentSelected]]!.keys.length),
          ),
        ),
      ],
    ),
  );
  Widget imageSlider()=>Stack(
    alignment: Alignment.bottomCenter,
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
      Center(
        heightFactor: 6,
        child: AnimatedSmoothIndicator(

          activeIndex: currentPage,
          count: widget.productModel.photos.length,
          effect: ExpandingDotsEffect(
            dotHeight: 7,
            dotWidth: 7,
            activeDotColor: Theme.of(context).focusColor,
            dotColor: Colors.black ,
          ),
        ),
      ),
    ],
  );

  Widget colorPicker({
    required index,
  }){
    return Container(
      padding: EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: currentColor==index?Border.all(color: Color(
            int.parse(widget.productModel.data[widget.productModel.data.keys.toList()[widget.currentSelected]]!.keys.toList()[currentColor]))
            ,width: 2
        ):null,
      ),
      child:Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Color(
              int.parse(
                  widget.productModel.data[widget.productModel.data.keys.toList()[widget.currentSelected]]!.keys.toList()[index])),
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
    padding: EdgeInsets.symmetric(horizontal: 17,vertical: 10),
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
              padding: const EdgeInsets.all(5.0),
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
            Spacer(),
            Showcase(
              key: _three,
              descTextStyle: Theme.of(context).textTheme.bodyText1!.copyWith(color:Colors.white),
              showcaseBackgroundColor: Theme.of(context).focusColor,
              description: '${AppLocalizations.of(context)!.pressHereToReviewProduct}',
              child: ElevatedButton(
                child: Text(
                  '${AppLocalizations.of(context)!.previewProduct}',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                style: ElevatedButton.styleFrom(primary: Theme.of(context).cardColor,),
                onPressed: (){
                  String c=widget.productModel.data[widget.productModel.data.keys.toList()[widget.currentSelected]]!.keys.toList()[currentColor];
                  String size=widget.productModel.data.keys.toList()[widget.currentSelected];
                  if(widget.productModel.virtualImage.keys.contains(c)){
                    navigateTo(context, SkinColorPicker(widget.productModel,int.parse(widget.productModel.data[widget.productModel.data.keys.toList()[widget.currentSelected]]!.keys.toList()[currentColor]),size));
                  }
                  else{
                    defaultSnackBar(context: context, title: 'No Virtual Image available for selected color ', color: Colors.grey);
                  }
                },
              ),
            ),
          ],
        ),
        ReadMoreText(
          description,
          trimLines: 3,
          trimMode: TrimMode.Line,
          textAlign: TextAlign.center,
          trimCollapsedText: '${AppLocalizations.of(context)!.showMore}',
          trimExpandedText: '${AppLocalizations.of(context)!.showLess}',
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
       padding: const EdgeInsets.only(left: 15.0,right: 20),
       child: Row(
         mainAxisAlignment: MainAxisAlignment.spaceBetween,
         children: [
           Text(
             '${AppLocalizations.of(context)!.chooseYourSize}',
             style: Theme.of(context).textTheme.caption,
           ),
           Showcase(
             key: _one,
             description: '${AppLocalizations.of(context)!.clickHereIfYouDoNotKnowYourSizes}',
             descTextStyle: Theme.of(context).textTheme.bodyText1!.copyWith(color:Colors.white),
             showcaseBackgroundColor: Theme.of(context).focusColor,
             child: ElevatedButton(
               child: Text(
                 '${AppLocalizations.of(context)!.sizeGuide}',
                 style: Theme.of(context).textTheme.subtitle1,
               ),
               style: ElevatedButton.styleFrom(primary: Theme.of(context).cardColor),
               onPressed: (){
                 if(FirebaseAuth.instance.currentUser!=null){
                   if (recommendedSize != null) {
                     AlertDialog alertUpload = AlertDialog(
                       title: Text(
                         "${AppLocalizations.of(context)!.sizeGuide}",
                         style: Theme.of(context)
                             .textTheme
                             .bodyText1!
                             .copyWith(color: Theme.of(context).focusColor),
                       ),
                       content: Column(
                         mainAxisSize: MainAxisSize.min,
                         children: [
                           Text("${AppLocalizations.of(context)!.youAlreadyHaveARecommendedSize}",
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
                             '${AppLocalizations.of(context)!.cancel}',
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
                             "${AppLocalizations.of(context)!.addNew}",
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
                         title: '${AppLocalizations.of(context)!.loginFirstToUseThisFeature}'
                       );
                     },
                   );
                 }
               },
             ),
           ),
         ],
       ),
     ),
     recommendedSize!=null?
       Padding(
         padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 5),
         child: Row(
           children: [
             Text(
               '${AppLocalizations.of(context)!.recommendedSize}',
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
         :SizedBox(),
     Container(
       padding: EdgeInsets.symmetric(horizontal: 20),
       height: 50,
       child: ListView.separated(
           scrollDirection: Axis.horizontal,
           itemBuilder: (context,index)=>GestureDetector(
             onTap: (){
               setState(() {
                 currentColor=0;
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
                 widget.productModel.data.keys.toList()[index],
                 style: TextStyle(
                   color:Theme.of(context).textTheme.bodyText1!.color,
                   fontWeight: FontWeight.bold,
                 ),
               ),
             ),
           ),
           separatorBuilder: (context,index)=>SizedBox(width: 10,),
           itemCount: widget.productModel.data.keys.length
       ),
     ),
     SizedBox(
       height: 10,
     )
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
                text: '${AppLocalizations.of(context)!.price}',
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.grey
            ),
            Text(
              '${widget.productModel.price}',
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
              onPressed: ()async{
                cubit.updateProductQuantity(
                  widget.productModel.brandId,
                  widget.productModel.productUid,
                  widget.productModel.data.keys
                      .toList()[widget.currentSelected],
                  widget
                      .productModel
                      .data[widget.productModel.data.keys
                      .toList()[widget.currentSelected]]!
                      .keys
                      .toList()[currentColor],
                );
                int availableQuantity=int.parse(widget.productModel.data[widget.productModel.data.keys.toList()[widget.currentSelected]]!.values.toList()[currentColor]);
                if(availableQuantity>0) {
                  cubit.addProductToCart(OrderModel(
                    photo: widget.productModel.photos[0],
                    description: widget.productModel.description,
                    productName: widget.productModel.productName,
                    productUid: widget.productModel.productUid,
                    quantity: 1,
                    price: widget.productModel.price,
                    size: widget.productModel.data.keys
                        .toList()[widget.currentSelected],
                    color: widget
                        .productModel
                        .data[widget.productModel.data.keys
                            .toList()[widget.currentSelected]]!
                        .keys
                        .toList()[currentColor],
                    brandId: widget.productModel.brandId,
                  ));
                }
                else{
                  defaultSnackBar(context: context, title: '${AppLocalizations.of(context)!.noMoreAvailableItemsOfThisColor}', color: Colors.black);
                }
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 0,
                primary:int.parse(widget.productModel.data[widget.productModel.data.keys.toList()[widget.currentSelected]]!.values.toList()[currentColor])>0?
                  Theme.of(myContext).focusColor:Theme.of(myContext).focusColor.withOpacity(0.2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      int.parse(widget.productModel.data[widget.productModel.data.keys.toList()[widget.currentSelected]]!.values.toList()[currentColor])>0?
                      '${AppLocalizations.of(context)!.addToCart}':'${AppLocalizations.of(context)!.soldOut}',
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
