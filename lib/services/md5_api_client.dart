import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart'  as http;
import 'package:marvel_api_app/model/md5_data.dart';

class Md5Client {
  
  Future<Md5> getMd5Data(String publicKey, String privateKey) async {
    var endpoint = Uri.parse("http://localhost:9000/md5?publicKey=$publicKey&privateKey=$privateKey");

    var response = await http.get(endpoint);
    var body = jsonDecode(response.body);

        print(Md5.fromJson(body).md5hash);
        print(Md5.fromJson(body).timeStamp);


    return Md5.fromJson(body);

}
  
}
