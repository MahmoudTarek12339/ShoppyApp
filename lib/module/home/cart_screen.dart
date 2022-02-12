import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoppy/layout/cubit/cubit.dart';
import 'package:shoppy/layout/cubit/states.dart';
import 'package:shoppy/module/home/payment_screen.dart';
import 'package:shoppy/shared/components/components.dart';

class CartScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShoppyCubit,ShoppyStates>(
      listener: (context,state){},
      builder: (context,state){
        var cubit=ShoppyCubit.get(context);
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
                      cubit.clearCart();
                    },
                    icon: Icon(Icons.backspace),
                  ),
                ],
              ),
              body: cubit.cart.isEmpty?
                  emptyCart(context: context)
                  :Column(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 600,
                      child: ListView.separated(
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) => cartProductCard(
                              cubit: cubit,
                              orderModel: cubit.cart[index],
                              context:context
                          ),
                          separatorBuilder: (context, index) => SizedBox(
                            height: 5,
                          ),
                          itemCount: cubit.cart.length),
                    ),
                  ),
                  cardTotal(context:context,cubit: cubit),
                ],
              ),
            )
        );
      },
    );
  }

  Widget cardTotal({
    required context,
    required cubit,
  })=>Container(
    child: Padding(
      padding: const EdgeInsets.all(25.0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textUtils(
                  text: 'total',
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey
              ),
              Text(
                '\$ ${cubit.cartTotal.toStringAsFixed(2)}',
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
                  navigateTo(context, PaymentScreen(cubit.cartTotal));
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

  Widget cartProductCard({
    required cubit,
    required orderModel,
    required context,
  })=>Container(
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
                image:NetworkImage(orderModel.photo),
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
                orderModel.productName,
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
                '\$ ${orderModel.price*orderModel.quantity}',
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
                    cubit.removeProductFromCart(orderModel);
                  },
                  icon: Icon(
                    Icons.remove_circle,
                    color: Theme.of(context).textTheme.bodyText1!.color,
                  ),
                ),
                Text(
                  '${orderModel.quantity}',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: (){
                    cubit.addProductToCart(orderModel);
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
                cubit.clearCart();
              },
            )
          ],
        )
      ],
    ),
  );
}

Widget emptyCart({required context})=>Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(
        Icons.shopping_cart,
        size: 150,
        color: Theme.of(context).textTheme.bodyText1!.color,
      ),
      SizedBox(
        height: 40,
      ),
      RichText(
        text: TextSpan(
            children:[
              TextSpan(
                text: 'Your Cart is ',
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText1!.color,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: 'Empty',
                style: TextStyle(
                  color: Theme.of(context).focusColor,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ]
        ),
      ),
      SizedBox(
        height: 10,
      ),
      Text(
        'Add Item To Get Started',
        style: TextStyle(
          color: Theme.of(context).textTheme.bodyText1!.color,
          fontSize: 15,
        ),

      ),
      SizedBox(
        height: 30,
      ),
      SizedBox(
        height: 50,
        child: ElevatedButton(
          onPressed: (){
            Navigator.pop(context);
          },
          child: Text(
            'Go to Home',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 0,
              primary:Theme.of(context).focusColor
        ),
        ),
      ),
    ],
  ),
);