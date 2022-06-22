import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:marvel_api_app/model/md5_data.dart';
import 'package:marvel_api_app/model/marvel_data.dart';
import 'package:marvel_api_app/services/marvel_api_client.dart';

class Md5Client {

  Future<Md5> getMd5Data(
      String publicKey, String privateKey) async {
    const String baseUrl = "http://localhost:9000";

    var md5ServiceEndpoint = Uri.parse(
        "$baseUrl/md5?publicKey=$publicKey&privateKey=$privateKey");
    var response = await http.get(md5ServiceEndpoint);
    Md5 model = Md5("", "");

    print("[Md5Client][getMd5Data] - Got status: ${response.statusCode}");
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      model = Md5.fromJson(body);
    }

    return model;
  }
}
