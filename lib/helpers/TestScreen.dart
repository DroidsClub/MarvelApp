import 'package:flutter/material.dart';

import 'TestFunctionWidget.dart';

class TestScreen extends StatefulWidget {
  TestScreen({
    Key? key,
  }) : super(key: key);

  @override
  _TestScreen1State createState() => _TestScreen1State();
}

class _TestScreen1State extends State<TestScreen> {
  @override
  Widget build(BuildContext context) {
    return TestFunctionWidget(
      onCallback: () {
        // To do
      },
    );
  }
}
