import 'package:flutter/material.dart';

class TestFunctionWidget extends StatelessWidget {
  final Function onCallback;

  const TestFunctionWidget({
    Key? key, required this.onCallback
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onCallback();
      },
      child: Container(
        child: const Text("Test Call Back"),
      ),
    );
  }
}
