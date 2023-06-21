
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:marvel_api_app/screens/Home.dart';

void main() => runApp(const Root());

class Root extends StatelessWidget {
  const Root({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Marvel Api',
      theme: ThemeData.dark(),
      home: const HomePage(),
    );
  }
}
