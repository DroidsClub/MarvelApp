
import 'package:flutter/material.dart';
import 'package:marvel_api_app/models/marvelModels/ComicDataModel.dart';

import '../helpers/ComicCardHelper.dart';

class MyComicsWidget extends StatelessWidget {
  const MyComicsWidget({Key? key, required this.comics}) : super(key: key);

  final List<ComicData> comics;

  @override
  Widget build(BuildContext context) {
    print('ComicWidget page: building comic row');
    print(comics.length);
    return Container(
      color: Colors.deepPurple,
      height: 250.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: comics.length,
        itemBuilder: (context, index) {
          print('looking for comics');
          print(comics.length);
          final comicItems = comics.map((foundComics) => ComicItem(foundComics.images, foundComics.title ?? "")).toList();
          final ComicItem item = comicItems[index];
          print('title ' + item.title);
          return ComicCardHelper(
              comicItem: item, comic: comics[index]);
        },
      ),
    );
  }
}
