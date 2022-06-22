import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:marvel_api_app/model/marvel_data.dart';
import 'package:marvel_api_app/model/md5_data.dart';

class MarvelApiClient {
  Future<CharacterData> getMarvelData(
      String ts, String apiKey, String hash, String searchName) async {
    var endpoint = Uri.parse(
        "https://gateway.marvel.com/v1/public/characters?name=$searchName&ts=$ts&apikey=$apiKey&hash=$hash");

    var response = await http.get(endpoint);
    print(
        "[MarvelApiClient][getMarvelData] - Got status code: ${response.statusCode}");
    try {
      var body = jsonDecode(response.body)['data'];
      String path = body['results'][0]['thumbnail']['path'];
      String extension = body['results'][0]['thumbnail']['extension'];
      String characterPhoto = Uri.parse("$path.$extension").toString();

      print(
          "[MarvelApiClient][getMarvelData] - Character name: ${body['results'][0]['name']}");
      print(
          "[MarvelApiClient][getMarvelData] - Character photo: $path.$extension");

      String characterName = body['results'][0]['name'];
      return CharacterData(characterName, characterPhoto);
    } catch (e) {
      print(
          "[MarvelApiClient][getMarvelData] - Exception thrown with error $e");
      return CharacterData("Unknown character: $searchName", null);
    }
  }
}
