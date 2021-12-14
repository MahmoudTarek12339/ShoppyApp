import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shoppy/layout/cubit/cubit.dart';
import 'package:shoppy/layout/cubit/states.dart';

class CartScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>ShoppyCubit(),
      child: BlocConsumer<ShoppyCubit,ShoppyStates>(
        listener: (context,state){},
        builder: (context,state){
          return Scaffold(
            appBar: AppBar(
              title: Text('Your Cart'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context,index)=>buildCartItem(context),
                        separatorBuilder: (context,index)=>SizedBox(width: 5.0,),
                        itemCount: 5),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );

  }
  Widget buildCartItem(context)=>Container(
    height: 185,
    width: double.maxFinite,
    child: Card(
      elevation: 3.0,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(width: 5.0,),
              Image(
                image: NetworkImage('https://i.pinimg.com/564x/e8/be/6e/e8be6e703137738190f71be515088fa0.jpg'),
                height: 140,
                width: 100,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Danger tShirt',
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(fontWeight: FontWeight.normal),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                      'size L',
                      style: Theme.of(context).textTheme.caption,
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                      'color red',
                      style: Theme.of(context).textTheme.caption,
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                      'EGP 10.0',
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.orange),
                    ),
                    ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(width: 5.0,),
              FaIcon(FontAwesomeIcons.trash,color: Theme.of(context).iconTheme.color),
              Spacer(),
              FaIcon(FontAwesomeIcons.minusCircle,color: Colors.deepOrangeAccent,),
              SizedBox(width: 5.0),
              Text(
                '1',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              SizedBox(width: 5.0),
              FaIcon(FontAwesomeIcons.plusCircle,color: Colors.deepOrangeAccent,),
              SizedBox(width: 10.0),
            ],
          )
        ],
      ),
    ),
  );
}
