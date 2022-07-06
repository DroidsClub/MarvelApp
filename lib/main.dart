import 'package:flutter/material.dart';
import 'package:marvel_api_app/model/marvel_data.dart';
import 'package:marvel_api_app/services/marvel_api_client.dart';
import 'package:marvel_api_app/services/md5_api_client.dart';

import 'model/md5_data.dart';

void main() => runApp( const Root());

String publicKey = "df460e7b04d986419acf029680a28d60";
String privateKey = "ebbc27080f123549ff61d4eb5101bad61f4bac26";

class Root extends StatelessWidget {
  const Root({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Marvel Api',
      theme: ThemeData.dark(),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Md5Client md5Client = Md5Client();
  MarvelApiClient marvelClient = MarvelApiClient();
  int characterId = 0;
  String characterName = "initialized value";
  String characterPhoto = "https://seeklogo.com/images/M/marvel-comics-logo-B9EA67A8EE-seeklogo.com.png";
  String comicTitle = "";
  String comicPhoto = "";

  void _retrieveCharacter() async {
    String searchInput = "Vision";

    Md5 hashResponse = await md5Client.getMd5Data(publicKey, privateKey);

    print("[HomePage][_retrieveCharacter] - Printing getMd5Data result with hash: ${hashResponse.md5hash} and timestamp ${hashResponse.timeStamp}");
    CharacterData retrievedCharacter = await marvelClient.getMarvelData(hashResponse.timeStamp!, publicKey, hashResponse.md5hash!, searchInput);
    setState(() {
      characterName = retrievedCharacter.name!;
      characterPhoto = retrievedCharacter.photo!;
      characterId = retrievedCharacter.id!;
    });
  }

  void _retrieveComic(int characterId) async {
    Md5 hashResponse = await md5Client.getMd5Data(publicKey, privateKey);
    print("[HomePage][_retrieveComic] - Printing getMd5Data result with hash: ${hashResponse.md5hash} and timestamp ${hashResponse.timeStamp}");
    ComicData retrievedComic = await marvelClient.getComicData(hashResponse.timeStamp!, publicKey, hashResponse.md5hash!, characterId);
    setState(() {
      comicTitle = retrievedComic.title!;
      comicPhoto = retrievedComic.photo!;
    });
  }

  @override
  void initState() {
    super.initState();
    _retrieveCharacter();
    _retrieveComic(1009697);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("DroidClub’s Marvel API"),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (BuildContext context) =>
            <PopupMenuEntry>[
              const PopupMenuItem(
                child: ListTile(
                    leading: Icon(Icons.add),
                    title: Text('Search')
                ),
              ),
              const PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.anchor),
                  title: Text('Favourite'),
                ),
              )
            ],
          ),
        ],
      ),
      body:
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(child: Image.network(comicPhoto)),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const[
                          Text("Title:")
                        ],
                      ),
                      const SizedBox(width: 80.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(comicTitle),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 120.0),
                  Container(
                    margin: const EdgeInsets.all(10),
                    width: double.infinity,
                    height: 50.0,
                    child: Row(
                      children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:[Expanded(child: Image.network(characterPhoto))]),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:[Text('Name: $characterName')])
                      ],
                    ),
                  ),
                  const SizedBox(height: 100.0)
                ],
              ),
      )
    );
  }
}
