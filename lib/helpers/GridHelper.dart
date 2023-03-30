import 'package:flutter/material.dart';

import '../models/marvelModels/ComicDataModel.dart';

class GridHelper extends StatefulWidget {
  GridHelper({
    Key? key,
    required this.content
  }) : super(key: key);

  final List<ComicData> content;

  @override
  _GridHelperState createState() => _GridHelperState();
}

class _GridHelperState extends State<GridHelper> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        primary: false,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
    ),
    itemCount: widget.content.length,
    itemBuilder: (BuildContext context, int index){
      return Container(
        child: Text(widget.content[index].pageCount.toString()),
      );
    });
  }
}
