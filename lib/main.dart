import 'package:flutter/material.dart';
import 'package:marvel_api_app/model/marvel_data.dart';
import 'package:marvel_api_app/services/marvel_api_client.dart';
import 'package:marvel_api_app/services/md5_api_client.dart';

import 'model/md5_data.dart';

void main() => runApp( const Root());

String publicKey = "df460e7b04d986419acf029680a28d60";
String privateKey = "ebbc27080f123549ff61d4eb5101bad61f4bac26";

class Root extends StatelessWidget {
  const Root({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Marvel Api',
      theme: ThemeData.dark(),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Md5Client md5Client = Md5Client();
  MarvelApiClient marvelClient = MarvelApiClient();
  String characterName = "initialized value";
  String characterPhoto = "https://seeklogo.com/images/M/marvel-comics-logo-B9EA67A8EE-seeklogo.com.png";

  void _retrieveCharacter() async {
    String searchInput = "3-D Man";

    Md5 hashResponse = await md5Client.getMd5Data(publicKey, privateKey);

    print("[HomePage][_retrieveCharacter] - Printing getMd5Data result with hash: ${hashResponse.md5hash} and timestamp ${hashResponse.timeStamp}");
    CharacterData retrievedCharacter = await marvelClient.getMarvelData(hashResponse.timeStamp!, publicKey, hashResponse.md5hash!, searchInput);
    setState(() {
      characterName = retrievedCharacter.name!;
      characterPhoto = retrievedCharacter.photo!;
    });
  }

  @override
  void initState() {
    super.initState();
    _retrieveCharacter();
  }

  @override
  Widget build(BuildContext context) {

    // return MaterialApp(
    //   title: 'Marvel App',
    //   theme: ThemeData(
    //     brightness: Brightness.dark,
    //     primaryColor: Colors.green,
    //     secondaryHeaderColor: Colors.deepOrangeAccent
    //   ),
    //   home: const Scaffold(
    //     body: Center(
    //       child:Text('DroidClub’s Marvel App')
    //     )
    //   )
    // );

    return Scaffold(
      appBar: AppBar(
        title: const Text("DroidClub’s Marvel API"),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (BuildContext context) =>
            <PopupMenuEntry>[
              const PopupMenuItem(
                child: ListTile(
                    leading: Icon(Icons.add),
                    title: Text('Search')
                ),
              ),
              const PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.anchor),
                  title: Text('Favourite'),
                ),
              )
            ],
          ),
        ],
      ),
      body:
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(child: Image.network(characterPhoto)),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const[
                          Text("Name:")
                        ],
                      ),
                      const SizedBox(width: 120.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(characterName),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 120.0),
                  Container(
                    margin: const EdgeInsets.all(10),
                    width: double.infinity,
                    height: 50.0,
                    child: ElevatedButton(
                        onPressed: () {},
                        child: const Text("Call")
                    ),
                  ),
                  const SizedBox(height: 100.0)
                ],
              ),
      )
    );
  }
}
