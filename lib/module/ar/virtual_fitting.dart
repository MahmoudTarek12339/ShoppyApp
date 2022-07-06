import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoppy/layout/cubit/cubit.dart';
import 'package:shoppy/layout/cubit/states.dart';
import 'package:shoppy/model/product_model.dart';

class VirtualFittingScreen extends StatelessWidget {
  final int index;
  final ProductModel product;
  final int selectedColor;
  const VirtualFittingScreen({required this.index,required this.product,required this.selectedColor});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShoppyCubit, ShoppyStates>(
        builder: ((context, state) {
          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: AppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            ),
            body: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Stack(
                children: [
                  InkWell(
                    onTap: () {
                      ShoppyCubit.get(context).changeVisibilityVirtual();
                    },
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: Image.asset(
                      'assets/skins/model${index + 1}.png',
                      height: double.infinity,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  if (ShoppyCubit.get(context).vis)
                    Positioned(
                      bottom:100,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Container(
                          height: 120,
                          width:320,
                          child: ShoppyCubit.get(context).cart.isNotEmpty?
                             ListView.separated(
                          scrollDirection:Axis.horizontal,
                          itemBuilder: (context, index) => productItem(
                            productUid: ShoppyCubit.get(context).cart[index].productUid,
                            context: context,
                            color: int.parse(ShoppyCubit.get(context).cart[index].color),
                          ),
                          separatorBuilder: (context, index) => SizedBox(width: 15,),
                          itemCount: ShoppyCubit.get(context).cart.length,
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                        )
                            :Container(
                            color: Colors.grey.withOpacity(0.5),
                            child: Center(child: Text(
                              'Your Cart is Empty',
                              style: Theme.of(context).textTheme.bodyText1,
                            )),
                          ),
                        ),
                      ),
                    )
                ],
              ),
            ),
          );
        }),
        listener: (context, state) {});
  }

  Widget productItem({required String productUid,required context,required int color}) {
    print(color);
    print(ShoppyCubit.get(context).products
        .where((element) => element.productUid==productUid).first.virtualImage);
    String? image=ShoppyCubit.get(context).products
        .where((element) => element.productUid==productUid).first.virtualImage[color.toString()];
    return image!=null? InkWell(
      onTap: () {},
      child: Container(
        height: 150.0,
        width: 120.0,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 3.0,
                  blurRadius: 5.0),
            ]),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Image.network(
            image,
            fit: BoxFit.fitHeight,
            loadingBuilder: (context, child, loadingProgress) =>
            loadingProgress == null
                ? child
                : Center(child: CircularProgressIndicator()),
            errorBuilder: (context, error, stackTrace) =>
            new Image.asset('assets/images/default_login2.jpg'),
          ),
        ),
      ),
    ):SizedBox();
  }
}
