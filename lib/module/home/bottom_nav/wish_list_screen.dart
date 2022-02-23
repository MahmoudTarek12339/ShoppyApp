import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoppy/layout/cubit/cubit.dart';
import 'package:shoppy/layout/cubit/states.dart';
import 'package:shoppy/model/product_model.dart';
import 'package:shoppy/module/home/product_screen/product_screen.dart';
import 'package:shoppy/shared/components/components.dart';

class WishListScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShoppyCubit,ShoppyStates>(
      listener: (context,state){},
      builder: (context,state){
        var cubit=ShoppyCubit.get(context);
        return cubit.favorites.isEmpty?
                       Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: Image.asset('assets/images/heart.png'),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Please, Add your Favorite Products',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.bodyText1!.color,
                          fontSize: 17.0,
                        ),
                      ),

                    ],
                  ),
                )
                      :Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body:Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: ListView.separated(
                itemBuilder: (context,index)=>buildFavItem(
                  productModel: cubit.products.where((element) => element.productUid==cubit.favorites[index]).first,
                  context:context,
                ),
                separatorBuilder: (context,index)=>SizedBox(height: 1,),
                itemCount: cubit.favorites.length,),
            )
        );
      },
    );
  }
  buildFavItem({
    required ProductModel productModel,
    required context,
  }){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
      child: InkWell(
        onTap: (){
          navigateTo(context, ProductScreen(productModel));
        },
        child: Container(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color:Theme.of(context).cardColor,
          ),
          width: double.infinity,
          height: 100,
          child: Padding(
            padding: const EdgeInsets.all(1.0),
            child: Row(
              children: [
                SizedBox(
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Image.network(
                        productModel.photos[0],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  flex: 10,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        productModel.productName,
                        style: TextStyle(
                          color:Theme.of(context).textTheme.bodyText1!.color,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        '\$ ${productModel.price}',
                        style: TextStyle(
                          color:Theme.of(context).textTheme.bodyText1!.color,
                          overflow: TextOverflow.ellipsis,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: (){
                    ShoppyCubit.get(context).updateWishList(productUid: productModel.productUid);
                  },
                  icon: Icon(Icons.favorite,color: Colors.red,size: 30,),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
