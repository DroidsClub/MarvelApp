import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:marvel_api_app/models/md5Model.dart';

class Md5Client {

  Future<Md5> getMd5Data(String publicKey, String privateKey) async {
    const String baseUrl = "http://localhost:9000";
    var md5ServiceEndpoint = Uri.parse("$baseUrl/md5?publicKey=$publicKey&privateKey=$privateKey");
    var response = await http.get(md5ServiceEndpoint);
    Md5 model = Md5("", "");

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      model = Md5.fromJson(body);
    }

    return model;
  }
}
