import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoppy/layout/cubit/cubit.dart';
import 'package:shoppy/layout/cubit/states.dart';

class OrdersScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context)=>ShoppyCubit(),
      child: BlocConsumer<ShoppyCubit,ShoppyStates>(
        listener: (context,state){},
        builder: (context,state){
          return DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: AppBar(
                title: Text("Orders"),
                bottom: TabBar(
                    physics: BouncingScrollPhysics(),
                    isScrollable: true,
                    labelColor: Colors.deepOrangeAccent,
                    unselectedLabelColor: Colors.grey,
                    tabs: [
                      Tab(text: 'Open orders'),
                      Tab(text: 'Recent orders',),
                      Tab(text: 'Cancelled orders',),
                    ]
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(5.0),
                child: TabBarView(
                    physics: BouncingScrollPhysics(),
                    children: [
                      Container(
                        child: ListView.separated(
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context,index)=>buildOrderItem(context),
                            separatorBuilder: (context,index)=>SizedBox(width: 5.0,),
                            itemCount: 5),
                      ),
                      Container(
                        child: ListView.separated(
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context,index)=>buildOrderItem(context),
                            separatorBuilder: (context,index)=>SizedBox(width: 5.0,),
                            itemCount: 5),
                      ),
                      Container(
                        child: ListView.separated(
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context,index)=>buildOrderItem(context),
                            separatorBuilder: (context,index)=>SizedBox(width: 5.0,),
                            itemCount: 5),
                      ),
                    ]
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  Widget buildOrderItem(context)=>Container(
    height: 150,
    width: double.infinity,
    child: Card(
      elevation: 3.0,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 10.0,),
          Image(
            image: NetworkImage('https://i.pinimg.com/564x/e8/be/6e/e8be6e703137738190f71be515088fa0.jpg'),
            height: 140,
            width: 100,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
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
    ),
  );
}
