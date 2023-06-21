import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:marvel_api_app/models/marvelModels/CharacterDataModel.dart';

import '../models/marvelModels/ComicDataModel.dart';
import '../models/marvelModels/CreatorInfoModel.dart';
import '../models/marvelModels/ImageObjectModel.dart';
import '../models/marvelModels/MarvelEvent.dart';

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
      throw Exception('No character found with name: $searchName');
    }
  }

  Future<List<CharacterData>> getCharactersData(String ts, String apiKey, String hash) async {

    var characterEndpoint = Uri.parse("https://gateway.marvel.com/v1/public/characters?ts=$ts&apikey=$apiKey&hash=$hash");
    var response = await http.get(characterEndpoint);

    try {
      Map body = jsonDecode(response.body)['data'];
      Iterable resultItems = body['results'];
      List<CharacterData> parsedCharacters = resultItems.map((characters) => CharacterData.fromJson(characters)).toList();
      parsedCharacters.forEach((element) {print("Parsed Character: ${element.name}");});
      print(parsedCharacters.length);
      return parsedCharacters;
    } catch (e) {
      throw Exception('Unknown exception');
    }
  }

  Future<List<ComicData>> getComicData(String ts, String apiKey, String hash, int characterId) async {
    var comicEndpoint = Uri.parse("https://gateway.marvel.com/v1/public/characters/$characterId/comics?ts=$ts&apikey=$apiKey&hash=$hash");
    var response = await http.get(comicEndpoint);
    try{
      Map myMap = jsonDecode(response.body)['data'];
      Iterable resultItems = myMap['results'];
      List<ComicData> parsedComics = resultItems.map((comicJson) => ComicData.fromJson(comicJson)).toList();
      print(parsedComics.length);
      return parsedComics;
    } catch (e) {
      throw Exception('No comics found with name: $characterId');
    }
  }

  Future<List<ComicData>> getComics(String ts, String apiKey, String hash, {String? orderedBy}) async {
    String extraParam = orderedBy == null? '' : '&orderBy=$orderedBy';
    var comicEndpoint = Uri.parse("https://gateway.marvel.com/v1/public/comics?ts=$ts&apikey=$apiKey&hash=$hash$extraParam&limit=6");
    var response = await http.get(comicEndpoint);
    try{
      Map myMap = jsonDecode(response.body)['data'];
      Iterable resultItems = myMap['results'];
      List<ComicData> parsedComics = resultItems.map((comicJson) => ComicData.fromJson(comicJson)).toList();
      return parsedComics;
    } catch (e) {
      print(e);
      return List.empty();
    }
  }

  Future<List<MarvelEvent>> getEvents(String ts, String apiKey, String hash, {String? orderedBy}) async {
    String extraParam = orderedBy == null? '' : '&orderBy=$orderedBy';
    var comicEndpoint = Uri.parse("https://gateway.marvel.com/v1/public/events?ts=$ts&apikey=$apiKey&hash=$hash$extraParam&limit=4");
    var response = await http.get(comicEndpoint);
    try{
      Map myMap = jsonDecode(response.body)['data'];
      Iterable resultItems = myMap['results'];
      List<MarvelEvent> parsedEvents = resultItems.map((comicJson) => MarvelEvent.fromJson(comicJson)).toList();
      parsedEvents.forEach((element) {print("Parsed Events: ${element.title}");});
      return parsedEvents;
    } catch (e) {
      print(e);
      return List.empty();
    }
  }

  // Refactor later
  // Future<List<MarvelEvent>> getStories(String ts, String apiKey, String hash, {String? orderedBy}) async {
  //   String extraParam = orderedBy == null? '' : '&orderBy=$orderedBy';
  //   var comicEndpoint = Uri.parse("https://gateway.marvel.com/v1/public/stories?ts=$ts&apikey=$apiKey&hash=$hash$extraParam&limit=4");
  //   var response = await http.get(comicEndpoint);
  //   try{
  //     Map myMap = jsonDecode(response.body)['data'];
  //     Iterable resultItems = myMap['results'];
  //     List<MarvelEvent> parsedEvents = resultItems.map((comicJson) => MarvelEvent.fromJson(comicJson)).toList();
  //     parsedEvents.forEach((element) {print("Parsed Events: ${element.title}");});
  //     return parsedEvents;
  //   } catch (e) {
  //     return List.empty();
  //   }
  // }


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
