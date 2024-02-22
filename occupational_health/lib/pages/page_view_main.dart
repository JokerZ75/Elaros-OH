import "package:flutter/material.dart";
import "package:occupational_health/pages/community_page.dart";
import 'package:occupational_health/pages/health_page/health_page.dart';
import "package:occupational_health/pages/home_page.dart";
import "package:occupational_health/pages/my_account_page.dart";
import "package:occupational_health/pages/support_page/support_page.dart";
import "package:occupational_health/services/Auth/auth_service.dart";

class ListViewMain extends StatefulWidget {
  const ListViewMain({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ListViewMainState();
}

class _ListViewMainState extends State<ListViewMain> {
  int currentPageIndex = 0;
  bool changingByNavBar = false;

  ///////////////////////////////////////////////////////////////////
  // Pages to be displayed go here
  List<PageData> pages = [
    PageData(
        appBarTitle: "Home",
        navTitle: "Home",
        page: const HomePage(),
        navIcon: const Icon(Icons.home)),
    PageData(
        appBarTitle: "My Health",
        navTitle: "My Health",
        page: const HealthPage(),
        navIcon: const Icon(Icons.health_and_safety)),
    PageData(
        appBarTitle: "Support",
        navTitle: "Support",
        navIcon: const Icon(Icons.support_agent),
        page: const SupportPage()),
    PageData(
        appBarTitle: "Community",
        navTitle: "Community",
        navIcon: const Icon(Icons.people),
        page: const CommunityPage()
    )
  ];
  //////////////////////////////////////////////////////////////////

  PageController pageController = PageController();

  void signOut() async {
    final AuthService authService = AuthService();
    try {
      await authService.signOut();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFEFB84C),
        actionsIconTheme: const IconThemeData(color: Colors.black),
        centerTitle: false,
        title: Text(pages[currentPageIndex].appBarTitle,
            style: const TextStyle(
                color: Colors.black,
                fontSize: 28,
                fontWeight: FontWeight.w600)),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.account_circle_outlined,
                color: Colors.black, size: 42),
            onPressed: () => {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const MyAccountPage()))
            },
          ),
        ],
      ),
      bottomNavigationBar: _buildNav(context),
      body: PageView(
        onPageChanged: (value) => {
          if (!changingByNavBar)
            {
              setState(() {
                currentPageIndex = value;
              })
            }
        },
        controller: pageController,
        children: <Widget>[for (var page in pages) page.page],
      ),
    );
  }

  Widget _buildNav(BuildContext context) {
    return NavigationBar(
      onDestinationSelected: (value) => {
        setState(() {
          changingByNavBar = true;
          currentPageIndex = value;
          pageController.animateToPage(value,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut);
          Future.delayed(const Duration(milliseconds: 300), () {
            changingByNavBar = false;
          });
        }),
      },
      animationDuration: const Duration(milliseconds: 500),
      selectedIndex: currentPageIndex,
      backgroundColor: const Color(0xFFEFB84C),
      indicatorColor: Colors.white,
      destinations: [
        for (var page in pages)
          NavigationDestination(icon: page.navIcon, label: page.navTitle),
      ],
    );
  }
}

class PageData {
  final String appBarTitle;
  final String navTitle;
  final Icon navIcon;
  final Widget page;

  PageData(
      {required this.appBarTitle,
      required this.navTitle,
      required this.navIcon,
      required this.page});
}
