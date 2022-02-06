import 'package:flutter/material.dart';

import '../../shared/components/components.dart';
class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text('Cart Items'),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Theme.of(context).focusColor,
          actions: [
            IconButton(
              onPressed: (){
                //controller.clearAllProducts();
              },
              icon: Icon(Icons.backspace),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: SizedBox(
                height: 600,
                child: ListView.separated(
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) => cartProductCard(
                      index: index,
                      quantity:3,
                      context:context
                    ),
                    separatorBuilder: (context, index) => SizedBox(
                      height: 5,
                    ),
                    itemCount: 5),
              ),
            ),
            cardTotal(context:context),
          ],
        ),
      )
    );
  }

  Widget cardTotal({required context})=>Container(
    child: Padding(
      padding: const EdgeInsets.all(25.0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textUtils(
                  text: 'Total',
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey
              ),
              Text(
                '\$ 150.20',
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText1!.color,
                  fontWeight: FontWeight.bold,
                  height: 1.5,
                  fontSize: 20,
                ),
              )
            ],
          ),
          SizedBox(width: 20,),
          Expanded(
            child: SizedBox(
              height: 60,
              child: ElevatedButton(
                onPressed: (){
                  //Get.toNamed(Routes.paymentScreen);
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 0,
                  primary: Theme.of(context).focusColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Check Out',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 15,),
                    Icon(Icons.shopping_cart,size: 20,),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    ),
  );
  Widget cartProductCard({required index,required quantity,required context})=>Container(
    margin: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
    height: 130,
    width: 100,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color:Theme.of(context).focusColor.withOpacity(0.25),
    ),
    child: Row(
      children: [
        Container(
          height: 120,
          width: 100,
          margin: EdgeInsets.only(left: 15),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: NetworkImage('https://fakestoreapi.com/img/71-3HjGNDUL._AC_SY879._SX._UX._SY._UY_.jpg'),
                fit: BoxFit.cover,
              )
          ),
        ),
        SizedBox(width: 20,),
        Expanded(
          flex: 15,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'black shirt',
                style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  color: Theme.of(context).textTheme.bodyText1!.color,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                '\$ 22.02',
                style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  color:Theme.of(context).textTheme.bodyText1!.color,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: (){
                    //controller.removeProductFromCart(productModel);
                  },
                  icon: Icon(
                    Icons.remove_circle,
                    color: Theme.of(context).textTheme.bodyText1!.color,
                  ),
                ),
                Text(
                  '$quantity',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: (){
                    //controller.addProductToCart(productModel);
                  },
                  icon: Icon(
                    Icons.add_circle,
                    color: Theme.of(context).textTheme.bodyText1!.color
                  ),
                )
              ],
            ),
            IconButton(
              icon: Icon(
                Icons.delete,
                size: 20,
                color: Colors.red,
              ),
              onPressed: () {
                //controller.removeOneProduct(productModel);
              },
            )
          ],
        )
      ],
    ),
  );
}
