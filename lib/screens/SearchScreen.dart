import 'package:flutter/material.dart';
import 'package:marvel_api_app/models/marvelModels/CharacterDataModel.dart';

import '../helpers/ComicCardHelper.dart';
import '../helpers/CustomAppBar.dart';
import '../helpers/CustomBottomNavigationBar.dart';
import '../models/marvelModels/ComicDataModel.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen(
      {Key? key, required this.characterData, required this.comicData})
      : super(key: key);

  final CharacterData characterData;
  final List<ComicData> comicData;

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late List<ComicItem> comicItems;

  @override
  void initState() {
    super.initState();
    comicItems = widget.comicData
        .map((foundComics) =>
            ComicItem(foundComics.images, foundComics.title ?? ""))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(onCallBack: (String character) {}),
      bottomNavigationBar: const CustomBottomNavigationBar(),
      body: Center(
        child: Container(
          decoration: const BoxDecoration(color: Colors.deepPurple),
          child: Padding(
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
                      widget.characterData.photo!,
                      fit: BoxFit.fitWidth,
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
                          widget.characterData.name!,
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
                      return ComicCardHelper(
                          comicItem: item, comic: widget.comicData[index]);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
