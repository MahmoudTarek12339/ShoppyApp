import 'package:flutter/material.dart';

class WishListScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body:Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: ListView.separated(
            itemBuilder: (context,index)=>buildFavItem(
              image: 'https://fakestoreapi.com/img/71-3HjGNDUL._AC_SY879._SX._UX._SY._UY_.jpg',
              price: 55.23,
              productId: 1,
              title: 'Men\'s T-shirt',
              context:context,
            ),
            separatorBuilder: (context,index)=>Divider(color: Colors.grey,),
            itemCount: 6,),
        )
    );
  }
  buildFavItem({
    required String image,
    required String title,
    required double price,
    required int productId,
    required context,
  }){
    return Padding(
      padding: EdgeInsets.all(10),
      child: SizedBox(
        width: double.infinity,
        height: 100,
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
                    image,
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
                    title,
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
                    '\$ $price',
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
                //controller.manageFavorites(productId);
              },
              icon: Icon(Icons.favorite,color: Colors.red,size: 30,),
            ),
          ],
        ),
      ),
    );
  }
}
