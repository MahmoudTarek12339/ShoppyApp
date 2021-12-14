import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoppy/layout/cubit/cubit.dart';
import 'package:shoppy/layout/cubit/states.dart';

class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShoppyCubit,ShoppyStates>(
      listener: (context,state){},
      builder: (context,state){
        //var cubit=ShoppyCubit.get(context);
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
                          fit: BoxFit.cover),
                      Image(image:NetworkImage('https://i.pinimg.com/564x/ae/29/14/ae29149d86039e2c1b536a515bca1eb2.jpg'),width: double.infinity,
                          fit: BoxFit.cover),
                      Image(image:NetworkImage('https://i.pinimg.com/564x/b8/af/6b/b8af6b66d8d1aaa3251d5b1ff7cc62c4.jpg'),width: double.infinity,
                          fit: BoxFit.cover),
                      Image(image:NetworkImage('https://i.pinimg.com/736x/71/9a/a0/719aa07defbe8a2958ee74602bc19557.jpg'),width: double.infinity,
                          fit: BoxFit.cover),
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
                  height: 5,
                ),
                Text(
                  ' For you',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                SizedBox(
                  height: 5.0,
                ),
                Container(
                  height: 150,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context,index)=>buildProductItem(),
                    separatorBuilder: (context,index)=>SizedBox(width: 10.0,),
                    itemCount: 5),
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
                  height: 5.0,
                ),
                Container(
                  height: 150,
                  child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context,index)=>buildProductItem(),
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
                  height: 5.0,
                ),
                Container(
                  height: 150,
                  child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context,index)=>buildProductItem(),
                      separatorBuilder: (context,index)=>SizedBox(width: 10.0,),
                      itemCount: 5),
                ),
                //random images
                SizedBox(
                  height: 35.0,
                ),
                Container(
                  child: GridView.count(crossAxisCount: 2,
                    shrinkWrap: true,
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 10.0,
                    childAspectRatio: 1/1.25,
                    physics: NeverScrollableScrollPhysics(),
                    children: List.generate(12,(index)=>buildProductItem()),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildProductItem() =>Card(
    clipBehavior: Clip.antiAliasWithSaveLayer,
    elevation: 10.0,
    //margin:,
    child: Image(
      image: NetworkImage('https://i.pinimg.com/564x/e8/be/6e/e8be6e703137738190f71be515088fa0.jpg'),
      fit:BoxFit.cover,
    ),
  );
}
