import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:occupational_health/components/my_submit_button.dart';
import 'package:occupational_health/components/my_swipe_back.dart';
import 'package:occupational_health/model/rehabilitation_content.dart';
import 'package:occupational_health/pages/support_page/components/my_rehab_content_card.dart';
import 'package:occupational_health/services/Rehabilitation/rehabilitation_service.dart';
import 'package:url_launcher/url_launcher_string.dart';

class RehabilitationPage extends StatefulWidget {
  const RehabilitationPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => RehabilitationPageState();
}

class RehabilitationPageState extends State<RehabilitationPage> {
  final RehabilitationService _rehabilitationService = RehabilitationService();
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> filteredDocs = [];
  List<QueryDocumentSnapshot> docs = [];
  bool emptySearch = false;

  @override
  void initState() {
    super.initState();
    // Fetch documents
    _rehabilitationService.getRehabilitationContent().then((value) {
      setState(() {
        docs = value;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return MySwipeBack(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: const Color(0xFFEFB84C),
              actionsIconTheme: const IconThemeData(
                  color: Color.fromARGB(255, 159, 155, 155)),
              centerTitle: false,
              title: const Text("Rehab Content",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 28,
                      fontWeight: FontWeight.w600)),
            ),
            body: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 50.0),
              child: Column(children: <Widget>[
                // Search bar
                _buildSearchBar(),

                docs.isEmpty || emptySearch
                    ? _nonFound()
                    : Expanded(
                        child: ListView(
                            children: filteredDocs.isNotEmpty
                                ? filteredDocs
                                    .map(
                                        (document) => _buildRehabCard(document))
                                    .toList()
                                : docs
                                    .map(
                                        (document) => _buildRehabCard(document))
                                    .toList()),
                      ),
              ]),
            )));
  }

  Widget _nonFound() {
    return Center(
        child: Column(
      children: <Widget>[
        const Text("No Rehabilitation content available",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300)),
        const SizedBox(height: 20),
        // Clear search
        SizedBox(
          width: 200,
          child: MySubmitButton(
              onPressed: () {
                _searchController.clear();
                setState(() {
                  filteredDocs = [];
                  emptySearch = false;
                });
              },
              text: "Clear Search"),
        )
      ],
    ));
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: _searchController,
        onChanged: (value) => {
          // Filter
          filteredDocs = docs
              .where((doc) => doc['Name']
                  .toString()
                  .toLowerCase()
                  .contains(value.toLowerCase()))
              .toList(),
          setState(() {
            if (value.isNotEmpty && filteredDocs.isEmpty) {
              filteredDocs = [];
              emptySearch = true;
            } else {
              filteredDocs = filteredDocs;
              emptySearch = false;
            }
          })
        },
        cursorColor: Colors.black,
        decoration: InputDecoration(
            hintText: "Search",
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFEFB84C), width: 3),
            )),
      ),
    );
  }

  // Rehabilitation Card
  Widget _buildRehabCard(DocumentSnapshot doc) {
    final data =
        RehabilitationContent.fromMap(doc.data() as Map<String, dynamic>);
    return MyRehabCard(
        title: data.name,
        onPressed: () {
          // Add to local storage of last 2 opened rehab pages
          _rehabilitationService.addLastViewedLocalStorage(data.name, data.url);
          // Open URL
          launchUrlString(data.url);
        });
  }
}
