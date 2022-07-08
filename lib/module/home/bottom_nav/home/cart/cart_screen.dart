import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shoppy/layout/cubit/cubit.dart';
import 'package:shoppy/layout/cubit/states.dart';
import 'package:shoppy/model/address_model.dart';
import 'package:shoppy/model/order_model.dart';
import 'package:shoppy/model/product_model.dart';
import 'package:shoppy/module/ar/skin_color_picker.dart';
import 'package:shoppy/module/home/bottom_nav/home/cart/payment_screen.dart';
import 'package:shoppy/module/home/product_screen/product_screen.dart';
import 'package:shoppy/module/home/profile/user_managment/user_addresses/location/user_location_map_screen.dart';
import 'package:shoppy/shared/components/components.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CartScreen extends StatelessWidget {
  late AlertDialog alertAddress;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShoppyCubit,ShoppyStates>(
      listener: (context,state){},
      builder: (context,state){
        var cubit=ShoppyCubit.get(context);
        alertAddress = AlertDialog(
          title: Text(
            "${AppLocalizations.of(context)!.selectAddress}",
            style:Theme.of(context).textTheme.bodyText1!.copyWith(color: Color(0xffec8d2f)),
          ),
          content: Container(
            height: 120,
            child: ListView.separated(
              itemBuilder: (context, index) =>index==cubit.userAddresses.length?
                addAddressItem(
                  context: context
                )
                :addressAlertItem(
                  cubit:cubit,
                  context: context,
                  addressModel: cubit.userAddresses[index],
                  index: index
                ),
              separatorBuilder: (context, index) =>Divider(
                height: 3,
                color: Color(0xffec8d2f).withOpacity(0.5),
              ),
              itemCount: cubit.userAddresses.length+1,
            ),
          ),
          backgroundColor: Color(0xff1e224c),
          actions: [
            TextButton(
              child: Text(
                "${AppLocalizations.of(context)!.no}",
                style: TextStyle(
                  color: Color(0xffec8d2f),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text(
                  "${AppLocalizations.of(context)!.oK}",
                  style: TextStyle(
                    color: Color(0xffec8d2f),
                  )
              ),
              onPressed: ()async{
                navigateTo(context, PaymentScreen(cubit.cartTotal,cubit.userAddresses[cubit.radioIndex]));
              },
            ),
          ],
        );
        return SafeArea(
            child: Scaffold(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              appBar: AppBar(
                title: Text('${AppLocalizations.of(context)!.cartItems}'),
                centerTitle: true,
                elevation: 0,
                backgroundColor: Theme.of(context).focusColor,
                actions: [
                  cubit.cart.isNotEmpty?IconButton(
                    onPressed: (){
                      ProductModel product=cubit.products.where((element) => element.productUid==cubit.cart.first.productUid).first;
                      int color=int.parse(cubit.cart.first.color);
                      navigateTo(context, SkinColorPicker(product,color));
                    },
                    icon: FaIcon(FontAwesomeIcons.tshirt),
                  ):SizedBox(),
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
                  text: '${AppLocalizations.of(context)!.total}',
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey
              ),
              Text(
                '${cubit.cartTotal.toStringAsFixed(2)}',
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
                onPressed: ()async{
                  await cubit.checkOrderProducts().then((value){
                    print(value);
                    if(value){
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return alertAddress;
                        },
                      );
                    }
                    else{
                      defaultSnackBar(context: context, title: 'Some Products Quantity are currently not available', color: Colors.red);
                    }
                  });
                  /**/
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
                      '${AppLocalizations.of(context)!.checkOut}',
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
    required OrderModel orderModel,
    required context,
  })=>InkWell(

    onTap: (){
      ProductModel productModel=cubit.products.where((element) => element.productUid==orderModel.productUid).first;
      int index=productModel.data.keys.toList().indexWhere((element) => element==orderModel.size);
      navigateTo(context, ProductScreen(productModel)..customSelect(index));
    },
    child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
        height: 130,
        width: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color:Theme.of(context).cardColor,
          border:cubit.notAvailableOrders.where((element) => element.cartId==orderModel.cartId).isNotEmpty?Border.all(color: Color(4294901760),width: 2):null
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
                  image:NetworkImage(orderModel.photo),
                  fit: BoxFit.cover,
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
                  height: 5,
                ),
                Row(
                  children: [
                    Text(
                      '${AppLocalizations.of(context)!.color}',
                      style: Theme.of(context).textTheme.caption
                    ),
                    SizedBox(width: 2,),
                    Container(
                      color: Color(int.parse(orderModel.color)),
                      width: 10,
                      height: 10,
                    )
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  '${AppLocalizations.of(context)!.size}'+orderModel.size,
                  style: Theme.of(context).textTheme.caption
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  '${(orderModel.price*orderModel.quantity).toStringAsFixed(2)}',
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
                      color: Theme.of(context).focusColor,
                    ),
                  ),
                  Text(
                    '${orderModel.quantity}',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyText1!.color,
                      fontWeight: FontWeight.bold,
                      fontSize: 14
                    ),
                  ),
                  IconButton(
                    onPressed: ()async{
                      await cubit.updateProductQuantity(
                        orderModel.brandId,
                        orderModel.productUid,
                        orderModel.size,
                        orderModel.color,
                      ).then((val){
                        int availableQuantity=int.parse(cubit.products[cubit.products.indexWhere((element) => element.productUid==orderModel.productUid)].data[orderModel.size][orderModel.color]);
                        if(availableQuantity>orderModel.quantity) {
                          cubit.addProductToCart(orderModel);
                        }
                        else{
                          defaultSnackBar(context: context, title: '${AppLocalizations.of(context)!.noMoreAvailableItemsOfThisColor}', color: Colors.black);
                        }
                      });
                    },
                    icon: Icon(
                      Icons.add_circle,
                      color:int.parse(cubit.products[cubit.products.indexWhere((element) => element.productUid==orderModel.productUid)].data[orderModel.size][orderModel.color])>orderModel.quantity?
                        Theme.of(context).focusColor
                          :Theme.of(context).focusColor.withOpacity(0.3),
                    ),
                  )
                ],
              ),
              IconButton(
                icon: Icon(
                  Icons.delete,
                  size: 24,
                  color: Theme.of(context).focusColor.withOpacity(0.5),
                ),
                onPressed: () {
                  cubit.removeOneProductFromCart(orderModel);
                },
              )
            ],
          )
        ],
      ),
    ),
  );

  //ui if card is empty
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
                  text: '${AppLocalizations.of(context)!.yourCartIs}',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyText1!.color,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: '${AppLocalizations.of(context)!.empty}',
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
          '${AppLocalizations.of(context)!.addItemToGetStarted}',
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
              '${AppLocalizations.of(context)!.goToHome}',
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

  //alert dialog code to pick up address
  Widget addressAlertItem({
  required AddressModel addressModel,
  required context,
  required cubit,
  required int index,
})=>Padding(
  padding: const EdgeInsets.only(bottom:5, top: 2),
  child: InkWell(
    onTap: (){
      cubit.changeIndex(index);
    },
    child: Row(
        children: [
          Expanded(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    addressModel.cityName,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 12,color: Colors.white),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    '${addressModel.streetName}, ${addressModel.buildingNumber}, ${addressModel.floorNumber}, ${addressModel.apartmentNumber}',
                    style: Theme.of(context).textTheme.headline1!.copyWith(fontSize: 10),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Mobile: '+addressModel.phoneNumber,
                    style: Theme.of(context).textTheme.headline1!.copyWith(fontSize: 10),
                  ),
                ],
              ),
            ),
          ),
          Radio(
            value: index,
            groupValue: cubit.radioIndex,
            fillColor: MaterialStateColor.resolveWith((states) => Theme.of(context).focusColor),
            onChanged: (Object? value) {
              cubit.changeIndex(value);
            },
          ),
        ],
      ),
  ),
);

  //add new address ui
  Widget addAddressItem({
  required context,
})=>InkWell(
    onTap: (){
      navigateTo(context, UserLocationMapScreen(
        isCart: true,
      ));
    },
    child: Container(
        child:Row(
          children: [
            Expanded(
              child: Text(
                '${AppLocalizations.of(context)!.addAddress}',
                style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 12,color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Icon(
                Icons.add,
                color: Theme.of(context).focusColor,
              ),
            )
          ],
        )
    ),
  );
}
