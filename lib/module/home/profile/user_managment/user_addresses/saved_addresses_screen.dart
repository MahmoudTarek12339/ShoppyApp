import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoppy/layout/cubit/cubit.dart';
import 'package:shoppy/layout/cubit/states.dart';
import 'package:shoppy/model/address_model.dart';
import 'package:shoppy/shared/components/components.dart';

import 'location/user_location_map_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SavedAddressesScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShoppyCubit,ShoppyStates>(
      listener: ((context, state) {
        if(state is ShoppyRemoveFromAddressesSuccessState){
          defaultSnackBar(
            context: context,
            color: Colors.green,
            title: '${AppLocalizations.of(context)!.addressRemovedSuccessfully}',
          );
        }
        else if(state is ShoppyRemoveFromAddressesErrorState){
          defaultSnackBar(
            context: context,
            color: Colors.red,
            title: state.error,
          );
          print(state.error);
        }
      }),
      builder: (context,state){
        var cubit=ShoppyCubit.get(context);
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            title: Text('Saved Addresses'),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Theme.of(context).focusColor,
            actions: [
              IconButton(
                onPressed: ()async{
                  bool connected=await cubit.checkInternetConnection();
                  if(connected){
                    navigateTo(
                        context,
                        UserLocationMapScreen(
                          isCart: false,
                        ));
                  }
                },
                icon: Icon(Icons.add),
              )
            ],
          ),
          body:cubit.userAddresses.isEmpty?
              emptyAddresses(context: context)
              :ListView.separated(
            itemBuilder: (context, index) => addressCard(
              context: context,
              addressModel: cubit.userAddresses[index],
              cubit: cubit
            ),
            separatorBuilder:(context, index) =>Divider(height: 3,color: Colors.grey,),
            itemCount: cubit.userAddresses.length
          ),
        );
      },
    );
  }
  Widget addressCard({
    required context,
    required AddressModel addressModel,
    required cubit,
  })=>Padding(
    padding: const EdgeInsets.all(10.0),
    child: Stack(
      alignment: Alignment.topRight,
      children: [
        Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                addressModel.cityName,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                '${addressModel.streetName}, ${addressModel.buildingNumber}, ${addressModel.floorNumber}, ${addressModel.apartmentNumber}',
                style: Theme.of(context).textTheme.headline1,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                'Mobile: '+addressModel.phoneNumber,
                style: Theme.of(context).textTheme.headline1,
              ),
            ],
          ),
        ),
        IconButton(
          padding: EdgeInsets.only(bottom: 25,left: 15),
          onPressed: (){
            cubit.removeAddress(addressModel.uId);
          },
          icon: Icon(Icons.close,size: 14,),
        )
      ],
    ),
  );

  Widget emptyAddresses({required context})=>Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.location_on,
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
                  text: '${AppLocalizations.of(context)!.no}',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyText1!.color,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: '${AppLocalizations.of(context)!.addresses}',
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
          '${AppLocalizations.of(context)!.addOneNow}',
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyText1!.color,
            fontSize: 14,
          ),

        ),
        SizedBox(
          height: 30,
        ),
        SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed: ()async{
              bool connected=await ShoppyCubit.get(context).checkInternetConnection();
              if(connected){
                navigateTo(
                    context,
                    UserLocationMapScreen(
                      isCart: false,
                    ));
              }
            },
            child: Text(
              '${AppLocalizations.of(context)!.addAddress}',
              style: TextStyle(
                fontSize: 24,
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
}
