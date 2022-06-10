import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart'  as http;
import 'package:marvel_api_app/model/marvel_data.dart';
import 'package:marvel_api_app/model/md5_data.dart';

class MarvelApiClient {

  Future<String> getMarvelData(String ts, String apiKey, String hash) async {
    var endpoint = Uri.parse("http://gateway.marvel.com/v1/public/characters?name=Absorbing%20Man&ts=$ts&apikey=$apiKey&hash=$hash");

    var response = await http.get(endpoint);
    var body = jsonDecode(response.body)['data'];
    print(body['results'][0]['name']);

    return body['results'][0]['name'];

  }

}