import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shoppy/layout/cubit/cubit.dart';
import 'package:shoppy/layout/cubit/states.dart';

class WishListScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShoppyCubit,ShoppyStates>(
      listener: (context,state){},
      builder: (context,state){
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView.separated(
              physics: BouncingScrollPhysics(),
              itemBuilder: (context,index)=>buildWishListItem(context),
              separatorBuilder: (context,index)=>SizedBox(width: 10.0,),
              itemCount: 5),
        );
      },
    );
  }
  Widget buildWishListItem(context)=>Container(
    height: 150,
    width: double.infinity,
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
              image: NetworkImage('https://i.pinimg.com/564x/e8/be/6e/e8be6e703137738190f71be515088fa0.jpg'),
              height: 100,
              width: 100,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Danger tShirt',
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.black,fontWeight: FontWeight.normal),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '10\$',
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.black),
                  ),
                  Spacer(),
                  MaterialButton(
                    onPressed: (){},
                    child: Text('Add to cart'),
                    textColor: Colors.black,
                    color: Colors.white,
                  )
                ],
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: FaIcon(FontAwesomeIcons.solidHeart,color: Colors.red,)
              ),
            )
          ],
        ),
      ),
    ),
  );
}
