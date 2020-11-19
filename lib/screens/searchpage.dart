import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testers/DataModels/prediction.dart';
import 'package:testers/dataprovider/appdata.dart';
import 'package:testers/request%20helpers/request.dart';
import 'package:testers/shared%20widgets/Global%20variable.dart';
import 'package:testers/shared%20widgets/PredictionTile.dart';
import 'package:testers/shared%20widgets/divider.dart';

class searchpage extends StatefulWidget {
  @override
  _searchpageState createState() => _searchpageState();
}

class _searchpageState extends State<searchpage> {

  var pickupController = TextEditingController();
  var destinationController = TextEditingController();
  var focusDestination = FocusNode();

  bool focused = false;
  void setFocus(){
    if(!focused){

      FocusScope.of(context).requestFocus(focusDestination);
      focused = true;
    }
  }

  List<Prediction> destinationPredictionList = [];
  void searchPlace(String placeName) async {
    if(placeName.length > 1){

      String url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=$mapkey&sessiontoken=123254251&components=country:fr';
      var response = await RequestHelpers.getRequest(url);
      if (response =='FAILED'){
        return;
      }
      print(response);
      if(response['status'] == 'OK'){
        var predictionsJson = response['predictions'];
        var thisList = (predictionsJson as List).map((e) => Prediction.fromJson(e)).toList();

        setState(() {
          destinationPredictionList = thisList;

        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    setFocus();
    String address =Provider.of<Appdata>(context).pickupAddress.placeName ?? '';
    pickupController.text = address;

    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            height: 210,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 5.0,
                  spreadRadius: 0.5,
                  offset: Offset(
                    0.7,
                    0.7,
                  )
                )
              ]
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 24, top: 48, right: 24, bottom: 20),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 5,),
                  Stack(
                    children: <Widget>[
                      GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.arrow_back),

                      ),
                      Center(
                        child: Text('Set Destinations',
                        style: TextStyle(fontSize: 20,),
                        )
                      )

                    ],
                  ),
                  SizedBox(height: 10,),

                  Expanded(
                    child: Container(
                      child: TextField(
                        controller: pickupController,
                        decoration: InputDecoration(
                          hintText: 'Pickup Location',
                          fillColor: Colors.white,
                          filled: true,
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.only(left: 10, top: 8, bottom: 8)
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: TextField(
                        onChanged: (value){
                          searchPlace(value);
                        },
                        focusNode: focusDestination,
                        controller: destinationController,
                        decoration: InputDecoration(
                            hintText: 'Dropoff Location',
                            fillColor: Colors.white,
                            filled: true,
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.only(left: 10, top: 8, bottom: 8)
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          (destinationPredictionList.length > 0) ?
          ListView.builder(
              itemBuilder: (context, index){
                return PredictionTile(
                  prediction: destinationPredictionList[index],
                );
              },

              itemCount: destinationPredictionList.length,
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
          )
             : Container()

        ],
      ),
    );
  }
}
