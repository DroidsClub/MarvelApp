import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:marvel_api_app/model/marvel_data.dart';
import 'package:marvel_api_app/model/md5_data.dart';

class MarvelApiClient {
  Future<CharacterData> getMarvelData(
      String ts, String apiKey, String hash, String searchName) async {
    var characterEndpoint = Uri.parse(
        "https://gateway.marvel.com/v1/public/characters?name=$searchName&ts=$ts&apikey=$apiKey&hash=$hash");

    var response = await http.get(characterEndpoint);
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
      int characterId = body['results'][0]['id'];
      return CharacterData(characterId, characterName, characterPhoto);
    } catch (e) {
      print(
          "[MarvelApiClient][getMarvelData] - Exception thrown with error $e");
      return CharacterData(null, "Unknown character: $searchName", null);
    }
  }

  Future<ComicData> getComicData(
      String ts, String apiKey, String hash, int characterId) async{
    var comicEndpoint = Uri.parse(
        "https://gateway.marvel.com/v1/public/characters/$characterId/comics?ts=$ts&apikey=$apiKey&hash=$hash");

    var response = await http.get(comicEndpoint);

    try{
      var body = jsonDecode(response.body)['data'];
      String path = body['results'][12]['images'][0]['path'];
      String extension = body['results'][12]['images'][0]['extension'];
      String comicPhoto = Uri.parse("$path.$extension").toString();

      print(
          "[MarvelApiClient][getMarvelData] - Comic title: ${body['results'][0]['title']}");
      print(
          "[MarvelApiClient][getMarvelData] - Comic photo: $path.$extension");

      String comicTitle = body['results'][2]['title'];
      int comicId = body['results'][2]['id'];
      return ComicData(comicId, comicTitle, comicPhoto);
    } catch (e) {
      print(
          "[MarvelApiClient][getComicData] - Exception thrown with error $e");
      return ComicData(null, "Unknown characterId: $characterId", null);
    }
  }

}
