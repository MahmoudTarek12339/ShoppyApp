
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shoppy/layout/cubit/cubit.dart';
import 'package:shoppy/layout/cubit/states.dart';
import 'package:shoppy/layout/shoppy_layout.dart';
import 'package:shoppy/model/user_orders_model.dart';
import 'package:shoppy/module/home/profile/user_managment/user_orders/order_details_screen.dart';
import 'package:shoppy/shared/components/components.dart';

class OrdersScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShoppyCubit,ShoppyStates>(
      listener: (context,state){
        if(state is ShoppyRemoveFromOrdersSuccessState){
          defaultSnackBar(
            context: context,
            color: Colors.green,
            title: 'Order Cancelled Successfully',
          );
        }
        else if(state is ShoppyRemoveFromOrdersErrorState){
          defaultSnackBar(
            context: context,
            color: Colors.red,
            title: state.error,
          );
        }
        if(state is ShoppySendOrderSuccessState){
          defaultSnackBar(
            context: context,
            color: Colors.green,
            title: 'Re Ordered Successfully',
          );

        }
        else if(state is ShoppySendOrderErrorState){
          defaultSnackBar(
            context: context,
            color: Colors.red,
            title: state.error,
          );
        }
      },
      builder: (context,state){
        var cubit=ShoppyCubit.get(context);
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            title: Text("Orders"),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Theme.of(context).focusColor,
          ),
          body:cubit.userOrders.isEmpty?
            emptyOrders(context: context)
              :ListView.separated(
              padding: EdgeInsets.only(top: 10),
              itemBuilder:(context,index)=> buildOrderCard(
                cubit: cubit,
                context: context,
                userOrderModel: cubit.userOrders[index],
              ),
              separatorBuilder:(context,index)=> SizedBox(),
              itemCount: cubit.userOrders.length),
        );
      },
    );
  }

  Widget buildOrderCard({
    required cubit,
    required UserOrderModel userOrderModel,
    required context,
  })=>InkWell(
    onTap: (){
      navigateTo(context,OrderDetailsScreen(
        userOrderModel:userOrderModel,
      ));
    },
    child: Container(
      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
      height: 120,
      width: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color:Theme.of(context).cardColor
      ),
      child: Row(
        children: [
          Container(
            height: 110,
            width: 100,
            margin: EdgeInsets.only(left: 7),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image:NetworkImage(userOrderModel.orderPhoto),
                  fit: BoxFit.cover,
                )
            ),
          ),
          SizedBox(width: 7,),
          Expanded(
            flex: 15,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userOrderModel.orderState,
                  style: TextStyle(
                    overflow: TextOverflow.ellipsis,
                    color:userOrderModel.orderState=='In Progress'?Colors.redAccent :Colors.green,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  userOrderModel.orderDate,
                  style: Theme.of(context).textTheme.caption
                ),
              ],
            ),
          ),
          SizedBox(
            height: 100,
            child: Align(
              alignment: Alignment.bottomRight,
              child: TextButton(
                onPressed: () {
                  if(userOrderModel.orderState=='In Progress') {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return makeAlert(
                            context: context,
                            cubit: cubit,
                            orderModel: userOrderModel
                        );
                      },
                    );
                  }
                  else{
                    var date=DateFormat.d().add_yMMM().add_Hm().format(DateTime.now());
                    cubit.sendOrder(UserOrderModel(
                        orderState: 'In Progress',
                        orderDate: date,
                        userId: FirebaseAuth.instance.currentUser!.uid,
                        orderPhoto: userOrderModel.orderPhoto,
                        orderPrice: userOrderModel.orderPrice,
                        orders: userOrderModel.orders,
                        addressModel: userOrderModel.addressModel
                    ));
                  }
                  },
                child: Row(
                  children: [
                    Text(
                      userOrderModel.orderState=='Delivered'?'Re-Order':'Cancel',
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(color:Theme.of(context).focusColor),
                    ),
                    if(userOrderModel.orderState=='Delivered')
                      Icon(Icons.refresh,color: Theme.of(context).focusColor,size: 15,)
                  ],
                ),
              )
            ),
          )
        ],
      ),
    ),
  );

  Widget emptyOrders({required context})=>Center(
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
                  text: 'No order ',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyText1!.color,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: 'Placed',
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
          height: 15,
        ),
        Text(
          'order placed will be displayed here',
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyText1!.color,
            fontSize: 12,
          ),

        ),
        SizedBox(
          height: 30,
        ),
        SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed: (){
              navigateAndFinish(context,ShoppyLayout());
            },
            child: Text(
              'Order Now',
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

  AlertDialog makeAlert({
    required context,
    required cubit,
    required UserOrderModel orderModel,
  })=> AlertDialog(
    title: Text(
      "Confirm Cancel",
      style:Theme.of(context).textTheme.bodyText1!.copyWith(color: Theme.of(context).focusColor),
    ),
    content: Text(
        "Are you Sure you Want to Cancel This Order.",
        style:Theme.of(context).textTheme.subtitle1
    ),
    backgroundColor: Theme.of(context).cardColor,
    actions: [
      TextButton(
        child: Text(
          "No",
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
            "OK",
            style: TextStyle(
              color: Theme.of(context).focusColor,
            )
        ),
        onPressed: () {
          cubit.cancelOrder(orderModel);
          Navigator.pop(context);
        },
      ),
    ],
  );

}
