import 'package:flutter/material.dart';
import 'package:marvel_api_app/connectors/marvel_api_client.dart';
import 'package:marvel_api_app/connectors/md5_api_client.dart';
import 'package:marvel_api_app/helpers/CustomAppBar.dart';
import 'package:marvel_api_app/models/marvelModels/CharacterDataModel.dart';
import 'package:marvel_api_app/models/marvelModels/MarvelEvent.dart';
import 'package:marvel_api_app/screens/SearchScreen.dart';
import 'package:marvel_api_app/screens/UserProfile.dart';
import 'package:marvel_api_app/widgets/MyComicsWidget.dart';

import '../helpers/CustomBottomNavigationBar.dart';
import '../models/marvelModels/ComicDataModel.dart';
import '../models/md5Model.dart';
import '../widgets/MyEventsWidget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Md5Client md5Client = Md5Client();
  MarvelApiClient marvelClient = MarvelApiClient();

  int characterId = 0;
  late List<ComicData> comics;
  late CharacterData foundCharacter;
  late List<MarvelEvent> events;

  Icon customIcon = Icon(Icons.search);
  Widget customTitle = Text("DroidClub’s Marvel API");

  int selectedIndex = 0;

  Future<CharacterData> _retrieveCharacter(String character) async {
    Md5 hashResponse = await md5Client.getMd5Data(publicKey, privateKey);
    print(
        "[HomePage][_retrieveCharacter] - Printing getMd5Data result with hash: ${hashResponse.md5hash} and timestamp ${hashResponse.timeStamp}");
    return await marvelClient.getMarvelData(
        hashResponse.timeStamp!, publicKey, hashResponse.md5hash!, character);
  }

  Future<List<ComicData>> _retrieveComic(int characterId) async {
    Md5 hashResponse = await md5Client.getMd5Data(publicKey, privateKey);
    print(
        "[HomePage][_retrieveComic] - Printing getMd5Data result with hash: ${hashResponse.md5hash} and timestamp ${hashResponse.timeStamp}");
    return await marvelClient.getComicData(
        hashResponse.timeStamp!, publicKey, hashResponse.md5hash!, characterId);
  }

  Future<List<MarvelEvent>> _getEvents() async {
    Md5 hashResponse = await md5Client.getMd5Data(publicKey, privateKey);
    return await marvelClient.getEvents(
        hashResponse.timeStamp!, publicKey, hashResponse.md5hash!,
        orderedBy: '-startDate');
  }

  Future<List<ComicData>> _getSomeComics() async {
    Md5 hashResponse = await md5Client.getMd5Data(publicKey, privateKey);
    return await marvelClient.getComics(
        hashResponse.timeStamp!, publicKey, hashResponse.md5hash!,
        orderedBy: '-focDate');
  }

  //TODO refactor to return list of stories
  Future<List<MarvelEvent>> _getStories() async {
    Md5 hashResponse = await md5Client.getMd5Data(publicKey, privateKey);
    return await marvelClient.getEvents(
        hashResponse.timeStamp!, publicKey, hashResponse.md5hash!,
        orderedBy: '');
  }

  void handleSearchResult(character) async {
    try {
      foundCharacter = await _retrieveCharacter(character);
      comics = await _retrieveComic(foundCharacter.id!);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchScreen(
            characterData: foundCharacter,
            comicData: comics,
          ),
        ),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('No character: $character found'),
          content: const Text('Try searching again'),
          actions: [
            TextButton(
              onPressed: Navigator.of(context).pop,
              child: const Text('Close'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(onCallBack: (String character) async {
        debugPrint("Test callback");
        handleSearchResult(character);
      }, showBack: false,),
      bottomNavigationBar: const CustomBottomNavigationBar(),
      // body: const Center(child: Text('Home page')));
      body: FutureBuilder(
        future: Future.wait([_getSomeComics(), _getEvents(), _getStories()]),
        builder: (
          context,
          AsyncSnapshot<List<List<dynamic>>> snapshot,
        ) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error getting data'));
          }

          print(snapshot.data);
          List<MarvelEvent> events = snapshot.data![1] as List<MarvelEvent>;
          List<ComicData> comics = snapshot.data![0] as List<ComicData>;
          //TODO add stories section to home screen
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: MyComicsWidget(
                    comics: comics,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 4.0),
                  child: Text(
                    'Events',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                ),
                MyEventsWidget(events: events),
              ],
            ),
          );
        },
      ),
    );
  }
}
