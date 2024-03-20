// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:occupational_health/components/my_submit_button.dart';
import 'package:occupational_health/components/my_text_form_field.dart';
import 'package:occupational_health/model/post.dart';
import 'package:occupational_health/pages/community_page/components/community_post.dart';
import 'package:occupational_health/pages/community_page/forumn_page.dart';
import 'package:occupational_health/services/Forum/forum_service.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  late MapShapeSource _mapSource;
  late MapZoomPanBehavior _zoomPanBehavior;
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _replyController = TextEditingController();
  final textController = TextEditingController();

  // final List<String> comments = [
  //   'I am so proud of you.',
  //   'You are so strong.',
  //   'Thank you for sharing.',
  //   'Interesting topic!',
  //   'You can do it!',
  // ];

  // final List<String> replies = [
  //   'I am so proud of you.',
  //   'You are so strong.',
  //   'Thank you for sharing.',
  //   'Interesting topic!',
  //   'You can do it!',
  // ];

  // Map<String, bool> likedComments = {};

  // late Map<String, int> numberOfLikes = {
  //   for (String comment in comments) comment: 0,
  // };

  @override
  void initState() {
    _mapSource = MapShapeSource.asset("assets/world_map.json",
        shapeDataField: "continent");

    _zoomPanBehavior = MapZoomPanBehavior(
      focalLatLng: MapLatLng(27.1751, 78.0421),
      zoomLevel: 3,
      showToolbar: true,
      toolbarSettings: MapToolbarSettings(
        position: MapToolbarPosition.topLeft,
        iconColor: Colors.red,
        itemBackgroundColor: Colors.green,
        itemHoverColor: Colors.blue,
      ),
    );
    super.initState();
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
                            Post p = Post.fromMap(snapshot.data!.docs.first
                                .data() as Map<String, dynamic>);
                            p.setUid(snapshot.data!.docs.first.id);
                            return CommunityPost(
                              postId: p.uid,
                              message: p.postTitle,
                              user: p.user,
                              likes: p.likes,
                              comments: p.postComments,
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
                          MapTileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            zoomPanBehavior: _zoomPanBehavior,
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
