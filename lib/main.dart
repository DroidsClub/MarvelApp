import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:marvel_api_app/ComicInfo.dart';
import 'package:marvel_api_app/model/marvel_data.dart';
import 'package:marvel_api_app/services/marvel_api_client.dart';
import 'package:marvel_api_app/services/md5_api_client.dart';

import 'model/md5_data.dart';

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
  String characterPhoto =
      "https://seeklogo.com/images/M/marvel-comics-logo-B9EA67A8EE-seeklogo.com.png";
  String comicTitle = "";
  String comicPhoto = "";
  List<ComicData> comics = List.empty();
  List<ComicItem> comicItems = List.empty();

  void _retrieveCharacter(String character) async {
    Md5 hashResponse = await md5Client.getMd5Data(publicKey, privateKey);

    print(
        "[HomePage][_retrieveCharacter] - Printing getMd5Data result with hash: ${hashResponse
            .md5hash} and timestamp ${hashResponse.timeStamp}");
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
        "[HomePage][_retrieveComic] - Printing getMd5Data result with hash: ${hashResponse
            .md5hash} and timestamp ${hashResponse.timeStamp}");
    List<ComicData> retrievedComics = await marvelClient.getComicData(
        hashResponse.timeStamp!, publicKey, hashResponse.md5hash!, characterId);
    setState(() {
      comics = retrievedComics;
      comicItems = retrievedComics
          .map((foundComics) => ComicItem(foundComics.images, foundComics.title ?? ""))
          .toList();
    });
  }

  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Widget oldComicContainer(item, context) {
    return Container(
        margin: const EdgeInsets.all(5),
        width: 150,
        height: 150,
        child: Column(children: [
          Expanded(child: item.getImageToShow(context)),
          Expanded(child: item.buildTitle(context)),
        ]));
  }

  Widget newComicCard(item, context, comic) {
    return Card(
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          width: 155,
          child: Ink.image(
            fit: BoxFit.fill,
            image: item.getImageToShow(context).image,
            child: InkWell(
              onTap: () {
                debugPrint('${comic.title} has been tapped, opening comic info');
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ComicInfo(comic: comic)
                    )
                );
              },
              child: Container(
                padding: const EdgeInsets.all(5.0),
                alignment: Alignment.bottomCenter,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: const Alignment(0, 0.05),
                    end: Alignment.bottomCenter,
                    colors: <Color>[
                      Colors.black.withAlpha(0),
                      Colors.black38,
                      Colors.black54,
                      Colors.black87,
                      Colors.black
                    ],
                  ),
                ),
                child: item.buildTitle(context)),
            ),
          ),
        ));
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
                  child:
                  ListTile(leading: Icon(Icons.add), title: Text('Search')),
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
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              OverflowBar(
                alignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      filled: true,
                      labelText: 'Search Character',
                    ),
                    controller: _searchController,
                    onSubmitted: (String value){
                      setState(() {
                        _retrieveCharacter(_searchController.text);
                      });
                      _searchController.clear();
                    },

                  ),
                ],
              ),
              const SizedBox(height: 10.0),
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
                      return newComicCard(item, context, comics[index]);
                    },
                ),
              ),
              // const SizedBox(height: 100.0)
            ],
          ),
        ));
  }
}
