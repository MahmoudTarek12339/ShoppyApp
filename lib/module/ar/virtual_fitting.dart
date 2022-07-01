import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoppy/layout/cubit/cubit.dart';
import 'package:shoppy/layout/cubit/states.dart';

class VirtualFittingScreen extends StatelessWidget {
  final int index;

  const VirtualFittingScreen({required this.index});

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
                      fit: BoxFit.cover,
                    ),
                  ),
                  if (ShoppyCubit.get(context).vis)
                    Positioned(
                      bottom: 50,
                      right: 0,
                      left: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Container(
                                      width: 100,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Theme.of(context).focusColor,
                                      ),
                                      child: Center(
                                          child: Text(
                                        'Your Cart',
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption!
                                            .copyWith(color: Colors.white),
                                      ))
                                  ),
                                  SizedBox(height: 10,),
                                  SizedBox(
                                    height: 275,
                                    width: 110,
                                    child: ListView.separated(
                                        itemBuilder: (context, index) =>
                                            productItem(),
                                        separatorBuilder: (context, index) =>
                                            SizedBox(
                                              height: 5,
                                            ),
                                        itemCount: 10),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Container(
                                      width: 100,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Theme.of(context).focusColor,
                                      ),
                                      child: Center(
                                          child: Text(
                                        'For You',
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption!
                                            .copyWith(color: Colors.white),
                                      ))),
                                  SizedBox(height: 10,),
                                  SizedBox(
                                    height: 275,
                                    width: 110,
                                    child: ListView.separated(
                                        itemBuilder: (context, index) =>
                                            productItem(),
                                        separatorBuilder: (context, index) =>
                                            SizedBox(
                                              height: 5,
                                            ),
                                        itemCount: 10),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                ],
              ),
            ),
          );
        }),
        listener: (context, state) {});
  }

  Widget productItem() => InkWell(
        onTap: () {},
        child: Container(
          height: 75.0,
          width: 75.0,
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
              'https://m.media-amazon.com/images/I/61gqx7hslmL._UX569_.jpg',
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
      );
}
