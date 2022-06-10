import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart'  as http;
import 'package:marvel_api_app/model/md5_data.dart';
import 'package:marvel_api_app/model/marvel_data.dart';
import 'package:marvel_api_app/services/marvel_api_client.dart';

class Md5Client {
  
  Future<String> getMd5Data(String publicKey, String privateKey) async {
    var endpoint = Uri.parse("http://localhost:9000/md5?publicKey=$publicKey&privateKey=$privateKey");
    MarvelApiClient marvelClient = MarvelApiClient();
    String characterName = "";
    var response = await http.get(endpoint);
    print(response.statusCode);
    if(response.statusCode == 200){
      var body = jsonDecode(response.body);
      Md5 md5Data = Md5.fromJson(body);
      print(md5Data.md5hash);
      characterName = await marvelClient.getMarvelData(md5Data.timeStamp!, publicKey, md5Data.md5hash!);
    }
    print("The character name is " + characterName);
    return characterName;

}
  
}
