import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shoppy/layout/cubit/cubit.dart';
import 'package:shoppy/layout/cubit/states.dart';
import 'package:shoppy/model/user_orders_model.dart';
import 'package:shoppy/shared/components/components.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OrderDetailsScreen extends StatelessWidget {
  final UserOrderModel userOrderModel;
  OrderDetailsScreen({
    required this.userOrderModel,
  });

  @override
  Widget build(BuildContext context) {
    print(userOrderModel.orderPrice);
    return BlocConsumer<ShoppyCubit,ShoppyStates>(
      listener: (context,state){},
      builder: (context,state){
        var cubit=ShoppyCubit.get(context);
        return SafeArea(
            child: Scaffold(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              appBar: AppBar(
                title: Text('Order Details'),
                centerTitle: true,
                elevation: 0,
                backgroundColor: Theme.of(context).focusColor,
              ),
              body: Column(
                children: [
                  Expanded(
                    child: SizedBox(
                      child: ListView.separated(
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) => orderProductCard(
                              cubit: cubit,
                              orderModel: userOrderModel.orders[index],
                              context:context
                          ),
                          separatorBuilder: (context, index) => SizedBox(
                            height: 5,
                          ),
                          itemCount:userOrderModel.orders.length),
                    ),
                  ),
                  cardTotal(
                    context: context,
                    cubit: cubit,
                    totalPrice: userOrderModel.orderPrice,
                  )
                ],
              ),
            )
        );
      },
    );
  }
  Widget orderProductCard({
    required cubit,
    required orderModel,
    required context,
  })=>Container(
    margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
    height: 130,
    width: 100,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color:Theme.of(context).cardColor,
    ),
    child: Row(
      children: [
        Container(
          height: 120,
          width: 100,
          margin: EdgeInsets.only(left: 5),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image:NetworkImage(orderModel.photo,),
                fit: BoxFit.cover
          )

          ),
        ),
        SizedBox(width: 10,),
        Expanded(
          flex: 15,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Text(
                  orderModel.productName,
                  style: TextStyle(
                    overflow: TextOverflow.ellipsis,
                    color: Theme.of(context).textTheme.bodyText1!.color,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                '${orderModel.quantity} pieces',
                style: Theme.of(context).textTheme.caption,
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget cardTotal({
    required context,
    required cubit,
    required totalPrice,
  })=>Container(
    child: Padding(
      padding: const EdgeInsets.all(25.0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textUtils(
                  text: '${AppLocalizations.of(context)!.total}',
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey
              ),
              Text(
                '$totalPrice',
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
                    cubit.deleteOrder(userOrderModel);
                    Navigator.pop(context);
                  }
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
                      userOrderModel.orderState!='${AppLocalizations.of(context)!.inProgress}'?'${AppLocalizations.of(context)!.delete}':'${AppLocalizations.of(context)!.cancel}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
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
