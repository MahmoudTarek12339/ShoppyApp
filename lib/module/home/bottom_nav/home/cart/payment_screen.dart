

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pay/pay.dart';
import 'package:shoppy/layout/cubit/cubit.dart';
import 'package:shoppy/layout/cubit/states.dart';
import 'package:shoppy/layout/shoppy_layout.dart';
import 'package:shoppy/model/address_model.dart';
import 'package:shoppy/model/user_orders_model.dart';
import 'package:shoppy/shared/components/components.dart';

class PaymentScreen extends StatefulWidget {
  final double total;
  final AddressModel userAddress;
  PaymentScreen(this.total,this.userAddress);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {

  int radioPaymentIndex = 0;

  @override
  Widget build(BuildContext context) {

    final _paymentItems = <PaymentItem>[
      PaymentItem(
        label: 'Cart total Price',
        amount: '${widget.total}',
        status: PaymentItemStatus.final_price,
      ),
      PaymentItem(
        label: 'Delivery',
        amount: '12.0',
        status: PaymentItemStatus.final_price,
      ),
      PaymentItem(
        label: 'total',
        amount: '${widget.total+12}',
        status: PaymentItemStatus.final_price,
      ),
    ];

    Map<String,String> titles={
      'Google Pay':'assets/payments/googlepay.png',
      ' Cash':'assets/payments/cash.svg',
    };

    return BlocConsumer<ShoppyCubit,ShoppyStates>(
      listener: (context,state){
        if(state is ShoppySendOrderSuccessState){
          defaultSnackBar(
            context: context,
            color: Colors.green,
            title: 'Order order \'ll be there within Three Days ',
          );
          ShoppyCubit.get(context).clearCart();
          navigateAndFinish(context, ShoppyLayout());
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
        AlertDialog alertPayment = AlertDialog(
          title: Text(
            "Confirm Purchase",
            style:Theme.of(context).textTheme.bodyText1!.copyWith(color: Theme.of(context).focusColor),
          ),
          content: Text(
              "Are you Sure you Want to Buy On This Way.",
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
                var date=DateFormat.d().add_yMMM().add_Hm().format(DateTime.now());
                cubit.sendOrder(
                    UserOrderModel(
                      orderPhoto: cubit.cart[0].photo,
                      orderPrice: widget.total,
                      orderDate: date.toString(),
                      userId: FirebaseAuth.instance.currentUser!.uid,
                      orderState: 'In Progress',
                      orders: cubit.cart,
                      addressModel:widget.userAddress,
                    )
                );
              },
            ),
          ],
        );

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            title: Text('Payment'),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Theme.of(context).focusColor,
          ),
          body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                textUtils(
                  text: 'Select your Payment Method',
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyText1!.color,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 100,
                  child: ListView.separated(
                      itemBuilder:(context,index)=>buildRadioPayment(
                          icon: titles[titles.keys.toList()[index]]??'',
                          name: titles.keys.toList()[index],
                          index: index
                      ),
                      separatorBuilder:(context,index)=> SizedBox(height: 5,),
                      itemCount: 2
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Spacer(),
                Center(
                  child: textUtils(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    text: 'Total: ${widget.total.toStringAsFixed(2)}\$',
                    color: Theme.of(context).textTheme.bodyText1!.color,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                  child: SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                          onPressed: (){
                            if(radioPaymentIndex==1){
                              if (!(state is ShoppySendOrderLoadingState)) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return alertPayment;
                                  },
                                );
                              }
                            }
                            else{
                              Pay.withAssets(['gpay.json'])
                                  .showPaymentSelector(paymentItems: _paymentItems)
                                  .whenComplete(() {
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 0,
                            primary: Theme.of(context).focusColor,
                          ),
                          child:state is ShoppySendOrderLoadingState?
                          Center(child:CircularProgressIndicator(color: Colors.white,))
                              : Text(
                            radioPaymentIndex==0?'Pay Now':'Order Now',
                            style: TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                            ),
                          ),
                        ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildRadioPayment({
    required String icon,
    required String name,
    required int index,
  }) {
    return InkWell(
      onTap: (){
        setState(() {
          radioPaymentIndex = index;
        });
      },
      child: Container(
        padding: EdgeInsets.only(left: 2),
        height: 50,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 1.0),
                  child: index!=1?Image.asset(
                    icon,
                    width: 35,
                    height: 35,
                  ):
                  FaIcon(FontAwesomeIcons.moneyBillWave,color: Colors.green,size: 25,),
                ),
                const SizedBox(
                  width: 10,
                ),
                textUtils(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  text: name,
                  color: Theme.of(context).textTheme.caption!.color,
                ),
              ],
            ),
            Radio(
              value: index,
              groupValue: radioPaymentIndex,
              fillColor: MaterialStateColor.resolveWith((states) => Theme.of(context).focusColor),
              onChanged: (int? value) {
                setState(() {
                  radioPaymentIndex = value!;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void onGooglePayResult(paymentResult) {
    // Send the resulting Google Pay token to your server / PSP
    defaultSnackBar(
      context: context,
      color: Colors.green,
      title: 'Order order \'ll be there within Three Days ',
    );
    ShoppyCubit.get(context).clearCart();
    navigateAndFinish(context, ShoppyLayout());
  }
}
