import 'dart:convert';

import 'package:http/http.dart' as http;


class RequestHelpers{

  static Future<dynamic> getRequest(String url) async{
    http.Response response = await http.get(url);

    try {

      if(response.statusCode == 200){
        String data = response.body;
        var decodeData = jsonDecode(data);
        return decodeData;

      }
      else {
        return "FAILED";
      }
    }
    catch(e){
      return "FAILED" ;
    }

  }

}