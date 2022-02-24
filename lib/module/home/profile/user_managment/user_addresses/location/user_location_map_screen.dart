import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shoppy/module/home/profile/user_managment/user_addresses/location/user_location_screen.dart';
import 'package:shoppy/shared/components/components.dart';
import 'package:shoppy/shared/network/remote/location_service.dart';

class UserLocationMapScreen extends StatefulWidget {
  final bool isCart;

  UserLocationMapScreen({
    required this.isCart
  });

  @override
  State<UserLocationMapScreen> createState() => MapSampleState();
}

class MapSampleState extends State<UserLocationMapScreen> {
  Completer<GoogleMapController> _controller = Completer();

  var marker =HashSet<Marker>();
  final TextEditingController searchController=TextEditingController();

  Position? currentPosition;
  LatLng? selectedLocation;

  @override
  void initState(){
    super.initState();

    setCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Location Selection'),
        centerTitle: true,
        backgroundColor: Theme.of(context).focusColor,),
      body: currentPosition==null?
          Center(child:CircularProgressIndicator())
          :Stack(
        alignment: Alignment.bottomCenter,
        children: [
          GoogleMap(
            mapType: MapType.normal,
            zoomControlsEnabled: false,
            markers: marker,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            initialCameraPosition: CameraPosition(
              target: LatLng(currentPosition!.latitude,currentPosition!.longitude),
              zoom: 16,
            ),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              setState(() {
                marker.add(Marker(
                    markerId: MarkerId('1'),
                    position: LatLng(currentPosition!.latitude,currentPosition!.longitude),
                  )
                );
              });
            },
            onCameraMove: (position){
              setState(() {
                selectedLocation=position.target;
                marker.clear();
                marker.add(Marker(
                  markerId: MarkerId('1'),
                  position: position.target,
                ));
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 15),
            child: SizedBox(
              height: 60,
              child: ElevatedButton(
                onPressed: ()async{
                  Placemark place=await getPosition(userLocation: selectedLocation,);

                  navigateTo(context, UserLocationScreen(
                    userPlace: place,
                    currentPosition: selectedLocation!,
                    isCart: widget.isCart,
                  ));
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
                      'Select',
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
    );
  }

  setCurrentLocation()async{
    bool permission=await checkPermission();
    if(permission){
      currentPosition = await LocationService().getCurrentLocation();
      setState(() {
        selectedLocation =
            LatLng(currentPosition!.latitude, currentPosition!.longitude);
      });
    }
    else{
      Navigator.pop(context);
    }
  }

  Future<bool> checkPermission()async{
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return serviceEnabled;
  }


  Future<Placemark> getPosition({
  required userLocation,
})async{
    List<Placemark> placeMarks = await placemarkFromCoordinates(userLocation.latitude,userLocation.longitude);
    Placemark place=placeMarks[0];
    return place;
  }

}