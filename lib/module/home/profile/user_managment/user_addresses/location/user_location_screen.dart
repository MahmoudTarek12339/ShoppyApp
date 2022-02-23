import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shoppy/layout/cubit/cubit.dart';
import 'package:shoppy/layout/cubit/states.dart';
import 'package:shoppy/model/address_model.dart';
import 'package:shoppy/module/home/bottom_nav/home/cart/cart_screen.dart';
import 'package:shoppy/module/home/profile/user_managment/user_addresses/saved_addresses_screen.dart';
import 'package:shoppy/shared/components/components.dart';

class UserLocationScreen extends StatefulWidget {
  final Placemark userPlace;
  final LatLng currentPosition;
  final bool isCart;
  UserLocationScreen({
    required this.userPlace,
    required this.currentPosition,
    required this.isCart,
  });
  @override
  State<UserLocationScreen> createState() => _UserLocationScreenState();
}

class _UserLocationScreenState extends State<UserLocationScreen> {

  final TextEditingController areaController=TextEditingController();
  final TextEditingController streetController=TextEditingController();
  final TextEditingController buildNumberController=TextEditingController();
  final TextEditingController floorNumberController=TextEditingController();
  final TextEditingController apartmentNumberController=TextEditingController();
  final TextEditingController mobileController=TextEditingController();

  final GlobalKey<FormState> formKey=GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final List<String> details=widget.userPlace.street.toString().split(' ');
    details.removeAt(0);
    final String userStreet=details.join(' ').toString();

    return BlocConsumer<ShoppyCubit,ShoppyStates>(
      listener: (context, state) {
        if(state is ShoppyAddToAddressesSuccessState){
          defaultSnackBar(
            context: context,
            color: Colors.green,
            title: 'address Added Successfully',
          );
          widget.isCart?
            navigateTo(context,CartScreen())
            :navigateTo(context,SavedAddressesScreen());
        }
        else if(state is ShoppyAddToAddressesErrorState){
          defaultSnackBar(
            context: context,
            color: Colors.red,
            title: state.error,
          );
          print(state.error);
        }
      },

      builder: (context,state){
        areaController.text=widget.userPlace.subAdministrativeArea.toString();
        streetController.text=userStreet;
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Add Address',
            ),
            centerTitle: true,
            backgroundColor: Theme.of(context).focusColor,
          ),
          body: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 175,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 5,right:5,bottom:15),
                            height: 160,
                            width: double.infinity,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: GoogleMap(
                              mapType: MapType.normal,
                              zoomControlsEnabled: false,
                              scrollGesturesEnabled: false,
                              initialCameraPosition: CameraPosition(
                                target: LatLng(widget.currentPosition.latitude,widget.currentPosition.longitude),
                                zoom: 16,
                              ),
                            ),
                          ),
                          Container(
                            height: 40,
                            child: ElevatedButton(
                              onPressed: (){
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(color: Theme.of(context).focusColor,width: 2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 0,
                                primary: Colors.white,
                              ),
                              child: Text(
                                'Refine Location',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).focusColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextFormField(
                      controller: areaController,
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 18,),
                      decoration: InputDecoration(
                        enabledBorder:UnderlineInputBorder(
                          borderSide: BorderSide(color:Colors.grey),
                        ),
                        focusedBorder:UnderlineInputBorder(
                          borderSide: BorderSide(color: Theme.of(context).textTheme.bodyText1!.color??Colors.white),
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        labelText: 'Area',
                        labelStyle: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.grey),
                      ),
                      validator: (value){
                        if(value!.isEmpty){
                          return 'This field is Required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      controller: streetController,
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 18,),
                      decoration: InputDecoration(
                        enabledBorder:UnderlineInputBorder(
                          borderSide: BorderSide(color:Colors.grey),
                        ),
                        focusedBorder:UnderlineInputBorder(
                          borderSide: BorderSide(color: Theme.of(context).textTheme.bodyText1!.color??Colors.white),
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        labelText: 'Street Name',
                        labelStyle: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.grey),
                      ),
                      validator: (value){
                        if(value!.isEmpty){
                          return 'This field is Required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      controller: buildNumberController,
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 18,),
                      decoration: InputDecoration(
                        enabledBorder:UnderlineInputBorder(
                          borderSide: BorderSide(color:Colors.grey),
                        ),
                        focusedBorder:UnderlineInputBorder(
                          borderSide: BorderSide(color: Theme.of(context).textTheme.bodyText1!.color??Colors.white),
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        labelText: 'Building name/number',
                        labelStyle: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.grey),
                      ),
                      validator: (value){
                        if(value!.isEmpty){
                          return 'This field is Required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      controller: floorNumberController,
                      keyboardType: TextInputType.number,
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 18,),
                      decoration: InputDecoration(
                        enabledBorder:UnderlineInputBorder(
                          borderSide: BorderSide(color:Colors.grey),
                        ),
                        focusedBorder:UnderlineInputBorder(
                          borderSide: BorderSide(color: Theme.of(context).textTheme.bodyText1!.color??Colors.white),
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        labelText: 'Floor number',
                        labelStyle: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.grey),
                      ),
                      validator: (value){
                        if(value!.isEmpty){
                          return 'This field is Required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      controller: apartmentNumberController,
                      keyboardType: TextInputType.number,
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 18,),
                      decoration: InputDecoration(
                        enabledBorder:UnderlineInputBorder(
                          borderSide: BorderSide(color:Colors.grey),
                        ),
                        focusedBorder:UnderlineInputBorder(
                          borderSide: BorderSide(color: Theme.of(context).textTheme.bodyText1!.color??Colors.white),
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        labelText: 'Apartment number',
                        labelStyle: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.grey),
                      ),
                      validator: (value){
                        if(value!.isEmpty){
                          return 'This field is Required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      controller: mobileController,
                      keyboardType: TextInputType.phone,
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 18,),
                      decoration: InputDecoration(
                        enabledBorder:UnderlineInputBorder(
                          borderSide: BorderSide(color:Colors.grey),
                        ),
                        focusedBorder:UnderlineInputBorder(
                          borderSide: BorderSide(color: Theme.of(context).textTheme.bodyText1!.color??Colors.white),
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        labelText: 'Mobile number',
                        labelStyle: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.grey),
                        prefixText: '+20 ',
                        prefixStyle: Theme.of(context).textTheme.subtitle1,
                      ),
                      validator: (value){
                        if(value!.isEmpty){
                          return 'This field is Required';
                        }
                        else if(value.length!=11){
                          return 'Invalid phone Number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 15),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 60,
                            child: ElevatedButton(
                              onPressed: (){
                                if(formKey.currentState!.validate()){
                                  ShoppyCubit.get(context).addAddress(AddressModel(
                                    streetName: streetController.text,
                                    cityName: areaController.text,
                                    buildingNumber: buildNumberController.text,
                                    floorNumber: floorNumberController.text,
                                    apartmentNumber: apartmentNumberController.text,
                                    phoneNumber: mobileController.text,
                                    userAddressLat: widget.currentPosition.latitude,
                                    userAddressLng: widget.currentPosition.longitude,
                                  ));
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                elevation: 5.0,
                                primary: Theme.of(context).focusColor,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Save Address',
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
                          if(state is ShoppyAddToAddressesLoadingState)
                            LinearProgressIndicator(),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },

    );
  }
}

