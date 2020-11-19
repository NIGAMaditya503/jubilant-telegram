import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testers/DataModels/address.dart';
import 'package:testers/DataModels/prediction.dart';
import 'package:testers/dataprovider/appdata.dart';
import 'package:testers/request%20helpers/request.dart';
import 'package:testers/shared%20widgets/Global%20variable.dart';

class PredictionTile extends StatelessWidget {
 final Prediction prediction;
 PredictionTile({this.prediction});

 void getPlaceDetails(String placeID, context) async{

   String url = 'https://maps.googleapis.com/maps/api/place/details/json?placeid=$placeID&key=$mapkey';
   var response = await RequestHelpers.getRequest(url);
   if (response == 'FAILED'){
     return;
   }
   if(response['status'] == 'OK'){
     Address thisPlace = Address();
     thisPlace.placeName = response['result']['name'];
     thisPlace.placeId = placeID;
     thisPlace.latitude = response['result']['geometry']['location']['lat'];
     thisPlace.longitude = response['result']['geometry']['location']['lng'];

     Provider.of<Appdata>(context, listen: false).updateDestinationAddress(thisPlace);
     print(thisPlace.placeName);

     Navigator.pop(context, 'getDirection');
   }
 }

 @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: (){
        getPlaceDetails(prediction.placeId, context);

      },
      padding: EdgeInsets.all(0),
      child: Container(
        child: Row(
          children: <Widget>[
            Icon(Icons.location_on_rounded),
            SizedBox(width: 12,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(prediction.mainText, style: TextStyle(fontSize: 15),),
                SizedBox(height: 2,),
                Text(prediction.secondaryText, style: TextStyle(fontSize: 8, color: Colors.black26),),
              ],
            )

          ],
        ),
      ),
    );
  }
}
