import 'package:flutter/material.dart';

import 'helpers/CustomAppBar.dart';
import 'helpers/CustomBottomNavigationBar.dart';
import 'helpers/GridHelper.dart';
import 'models/marvelModels/ComicDataModel.dart';
import 'models/md5Model.dart';
import 'connectors/marvel_api_client.dart';
import 'connectors/md5_api_client.dart';

String publicKey = "df460e7b04d986419acf029680a28d60";
String privateKey = "ebbc27080f123549ff61d4eb5101bad61f4bac26";

class ComicList extends StatefulWidget {
  const ComicList({Key? key}) : super(key: key);

  @override
  _ComicListState createState() => _ComicListState();
}

class _ComicListState extends State<ComicList> {
  Md5Client md5Client = Md5Client();
  MarvelApiClient marvelClient = MarvelApiClient();

  String comicTitle = "";
  String comicPhoto = "";
  List<ComicData> comics = List.empty();
  List<ComicItem> comicItems = List.empty();

  final String userName = "";

  Icon customIcon = const Icon(Icons.search);
  Widget customTitle = const Text("DroidClub’s Marvel API");

  void _retrieveComics() async {
    Md5 hashResponse = await md5Client.getMd5Data(publicKey, privateKey);
    print(
        "[HomePage][_retrieveComic] - Printing getMd5Data result with hash: ${hashResponse.md5hash} and timestamp ${hashResponse.timeStamp}");
    List<ComicData> retrievedComics = await marvelClient.getComics(
        hashResponse.timeStamp!, publicKey, hashResponse.md5hash!);
    setState(() {
      comics = retrievedComics;
      comicItems = retrievedComics
          .map((foundComics) =>
          ComicItem(foundComics.images, foundComics.title ?? ""))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    _retrieveComics();
    return Scaffold(
        appBar: CustomAppBar(
            onCallBack: (String character) {
              debugPrint("Test callback");
              _retrieveComics();
            }
        ),
        bottomNavigationBar: const CustomBottomNavigationBar(),
        body: GridHelper(content: comics)
    );
  }
}

