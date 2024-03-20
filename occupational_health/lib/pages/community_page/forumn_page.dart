import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:occupational_health/components/my_text_form_field.dart';
import 'package:occupational_health/model/post.dart';
import 'package:occupational_health/model/user.dart';
import 'package:occupational_health/pages/community_page/components/community_post.dart';
import 'package:occupational_health/services/Auth/auth_service.dart';
import 'package:occupational_health/services/Forum/forum_service.dart';
import 'package:occupational_health/pages/community_page/components/like_button.dart';

class ForumPage extends StatefulWidget {
  const ForumPage({super.key});

  @override
  State<ForumPage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<ForumPage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final textController = TextEditingController();
  final ForumService _forumService = ForumService();

  void postMessage() async {
    MyUser userInfo = await AuthService().getUserData();
    if (textController.text.isNotEmpty) {
      Post post = Post(
          user: userInfo.name ?? 'Unknown User',
          postTitle: textController.text,
          postContent: "",
          timestamp: Timestamp.now(),
          likes: [],
          postComments: []);
      _forumService.savePostWithDefaults(post);

      setState(() {
        textController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFEFB84C),
          actionsIconTheme:
              const IconThemeData(color: Color.fromARGB(255, 159, 155, 155)),
          centerTitle: false,
          title: const Text("Forum Page",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.w600)),
        ),
        body: Container(
          color: Color(0xFFEFB84C),
          child: Center(
              child: Column(
            children: [
              Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                stream: _forumService.getPostsStream(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    // Docs
                    List<QueryDocumentSnapshot> docs = snapshot.data!.docs;

                    List<Post> posts = docs.map((e) {
                      Post p = Post.fromMap(e.data() as Map<String, dynamic>);
                      p.setUid(e.id);
                      return p;
                    }).toList();

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 50.0),
                      child: ListView(
                        children: posts
                            .map((post) => CommunityPost(
                                  message: post.postTitle,
                                  user: post.user,
                                  likes: post.likes,
                                  postId: post.uid,
                                  comments: post.postComments,
                                ))
                            .toList(),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text("Error: " + snapshot.error.toString()),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              )),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Row(
                  children: [
                    Expanded(
                        child: MyTextFormField(
                      controller: textController,
                      labelText: "Write something....",
                      keyboardType: TextInputType.text,
                      validator: (value) {},
                      obscureText: false,
                    )),
                    IconButton(
                        onPressed: postMessage,
                        icon: const Icon(
                          Icons.post_add,
                          size: 50,
                        ))
                  ],
                ),
              )
            ],
          )),
        ));
  }
}
