import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart'  as http;
import 'package:marvel_api_app/model/marvel_data.dart';
import 'package:marvel_api_app/model/md5_data.dart';

class MarvelApiClient {

  Future<MarvelData> getMarvelData(String ts, String apiKey, String hash) async {
    var endpoint = Uri.parse("http://gateway.marvel.com/v1/public/characters?name=Hulk&ts=$ts&apikey=$apiKey&hash=$hash");

    var response = await http.get(endpoint);
    var body = jsonDecode(response.body);
    print(body);

    return MarvelData.fromJson(body);

  }

}