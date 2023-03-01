

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomHelpers extends StatelessWidget {

  static String capitalize(String word) {
    return "${word[0].toUpperCase()}${word.substring(1).toLowerCase()}";
  }

  static Container customContainer(Color color, Row row){
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
          color: color
      ),
      child: row,
    );
  }

  static Row customRow(String text){
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            CustomHelpers.capitalize(text),
            style: const TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: Colors.white
            ),
          )
        ]
    );
  }

  static IconButton searchBar(
      Icon customIcon,
      TextEditingController _searchController,
      Widget customTitle,
      Function setState,
      Function retrieveCharacter
      ){
    return IconButton(
        onPressed: () => {
          debugPrint("called search bar on press"),
          setState(() {
            if (customIcon.icon == Icons.search) {
              customIcon = const Icon(Icons.cancel);
              customTitle = ListTile(
                leading: const Icon(
                  Icons.search,
                  color: Colors.white,
                  size: 28,
                ),
                title: TextField(
                  decoration: const InputDecoration(
                    hintText: 'find a character...',
                    hintStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                    ),
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  controller: _searchController,
                  onChanged: (String value) {
                    setState(() {
                      retrieveCharacter(_searchController.text);
                    });
                    //_searchController.clear();
                  },
                ),
              );
            } else {
              customIcon = const Icon(Icons.search);
              customTitle = const Text('DroidClub’s Marvel API');
            }
          })
        },
        icon: customIcon
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}