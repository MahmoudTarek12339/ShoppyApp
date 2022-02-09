
import 'package:badges/badges.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:readmore/readmore.dart';
import 'package:shoppy/shared/components/components.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../model/product_model.dart';


class ProductScreen extends StatefulWidget {
  ProductModel productModel;
  ProductScreen(this.productModel);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  //final ProductScreen productModel;
  //final List<String> sizesList= as List<String> ;
  int currentSelected=0;
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body:SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              imageSlider(),
              clothesInfo(
                context: context,
                title: widget.productModel.productName,
                description: widget.productModel.description,
                rate: widget.productModel.rate,
              ),
              sizeList(),
              addCart(myContext: context),
            ],
          ),
        ),
      ),
    );
  }


  Widget imageSlider()=>Stack(
    children: [
      CarouselSlider.builder(
        itemCount: 3,
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
                    'https://fakestoreapi.com/img/71-3HjGNDUL._AC_SY879._SX._UX._SY._UY_.jpg',
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
            count: 3,
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
                position: BadgePosition.topEnd(top: -7, end: -2),
                animationType:BadgeAnimationType.slide,
                badgeContent: Text(
                  '0',
                  style: TextStyle(color: Colors.white),
                ),
                child: InkWell(
                  onTap: (){
                    //Get.toNamed(Routes.cartScreen);
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
    required description
  })=>Container(
    padding: EdgeInsets.symmetric(horizontal: 25,vertical: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(.4),
                shape: BoxShape.circle,
              ),
              child: InkWell(
                  onTap: (){
                    //controller.manageFavorites(productId);
                  },
                  child:Icon(
                    Icons.favorite,
                    color: Colors.red,
                  )
              ),
            ),
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

  Widget sizeList()=>Container(
    padding: EdgeInsets.symmetric(horizontal: 25,vertical: 10),
    height: 65,
    child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context,index)=>GestureDetector(
          onTap: (){
            setState(() {
              currentSelected=index;
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
            decoration: BoxDecoration(
              color: currentSelected==index? Theme.of(context).focusColor.withOpacity(0.4):Theme.of(context).primaryColor,
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
  );

  Widget addCart({
    required myContext
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
              '\$ 20.35',
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
                //controller.addProductToCart(productModel);
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
