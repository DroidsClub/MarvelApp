import 'package:flutter/material.dart';
import 'package:marvel_api_app/helpers/CharacterCardHelper.dart';
import 'package:marvel_api_app/helpers/ComicCardHelper.dart';
import 'package:marvel_api_app/models/marvelModels/CharacterDataModel.dart';

import '../models/marvelModels/ComicDataModel.dart';

class CharactersGridHelper extends StatefulWidget {
  CharactersGridHelper({
    Key? key,
    required this.content,
  }) : super(key: key);

  final List<CharacterData> content;

  @override
  _CharactersGridHelperState createState() => _CharactersGridHelperState();
}

class _CharactersGridHelperState extends State<CharactersGridHelper> {

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
          return CharacterCardHelper(character: widget.content[index]);
        });
  }
}
