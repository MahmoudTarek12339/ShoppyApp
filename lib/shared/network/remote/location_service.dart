import 'package:geolocator/geolocator.dart';

class LocationService{
  final String key='AIzaSyCckw1YddwlShgmupIQYriq49_o24nD8Xk';

  Future<Position> getCurrentLocation()async{
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high
    );
  }

}