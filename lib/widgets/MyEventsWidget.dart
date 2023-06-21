import 'package:flutter/material.dart';

import '../models/marvelModels/MarvelEvent.dart';

class MyEventsWidget extends StatelessWidget {
  const MyEventsWidget({Key? key, required this.events}) : super(key: key);

  final List<MarvelEvent> events;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: GridView.count(
        crossAxisCount: 2,
        physics: NeverScrollableScrollPhysics(),
        children: events
            .asMap()
            .entries
            .map((e) => Align(
                  alignment: Alignment.center,
                  child: Container(
                    margin: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fitWidth,
                        image: NetworkImage(events[e.key].thumbnail.imageAssetUrl),
                      ),
                    ),
                    alignment: Alignment.center,
                  ),
                ))
            .toList(),
      ),
    );
  }
}
