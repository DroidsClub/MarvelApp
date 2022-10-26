import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:marvel_api_app/models/marvelModels/CharacterDataModel.dart';

import '../models/marvelModels/ComicDataModel.dart';
import '../models/marvelModels/CreatorInfoModel.dart';
import '../models/marvelModels/ImageObjectModel.dart';

class MarvelApiClient {
  Future<CharacterData> getMarvelData(String ts, String apiKey, String hash, String searchName) async {

    var characterEndpoint = Uri.parse("https://gateway.marvel.com/v1/public/characters?name=$searchName&ts=$ts&apikey=$apiKey&hash=$hash");
    var response = await http.get(characterEndpoint);

    try {
      var body = jsonDecode(response.body)['data'];
      String path = body['results'][0]['thumbnail']['path'];
      String extension = body['results'][0]['thumbnail']['extension'];
      String characterPhoto = Uri.parse("$path.$extension").toString();
      String characterName = body['results'][0]['name'];
      int characterId = body['results'][0]['id'];
      return CharacterData(characterId, characterName, characterPhoto);
    } catch (e) {
      return CharacterData(null, "Unknown character: $searchName", null);
    }
  }

  Future<List<ComicData>> getComicData(String ts, String apiKey, String hash, int characterId) async {
    var comicEndpoint = Uri.parse("https://gateway.marvel.com/v1/public/characters/$characterId/comics?ts=$ts&apikey=$apiKey&hash=$hash");
    var response = await http.get(comicEndpoint);
    try{
      Map myMap = jsonDecode(response.body)['data'];
      Iterable resultItems = myMap['results'];
      List<ComicData> parsedComics = resultItems.map((comicJson) => ComicData.fromJson(comicJson)).toList();
      return parsedComics;
    } catch (e) {
      return List.empty();
    }
  }

  Future<CreatorInfo> getCreatorInfo(String ts, String apiKey, String hash, String searchUrl) async {
    var endpoint = Uri.parse("$searchUrl?ts=$ts&apikey=$apiKey&hash=$hash");
    var response =  await http.get(endpoint);

    try{
      var creatorJson = jsonDecode(response.body)['data']['results'][0];
      var parsedModel = CreatorInfo.fromJson(creatorJson);
      return parsedModel;
    }catch (e){
      return CreatorInfo("Dr.Fail", ImageObject(null, null));
    }
  }

}
