import "package:flutter/material.dart";
import "package:occupational_health/pages/health_page.dart";
import "package:occupational_health/pages/home_page.dart";

class ListViewMain extends StatefulWidget {
  const ListViewMain({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ListViewMainState();
}

class _ListViewMainState extends State<ListViewMain> {
  int currentPageIndex = 0;
  List<Widget> pages = <Widget>[
    const HomePage(),
    const HealthPage(),
    const HomePage(),
    const HomePage()
  ];
  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _buildNav(context),
      body: PageView(
        onPageChanged: (value) => setState(() => currentPageIndex = value),
        controller: pageController,
        children:  <Widget>[
          pages[0],
          pages[1],
          pages[2],
          pages[3],
        ],
      ),
    );
  }

  Widget _buildNav(BuildContext context) {
    return NavigationBar(
      onDestinationSelected: (value) => setState(() {
        currentPageIndex = value;
        pageController.animateToPage(value,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut);
      }),
      animationDuration: const Duration(milliseconds: 500),
      selectedIndex: currentPageIndex,
      backgroundColor: const Color(0xFFEFB84C),
      indicatorColor: Colors.white,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home),
          label: "Home",
        ),
        NavigationDestination(
          icon: Icon(Icons.health_and_safety),
          label: "My Health",
        ),
        NavigationDestination(
          icon: Icon(Icons.support_agent),
          label: "Support",
        ),
        NavigationDestination(icon: Icon(Icons.people), label: "Community")
      ],
    );
  }
}
