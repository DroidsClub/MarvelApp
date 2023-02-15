import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:marvel_api_app/UserProfile.dart';
import 'package:marvel_api_app/helpers/CustomAppBar.dart';
import 'package:marvel_api_app/models/marvelModels/CharacterDataModel.dart';
import 'package:marvel_api_app/services/marvel_api_client.dart';
import 'package:marvel_api_app/services/md5_api_client.dart';

import 'helpers/ComicCardHelper.dart';
import 'helpers/CustomBottomNavigationBar.dart';
import 'models/marvelModels/ComicDataModel.dart';
import 'models/md5Model.dart';

void main() => runApp(const Root());

String publicKey = "df460e7b04d986419acf029680a28d60";
String privateKey = "ebbc27080f123549ff61d4eb5101bad61f4bac26";

class Root extends StatelessWidget {
  const Root({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Marvel Api',
      theme: ThemeData.dark(),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

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
  List<ComicData> comics = List.empty();
  List<ComicItem> comicItems = List.empty();

  Icon customIcon = Icon(Icons.search);
  Widget customTitle = Text("DroidClub’s Marvel API");

  int selectedIndex = 0;

  void navBarTransition(int index) {
    switch (index){
      case 0:
        debugPrint('Home page clicked');
        break;
      case 1:
        debugPrint('Characters page clicked');
        break;
      case 2:
        debugPrint('Comics page clicked');
        break;
      case 3:
        debugPrint('User profile page clicked');
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const UserProfile()));
        break;
    }
  }

  void _retrieveCharacter(String character) async {
    Md5 hashResponse = await md5Client.getMd5Data(publicKey, privateKey);

    print(
        "[HomePage][_retrieveCharacter] - Printing getMd5Data result with hash: ${hashResponse.md5hash} and timestamp ${hashResponse.timeStamp}");
    CharacterData retrievedCharacter = await marvelClient.getMarvelData(
        hashResponse.timeStamp!, publicKey, hashResponse.md5hash!, character);
    setState(() {
      characterName = retrievedCharacter.name!;
      characterPhoto = retrievedCharacter.photo!;
      characterId = retrievedCharacter.id!;
      _retrieveComic(characterId);
    });
  }

  void _retrieveComic(int characterId) async {
    Md5 hashResponse = await md5Client.getMd5Data(publicKey, privateKey);
    print(
        "[HomePage][_retrieveComic] - Printing getMd5Data result with hash: ${hashResponse.md5hash} and timestamp ${hashResponse.timeStamp}");
    List<ComicData> retrievedComics = await marvelClient.getComicData(
        hashResponse.timeStamp!, publicKey, hashResponse.md5hash!, characterId);
    setState(() {
      comics = retrievedComics;
      comicItems = retrievedComics
          .map((foundComics) =>
              ComicItem(foundComics.images, foundComics.title ?? ""))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        onCallBack: (String character) {
          debugPrint("Test callback");
          _retrieveCharacter(character);
        }
      ),
        bottomNavigationBar: CustomBottomNavigationBar(
            onCallBack: (int index) {
              debugPrint("Test callback");
              navBarTransition(index);
            }
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                  child: Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: [
                  SizedBox.expand(
                      child: Image.network(
                    characterPhoto,
                    fit: BoxFit.cover,
                  )),
                  Container(
                      padding: const EdgeInsets.all(5.0),
                      alignment: Alignment.bottomCenter,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: const Alignment(0, 0.6),
                          end: Alignment.bottomCenter,
                          colors: <Color>[
                            Colors.black.withAlpha(0),
                            Colors.black54,
                            Colors.black87,
                            Colors.black
                          ],
                        ),
                      ),
                      child: Text(
                        characterName,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ))
                ],
              )),
              const SizedBox(height: 10.0),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Comics:",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 250.0,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: comicItems.length,
                  itemBuilder: (context, index) {
                    final ComicItem item = comicItems[index];
                    return ComicCardHelper(comicItem: item, comic: comics[index]);
                    },
                ),
              ),
            ],
          ),
        ));
  }
}
