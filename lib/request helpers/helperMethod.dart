
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:testers/DataModels/DirectionDetails.dart';
import 'package:testers/DataModels/address.dart';
import 'package:testers/dataprovider/appdata.dart';
import 'package:testers/request%20helpers/request.dart';
import 'package:testers/shared%20widgets/Global%20variable.dart';
import 'package:provider/provider.dart';


class HelperMethods {
  static Future<String> findCoordinateAddress(Position position,
      context) async {
    String placeAddress = '';


    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.mobile &&
        connectivityResult != ConnectivityResult.wifi) {
      return placeAddress;
    }
    String url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position
        .latitude},${position.longitude}&key=$mapkey';

    var response = await RequestHelpers.getRequest(url);
    if (response != 'FAILED') {
      placeAddress = response['results'][0]['formatted_address'];

      Address pickupAddress = new Address();
      pickupAddress.longitude = position.longitude;
      pickupAddress.latitude = position.latitude;
      pickupAddress.placeName = placeAddress;

      Provider.of<Appdata>(context, listen: false).updatePickupAddress(
          pickupAddress);
    }
    return placeAddress;
  }

 static Future<DirectionDetails> getdirectiondetails(LatLng startPosition, LatLng endPosition) async{
    String url = 'https://maps.googleapis.com/maps/api/directions/json?origin=${startPosition.latitude},${startPosition.longitude}&destination=${endPosition.latitude},${endPosition.longitude}&mode=driving&key=$mapkey';
   var response = await RequestHelpers.getRequest(url);
   if(response == 'FAILED'){
     return null;
   }
   DirectionDetails directionDetails = DirectionDetails();
   directionDetails.durationText = response['routes'][0]['legs'][0]['duration']['text'];
   directionDetails.durationValue = response['routes'][0]['legs'][0]['duration']['value'];
   directionDetails.distanceText = response['routes'][0]['legs'][0]['distance']['text'];
   directionDetails.distanceValue = response['routes'][0]['legs'][0]['distance']['value'];
   directionDetails.encodePoints = response['routes'][0]['overview_polyline']['points'];
   return directionDetails;


  }

}
