import 'dart:async';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoder/geocoder.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:provider/provider.dart';
import 'package:testers/dataprovider/appdata.dart';
import 'package:testers/request%20helpers/helperMethod.dart';
import 'package:testers/screens/searchpage.dart';
import 'package:testers/shared%20widgets/divider.dart';
import 'package:testers/shared%20widgets/styles.dart';
import 'package:testers/request helpers/helperMethod.dart';

class maps extends StatefulWidget {

  static const String id = "maps";

  @override
  _mapsState createState() => _mapsState();
}

class _mapsState extends State<maps> {

  GlobalKey<ScaffoldState> scaffoldkey = new GlobalKey<ScaffoldState>();

  double searchSheetHeight = (Platform.isIOS) ? 270 : 240;

  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController mapController;
  double mapBottomPadding = 0;

  List<LatLng> polylineCoordinates = [];
  Set<Polyline> _polylines = {};

  var geoLocator = Geolocator();
  Position currentPosition;

  void setupPositionLocator() async {
    Position position = await geoLocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPosition = position;
    LatLng pos = LatLng(position.latitude, position.longitude);
    CameraPosition cp = new CameraPosition(target: pos, zoom: 14);
    mapController.animateCamera(CameraUpdate.newCameraPosition(cp));

    String address = await HelperMethods.findCoordinateAddress(
        position, context);
    print(address);
  }

  static final CameraPosition _position = CameraPosition(
    target: LatLng(37.42796, -122.08574),
    zoom: 14.7,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      key: scaffoldkey,
      drawer: Container(
        width: 250,
        color: Colors.white,
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.all(0),
            children: <Widget>[
              Container(
                height: 160,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                      color: Colors.white
                  ),
                  child: Row(
                      children: <Widget>[
                        SizedBox(width: 15.0,),
                        Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('Aditya', style: TextStyle(fontSize: 20),),
                              SizedBox(height: 3.0,),
                              Text('View Profile'),
                            ]
                        )

                      ]
                  ),
                ),
              ),
              divider(),
              SizedBox(height: 10.0,),
              ListTile(
                leading: Icon(OMIcons.cardGiftcard),
                title: Text('Rides', style: kDrawerItemStyle,),

              ),
              ListTile(
                leading: Icon(OMIcons.creditCard),
                title: Text('Payment', style: kDrawerItemStyle,),

              ),
              ListTile(
                leading: Icon(OMIcons.history),
                title: Text('Ride History', style: kDrawerItemStyle,),

              ),
              ListTile(
                leading: Icon(OMIcons.contactSupport),
                title: Text('Help', style: kDrawerItemStyle,),

              ),
              ListTile(
                leading: Icon(OMIcons.info),
                title: Text('About Us', style: kDrawerItemStyle,),

              )

            ],
          ),
        ),
      ),

      body: Stack(
        children: <Widget>[
          GoogleMap(
            padding: EdgeInsets.only(bottom: mapBottomPadding),
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            initialCameraPosition: _position,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            polylines: _polylines,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              mapController = controller;

              setState(() {
                mapBottomPadding = (Platform.isAndroid) ? 240 : 270;
              });
              setupPositionLocator();
            },
          ),

          Positioned(
            top: 44,
            left: 20,
            child: GestureDetector(
              onTap: () {
                scaffoldkey.currentState.openDrawer();
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10.0,
                          spreadRadius: 1.0,
                          offset: Offset(
                            0.7,
                            0.7,
                          )
                      )

                    ]
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 20,
                  child: Icon(Icons.menu, color: Colors.black45,),
                ),
              ),
            ),
          ),

          Positioned( // searchbar
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: searchSheetHeight,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black54,
                          blurRadius: 15.0,
                          spreadRadius: 0.5,
                          offset: Offset(
                            0.7,
                            0.7,
                          )
                      )
                    ]
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 10,),

                      Text('Where would you like to go ?',
                        style: TextStyle(fontSize: 18),),
                      SizedBox(height: 7,),
                      GestureDetector(
                        onTap: () async {
                          var response = await Navigator.push(
                              context, MaterialPageRoute(
                              builder: (context) => searchpage()
                          ));
                          if (response == 'getDirection') {
                            await getDirection();
                          }
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black54,
                                      blurRadius: 5.0,
                                      spreadRadius: 0.5,
                                      offset: Offset(
                                        0.7,
                                        0.7,
                                      )
                                  )
                                ]
                            ),
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.search, color: Colors.blue),
                                SizedBox(width: 10,),
                                Text('Search destination'),
                              ],
                            )
                        ),
                      ),
                      SizedBox(height: 12,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(OMIcons.home, color: Colors.black45),
                          SizedBox(width: 9.0,),
                          Column(
                            children: <Widget>[
                              Text('Add Home'),
                              SizedBox(height: 3.0,),
                              Text('Add your Home Address',
                                style: TextStyle(
                                    fontSize: 11, color: Colors.black38),),
                            ],
                          )
                        ],
                      ), // add home

                      SizedBox(height: 5,),
                      Divider(),
                      SizedBox(height: 7,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Icon(OMIcons.work, color: Colors.black45),
                          SizedBox(width: 7.0,),
                          Column(
                            children: <Widget>[
                              Text("Add Work",),
                              SizedBox(height: 3.0,),
                              Text('Add your Work Address',
                                style: TextStyle(
                                    fontSize: 11, color: Colors.black38),),
                            ],
                          )
                        ],
                      ) // add work


                    ],
                  ),
                ),

              )
          ) // searchbar
        ],
      ),

    );
  }


  Future<void> getDirection() async {
    var pickup = Provider
        .of<Appdata>(context, listen: false)
        .pickupAddress;
    var destination = Provider
        .of<Appdata>(context, listen: false)
        .destinationAddress;

    var pickLatLng = LatLng(pickup.latitude, pickup.longitude);
    var destinationLatLng = LatLng(destination.latitude, destination.longitude);


    var thisDetails = await HelperMethods.getdirectiondetails(
        pickLatLng, destinationLatLng);
    Navigator.pop(context);
    print(thisDetails.encodePoints);

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> results = polylinePoints.decodePolyline(thisDetails.encodePoints);
    polylineCoordinates.clear();
    if(results.isNotEmpty){
      results.forEach((PointLatLng points) {
        polylineCoordinates.add(LatLng(points.latitude, points.longitude));
      });
    }
    _polylines.clear();
    setState(() {
      Polyline polyline = Polyline(
        polylineId: PolylineId('polyid'),
        color: Colors.lightBlueAccent,
        points: polylineCoordinates,
        jointType: JointType.round,
        width: 4,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );
      _polylines.add(polyline);
    });

  }

}
