import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

typedef void MyCallback(int index);

class CustomBottomNavigationBar extends StatefulWidget {

  const CustomBottomNavigationBar({Key? key, required this.onCallBack,}) : super(key: key);

  final MyCallback onCallBack;

  @override
  _CustomBottomNavigationBarState createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        backgroundColor: Colors.red,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined, color: Colors.white), activeIcon: Icon(Icons.home, color: Colors.white), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.people_outline, color: Colors.white), activeIcon: Icon(Icons.people, color: Colors.white), label: 'Characters'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book_outlined, color: Colors.white), activeIcon: Icon(Icons.menu_book, color: Colors.white), label: 'Comics'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle_outlined, color: Colors.white), activeIcon: Icon(Icons.account_circle, color: Colors.white), label: 'Profile'),
        ],
        onTap: (index) { widget.onCallBack(index);}
    );
  }
}
