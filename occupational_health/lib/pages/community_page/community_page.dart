// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:occupational_health/components/my_submit_button.dart';
import 'package:occupational_health/model/comment.dart';
import 'package:occupational_health/model/post.dart';
import 'package:occupational_health/pages/community_page/components/community_post.dart';
import 'package:occupational_health/pages/community_page/forumn_page.dart';
import 'package:occupational_health/services/Forum/forum_service.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:occupational_health/model/questionaire.dart';
import 'package:occupational_health/services/Assessment/assessment_service.dart';
import 'package:occupational_health/services/Location/location_service.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {

  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _replyController = TextEditingController();
  Completer<GoogleMapController> _controller = Completer();
  List<Marker> markers = <Marker>[];
  List<Circle> areas = <Circle>[
  ];



  void _onMapCreated(GoogleMapController controller) async {
    _controller.complete(controller);
    // check for location permission
    LocationService locationService = LocationService();


    bool hasPermission = await locationService.checkPermission();

    if (hasPermission) {
      // get current location
      var location = await locationService.getCurrentLocation();
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(location.latitude, location.longitude),
            zoom: 7,
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SetCircles();

    // Get questions from the database
  }

  void SetCircles() async {
    // Get the locations from the database
    Map<GeoPoint, List<Questionaire>> questionaires =
        await AssessmentService().getQuestionairesFromUsersWithLocation();
    List<Circle> circles = <Circle>[];


    // Get the most common symptom for each location
    Map<GeoPoint, String> mostCommonSymptom =
        await GetSymptomsMostCommonToLocations(questionaires);

    // Make the circles
    mostCommonSymptom.forEach((location, symptom) {
      markers.add(
        Marker(
          markerId: MarkerId(location.hashCode.toString()),
          position: LatLng(location.latitude, location.longitude),
          infoWindow: InfoWindow(
            title: "Most common issue",
            snippet: symptom,
          ),
        ),
      );
      circles.add(
        Circle(
          circleId: CircleId(location.hashCode.toString()),
          center: LatLng(location.latitude, location.longitude),
          radius: 10000,
          fillColor: Colors.red.withOpacity(0.5),
          strokeWidth: 0,
          consumeTapEvents: true,
        ),
      );
    });

    // Set the circles
    setState(() {
      areas = circles;
    });
  }

  Future<Map<GeoPoint, String>> GetSymptomsMostCommonToLocations(
      Map<GeoPoint, List<Questionaire>> questionairesWithLocation) async {
    Map<GeoPoint, String> mostCommonSymptom = {};

    // Get the most common symptom for each location
    questionairesWithLocation.forEach((location, questionaires) {
      Map<String, int> symptomCount = {};
      questionaires.forEach((questionaire) {
        questionaire.questionaire.forEach((section, questions) {
          questions.forEach((question, answer) {
            if (answer == 1) {
              symptomCount[question] = (symptomCount[question] ?? 0) + 1;
            }
            else if (answer == 2) {
              symptomCount[question] = (symptomCount[question] ?? 0) + 2;
            }
            else if (answer == 3) {
              symptomCount[question] = (symptomCount[question] ?? 0) + 3;
            }
          });
        });
      });
      String mostCommonSymptomForLocation = symptomCount.entries
          .reduce((a, b) => a.value > b.value ? a : b)
          .key;

      // Find the section the symptom is in
      questionaires.first.questionaire.forEach((section, questions) {
        if (questions.containsKey(mostCommonSymptomForLocation)) {
          mostCommonSymptomForLocation = section;
        }
      });
      mostCommonSymptom[location] = mostCommonSymptomForLocation;
    });

    // Get the most common symptom for each location

    return mostCommonSymptom;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(15),
          child: Column(
            children: [
              InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Forum Posts',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFEFB84C),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: EdgeInsets.all(10.0),
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  child: Column(
                    children: [
                      StreamBuilder(
                          stream: ForumService().getMostRecent(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return SizedBox(
                                  height: 250,
                                  child: Center(child: Text("No posts")));
                            }
                            if (snapshot.hasError) {
                              print(snapshot.error.toString());
                            }
                            if (snapshot.data!.docs.isEmpty) {
                              return SizedBox(
                                  height: 250,
                                  child: Center(child: Text("No posts")));
                            }
                            Post p = Post.fromMap(snapshot.data!.docs.first
                                .data() as Map<String, dynamic>);
                            p.setUid(snapshot.data!.docs.first.id);
                            var lastPost = [];
                            if (p.postComments.isNotEmpty) {
                              lastPost = [p.postComments.last];
                            }
                            return CommunityPost(
                              postId: p.uid,
                              message: p.postTitle,
                              user: p.user,
                              likes: p.likes,
                              comments: lastPost.isEmpty
                                  ? lastPost
                                  : p.postComments,
                            );
                          }),
                      SizedBox(height: 20),
                      MySubmitButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const ForumPage()));
                          },
                          text: "View more posts")
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),


              // Community Map

              Text(
                "Community Map",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),


              const SizedBox(height: 10),

              Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 31, 29, 27),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(53.553363, -1.390641),
                    zoom: 7,
                  ),
                  myLocationButtonEnabled: false,
                  myLocationEnabled: false,
                  circles: areas.toSet(),
                  markers: markers.toSet(),
                  gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                    Factory<OneSequenceGestureRecognizer>(
                      () => EagerGestureRecognizer(),
                    ),
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
