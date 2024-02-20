import "package:flutter/material.dart";

class MyNavbar extends StatefulWidget {
  const MyNavbar({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyNavbarState();
}

class _MyNavbarState extends State<MyNavbar> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      onDestinationSelected: (value) => setState(() {
        currentPageIndex = value;
      }),
      selectedIndex: currentPageIndex,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home),
          label: "Home",
        ),
        NavigationDestination(
          icon: Icon(Icons.person),
          label: "Profile",
        ),
        NavigationDestination(
          icon: Icon(Icons.settings),
          label: "Settings",
        ),
      ],
    );
  }
}
