import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:marvel_api_app/screens/ComicInfo.dart';
import 'package:marvel_api_app/models/marvelModels/CharacterDataModel.dart';
import 'package:marvel_api_app/models/marvelModels/ComicDataModel.dart';

class CharacterCardHelper extends StatefulWidget {

  const CharacterCardHelper({Key? key, required this.character}) : super(key: key);

  final dynamic character;

  @override
  _CharacterCardHelperState createState() => _CharacterCardHelperState();
}

class _CharacterCardHelperState extends State<CharacterCardHelper> {

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
          height: 400,
          child: Ink.image(
            fit: BoxFit.fill,
            image: Image.network(widget.character.photo!).image,
            child: InkWell(
              onTap: () {
                debugPrint(
                    '${widget.character.name} has been tapped, opening comic info');
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => ComicInfo(comic: widget.comic)));
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
                  child: Text(widget.character.name!, style: const TextStyle(fontWeight: FontWeight.bold, overflow: TextOverflow.clip)),
            ),
          ),
        )));
  }
}
