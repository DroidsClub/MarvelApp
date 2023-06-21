import 'package:flutter/material.dart';

typedef void MyCallback(String character);

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  CustomAppBar({
    Key? key,
    required this.onCallBack,
    this.showBack = true
  } )  : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize; // default is 56.0

  final MyCallback onCallBack;
  final bool showBack;

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  Icon customIcon = const Icon(Icons.search);
  Widget customTitle = const Text("DroidClub’s Marvel API");
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
        automaticallyImplyLeading: widget.showBack,
        title: customTitle,
        actions: [
          IconButton(
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
                            onSubmitted: (String value) {
                              widget.onCallBack(_searchController.text);
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
              icon: customIcon),
          PopupMenuButton(
            icon: const Icon(Icons.more_horiz),
            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              const PopupMenuItem(
                child:
                    ListTile(leading: Icon(Icons.add), title: Text('Search')),
              ),
              const PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.anchor),
                  title: Text('Favourite'),
                ),
              )
            ],
          ),
        ]);
  }
}
