import 'package:flutter/material.dart';
import 'package:marvel_api_app/helpers/ComicCardHelper.dart';

import '../models/marvelModels/ComicDataModel.dart';

class ComicGridHelper extends StatefulWidget {
  ComicGridHelper({
    Key? key,
    required this.content,
  }) : super(key: key);

  final List<ComicData> content;

  @override
  _ComicGridHelperState createState() => _ComicGridHelperState();
}

class _ComicGridHelperState extends State<ComicGridHelper> {
  List<ComicItem> getComicItems() {
    return widget.content
        .map((foundComics) =>
            ComicItem(foundComics.images, foundComics.title ?? ""))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        primary: false,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8
        ),
        itemCount: widget.content.length,
        itemBuilder: (BuildContext context, int index) {
          // return Container(
          //   child: Text(widget.content[index].pageCount.toString()),
          // );

          return ComicCardHelper(
              comicItem: getComicItems()[index], comic: widget.content[index]);
        });
  }
}
