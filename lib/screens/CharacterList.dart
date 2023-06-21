import 'package:flutter/material.dart';
import 'package:marvel_api_app/helpers/CharactersGridHelper.dart';
import 'package:marvel_api_app/models/marvelModels/CharacterDataModel.dart';

import '../helpers/CustomAppBar.dart';
import '../helpers/CustomBottomNavigationBar.dart';
import '../helpers/ComicGridHelper.dart';
import '../models/marvelModels/ComicDataModel.dart';
import '../models/md5Model.dart';
import '../connectors/marvel_api_client.dart';
import '../connectors/md5_api_client.dart';

String publicKey = "df460e7b04d986419acf029680a28d60";
String privateKey = "ebbc27080f123549ff61d4eb5101bad61f4bac26";

class CharactersList extends StatefulWidget {
  const CharactersList({Key? key}) : super(key: key);

  @override
  _CharactersListState createState() => _CharactersListState();
}

class _CharactersListState extends State<CharactersList> {
  Md5Client md5Client = Md5Client();
  MarvelApiClient marvelClient = MarvelApiClient();

  List<CharacterData> characters = List.empty();
  List<ComicData> comics = List.empty();
  List<ComicItem> comicItems = List.empty();


  Icon customIcon = const Icon(Icons.search);
  Widget customTitle = const Text("DroidClub’s Marvel API");

  void _retrieveCharacters() async {
    Md5 hashResponse = await md5Client.getMd5Data(publicKey, privateKey);

    print(
        "[HomePage][_retrieveCharacter] - Printing getMd5Data result with hash: ${hashResponse.md5hash} and timestamp ${hashResponse.timeStamp}");
    List<CharacterData> retrievedCharacter = await marvelClient.getCharactersData(
        hashResponse.timeStamp!, publicKey, hashResponse.md5hash!);
    setState(() {
      characters = retrievedCharacter;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _retrieveCharacters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
            onCallBack: (String character) {
              debugPrint("Test callback");
            }
        ),
        bottomNavigationBar: const CustomBottomNavigationBar(),
        body: CharactersGridHelper(content: characters)
    );
  }
}

