import 'package:flutter/material.dart';

void main() => runApp( const Root());

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
  @override
  Widget build(BuildContext context) {
    final ButtonStyle style =
    ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20),);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Marvel API"),
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
                Expanded(child: Image.asset("images/scene-Iron-Man.jpg")),
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
                  children: const[
                    Text("#")
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


