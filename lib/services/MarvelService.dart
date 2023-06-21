

import 'package:marvel_api_app/screens/UserProfile.dart';
import 'package:marvel_api_app/models/marvelModels/CharacterDataModel.dart';
import 'package:marvel_api_app/connectors/marvel_api_client.dart';
import 'package:marvel_api_app/connectors/md5_api_client.dart';
import 'package:marvel_api_app/models/marvelModels/ComicDataModel.dart';
import 'package:marvel_api_app/models/md5Model.dart';


typedef void MyCallback(String character);
class MarvelService  {

  Md5Client md5Client = Md5Client();
  MarvelApiClient marvelClient = MarvelApiClient();

  Future<CharacterData> _retrieveCharacter(String character) async {
    Md5 hashResponse = await md5Client.getMd5Data(publicKey, privateKey);

    print(
        "[HomePage][_retrieveCharacter] - Printing getMd5Data result with hash: ${hashResponse.md5hash} and timestamp ${hashResponse.timeStamp}");
    return await marvelClient.getMarvelData(hashResponse.timeStamp!, publicKey, hashResponse.md5hash!, character);
  }

  Future<List<ComicData>> _retrieveComic(int characterId) async {
    Md5 hashResponse = await md5Client.getMd5Data(publicKey, privateKey);
    print(
        "[HomePage][_retrieveComic] - Printing getMd5Data result with hash: ${hashResponse.md5hash} and timestamp ${hashResponse.timeStamp}");
    return await marvelClient.getComicData(
        hashResponse.timeStamp!, publicKey, hashResponse.md5hash!, characterId);
  }

}