import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:marvel_api_app/screens/CharacterList.dart';
import 'package:marvel_api_app/screens/Home.dart';
import 'package:marvel_api_app/screens/ComicList.dart';
import 'package:marvel_api_app/screens/UserProfile.dart';

typedef void MyCallback(int index);

class CustomBottomNavigationBar extends StatefulWidget {

  const CustomBottomNavigationBar({Key? key}) : super(key: key);

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
        onTap: (index) { navBarTransition(index);}
    );
  }

  void navBarTransition(int index) {
    switch (index){
      case 0:
        debugPrint('Home page clicked');
        // TODO if coming from another page, pop items on stack till only home page is left
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const HomePage()));
        break;
      case 1:
        debugPrint('Characters page clicked');
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const CharactersList()));
        break;
      case 2:
        debugPrint('Comics page clicked');
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const ComicList()));
        break;
      case 3:
        debugPrint('User profile page clicked');
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const UserProfile()));
        break;
    }
  }
}
