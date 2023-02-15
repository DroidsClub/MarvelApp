import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:marvel_api_app/ComicInfo.dart';
import 'package:marvel_api_app/models/marvelModels/ComicDataModel.dart';

class ComicCardHelper extends StatefulWidget {

  const ComicCardHelper({Key? key, required this.comicItem, required this.comic}) : super(key: key);

  final dynamic comicItem;

  final ComicData comic;

  @override
  _ComicCardHelperState createState() => _ComicCardHelperState();
}

class _ComicCardHelperState extends State<ComicCardHelper> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          width: 155,
          child: Ink.image(
            fit: BoxFit.fill,
            image: widget.comicItem.getImageToShow(context).image,
            child: InkWell(
              onTap: () {
                debugPrint(
                    '${widget.comic.title} has been tapped, opening comic info');
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ComicInfo(comic: widget.comic)));
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
                  child: widget.comicItem.buildTitle(context)),
            ),
          ),
        ));
  }
}
