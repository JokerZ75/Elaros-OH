// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:occupational_health/components/my_submit_button.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  late MapShapeSource _mapSource;
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _replyController = TextEditingController();

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

  @override
  void initState() {
    _mapSource =
        MapShapeSource.asset("assets/lad2.json", shapeDataField: "name");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community Page'),
        backgroundColor: Color.fromARGB(249, 238, 152, 2),
      ),
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
                        onPressed: () {},
                        text: "Click here to view more posts",
                        textSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Community Map",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
              Text(
                'Click to expand',
              ),
              Container(
                height: 200,
                width: 300,
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12),
                ),
                child: _mapSource != null
                    ? SfMaps(
                        layers: [
                          MapShapeLayer(
                            source: _mapSource!,
                          ),
                        ],
                      )
                    : CircularProgressIndicator(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
