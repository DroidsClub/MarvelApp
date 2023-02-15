import 'package:flutter/material.dart';

import 'helpers/CustomAppBar.dart';
import 'helpers/CustomBottomNavigationBar.dart';
import 'models/marvelModels/CharacterDataModel.dart';
import 'models/marvelModels/ComicDataModel.dart';
import 'models/md5Model.dart';
import 'services/marvel_api_client.dart';
import 'services/md5_api_client.dart';

String publicKey = "df460e7b04d986419acf029680a28d60";
String privateKey = "ebbc27080f123549ff61d4eb5101bad61f4bac26";

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  Md5Client md5Client = Md5Client();
  MarvelApiClient marvelClient = MarvelApiClient();

  int characterId = 0;
  String characterName = "initialized value";
  String characterPhoto =
      "https://seeklogo.com/images/M/marvel-comics-logo-B9EA67A8EE-seeklogo.com.png";
  String comicTitle = "";
  String comicPhoto = "";
  List<ComicData> comics = List.empty();
  List<ComicItem> comicItems = List.empty();

  final String userName = "";

  Icon customIcon = const Icon(Icons.search);
  Widget customTitle = const Text("DroidClub’s Marvel API");

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
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Stack(children: [
                    Container(
                        height: 150,
                        decoration: const BoxDecoration(
                            color: Colors.lightGreenAccent)),
                    Padding(
                        padding: const EdgeInsets.only(left: 25, top: 100),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                                height: 125,
                                width: 125,
                                decoration: const BoxDecoration(
                                    color: Colors.lightGreen,
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            "http://i.annihil.us/u/prod/marvel/i/mg/d/30/5cd9c6db7e639.jpg"))))))
                  ]),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Marvel .com'),
                          const SizedBox(height: 5),
                          const Text('@marvel.com'),
                          const SizedBox(height: 20),
                          const Text('Bio:'),
                          const Text('My first bio!'),
                          const SizedBox(height: 40),
                          const Align(child: Text('Collection', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24))),
                          SizedBox(
                            width: double.infinity,
                            height: 250.0,
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: 100,
                              itemBuilder: (context, index) {
                                return Text('item ${index+1}');
                              },
                            ),
                          )
                        ],
                      )),
                ],
              ),
            ),
          ],
        ));
  }
}
