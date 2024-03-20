// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:occupational_health/components/my_submit_button.dart';
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
    Circle(
      circleId: CircleId("1"),
      center: LatLng(53.553363, -1.390641),
      radius: 100,
      fillColor: Colors.red.withOpacity(0.5),
      strokeWidth: 0,
    ),
    Circle(
        circleId: CircleId("2"),
        center: LatLng(53.553363, -1.390641),
        radius: 20000,
        fillColor: Colors.red.withOpacity(0.7),
        strokeWidth: 0),
  ];

  final List<String> comments = [
    'I am so proud of you.',
    'You are so strong.',
    'Thank you for sharing.',
    'Interesting topic!',
    'You can do it!',
  ];

  final List<String> replies = [
    'I am so proud of you.',
    'You are so strong.',
    'Thank you for sharing.',
    'Interesting topic!',
    'You can do it!',
  ];

  Map<String, bool> likedComments = {};

  late Map<String, int> numberOfLikes = {
    for (String comment in comments) comment: 0,
  };

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
            title: "Most common symptom",
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
            if (answer == 1 || answer == 2 || answer == 3) {
              symptomCount[question] = (symptomCount[question] ?? 0) + 1;
            }
          });
        });
      });
      String mostCommonSymptomForLocation = symptomCount.entries
          .reduce((a, b) => a.value > b.value ? a : b)
          .key;
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
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Color(0xFFEFB84C),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade500,
                            offset: Offset(4.0, 4.0),
                            blurRadius: 15.0,
                            spreadRadius: 1.0,
                          ),
                          BoxShadow(
                            color: Colors.white,
                            offset: Offset(-4.0, -4.0),
                            blurRadius: 15.0,
                            spreadRadius: 1.0,
                          )
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'This is the Forum Title',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text('This is forum text'),
                            const Spacer(flex: 1),
                            Container(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    builder: (BuildContext context) {
                                      return SingleChildScrollView(
                                        child: Container(
                                          padding: EdgeInsets.only(
                                            top: MediaQuery.of(context)
                                                .padding
                                                .top,
                                            left: 16,
                                            right: 16,
                                            bottom: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              SizedBox(height: 16),
                                              Text(
                                                'Comments',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: 16),
                                              ...comments.map((comment) {
                                                return ListTile(
                                                  title: Text(comment),
                                                  trailing: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      IconButton(
                                                        icon: Icon(
                                                          Icons.thumb_up,
                                                          color: likedComments[
                                                                      comment] ==
                                                                  true
                                                              ? Colors.red
                                                              : null,
                                                        ),
                                                        onPressed: () {
                                                          setState(() {
                                                            if (likedComments[
                                                                    comment] ==
                                                                true) {
                                                              likedComments[
                                                                      comment] =
                                                                  false;
                                                              numberOfLikes[
                                                                      comment] =
                                                                  (numberOfLikes[
                                                                              comment] ??
                                                                          0) -
                                                                      1;
                                                            } else {
                                                              likedComments[
                                                                      comment] =
                                                                  true;
                                                              numberOfLikes[
                                                                      comment] =
                                                                  (numberOfLikes[
                                                                              comment] ??
                                                                          0) +
                                                                      1;
                                                            }
                                                          });
                                                        },
                                                      ),
                                                      Text(
                                                        '${numberOfLikes[comment] ?? 0}',
                                                      ),
                                                      IconButton(
                                                        icon: Icon(Icons.reply),
                                                        onPressed: () {
                                                          print(
                                                              "Reply IconButton Pressed");
                                                          showModalBottomSheet(
                                                            context: context,
                                                            isScrollControlled:
                                                                true,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return Container(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            16),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      'Enter your reply:',
                                                                      style: TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                    SizedBox(
                                                                        height:
                                                                            8),
                                                                    TextField(
                                                                      controller:
                                                                          _replyController,
                                                                      decoration:
                                                                          InputDecoration(
                                                                        hintText:
                                                                            'Type your reply here...',
                                                                        border:
                                                                            OutlineInputBorder(),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                        height:
                                                                            16),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .end,
                                                                      children: [
                                                                        TextButton(
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child:
                                                                              Text('Cancel'),
                                                                        ),
                                                                        SizedBox(
                                                                            width:
                                                                                8),
                                                                        ElevatedButton(
                                                                          onPressed:
                                                                              () {
                                                                            String
                                                                                reply =
                                                                                _replyController.text;
                                                                            if (reply.isNotEmpty) {
                                                                              Navigator.pop(context, reply);
                                                                              print("Reply cannot be empty.");
                                                                            }
                                                                          },
                                                                          child:
                                                                              Text('Submit'),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                            },
                                                          ).then((value) {
                                                            print(
                                                                "Bottom Sheet Closed");
                                                            if (value != null &&
                                                                value
                                                                    .isNotEmpty) {
                                                              setState(() {
                                                                replies
                                                                    .add(value);
                                                              });
                                                            }
                                                          });
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }).toList(),
                                              SizedBox(height: 16),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: TextField(
                                                        controller:
                                                            _commentController,
                                                        decoration:
                                                            InputDecoration(
                                                          hintText:
                                                              'Write a comment...',
                                                          border:
                                                              OutlineInputBorder(),
                                                        ),
                                                      ),
                                                    ),
                                                    IconButton(
                                                      onPressed: () {
                                                        String comment =
                                                            _commentController
                                                                .text;
                                                        if (comment
                                                            .isNotEmpty) {
                                                          setState(() {
                                                            comments
                                                                .add(comment);
                                                            _commentController
                                                                .clear();
                                                          });
                                                        }
                                                      },
                                                      icon: Icon(Icons.send),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                icon: Icon(
                                  Icons.comment_rounded,
                                  color: Colors.black,
                                ),
                                label: Text(
                                  'Comment',
                                  style: TextStyle(color: Colors.black),
                                ),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFFEFB84C)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: MySubmitButton(
                        style:
                            TextStyle(backgroundColor: const Color(0xFFEFD080)),
                        onPressed: () {},
                        text: "Click here to view more posts",
                        textSize: 16,
                      ),
                    ),
                  ],
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
