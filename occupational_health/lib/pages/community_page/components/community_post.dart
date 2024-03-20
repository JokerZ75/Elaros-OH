import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:occupational_health/model/comment.dart';
import 'package:occupational_health/model/user.dart';
import 'package:occupational_health/pages/community_page/components/comment_button.dart';
import 'package:occupational_health/pages/community_page/components/like_button.dart';
import 'package:occupational_health/services/Auth/auth_service.dart';
import 'package:occupational_health/services/Forum/forum_service.dart';
import 'package:occupational_health/pages/community_page/components/comment_post.dart';
import 'package:occupational_health/helper/helper_method.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class CommunityPost extends StatefulWidget {
  final String message;
  final String user;
  String? postId = "";
  List<dynamic>? likes = [];
  List<dynamic>? comments = [];

  CommunityPost({
    Key? key,
    required this.message,
    required this.user,
    this.likes,
    this.postId,
    this.comments,
  }) : super(key: key);

  @override
  State<CommunityPost> createState() => _CommunityPostState();
}

class _CommunityPostState extends State<CommunityPost> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final _forumService = ForumService();
  final _commentTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void _toggleLike(String? postId) {
    _forumService.toggleLike(postId, widget.likes);
  }

  void addComment(String commentText) async {
    MyUser user = await AuthService().getUserData();
    Comment c = Comment(
      user: user.name,
      text: commentText,
      timestamp: Timestamp.now(),
    );

    widget.comments == null
        ? widget.comments = [c.toMap()]
        : widget.comments!.add(c.toMap());

    _forumService.saveComment(widget.postId!, widget.comments!);
  }

  void showCommentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add Comment"),
        content: TextField(
          controller: _commentTextController,
          decoration: InputDecoration(hintText: "Write comment..."),
        ),
        actions: [
          //cancel button
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _commentTextController.clear();
            },
            child: Text("Cancel"),
          ),
          //post button
          TextButton(
            onPressed: () {
              addComment(_commentTextController.text);
              Navigator.pop(context);
              _commentTextController.clear();
            },
            child: Text("Post"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.only(top: 25, left: 25, right: 25),
      padding: EdgeInsets.all(25),
      child: Column(
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[400],
                        ),
                        padding: EdgeInsets.all(10),
                        child: const Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        widget.user,
                        style: TextStyle(color: Colors.grey[700], fontSize: 20),
                      ),
                      const SizedBox(width: 20),
                      const SizedBox(height: 10),
                      Text(
                        widget.message,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      const SizedBox(height: 5),
                      widget.comments != null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: widget.comments!
                                  .map((e) => CommentWidget(
                                      comment: Comment.fromMap(
                                          e as Map<String, dynamic>)))
                                  .toList(),
                            )
                          : const SizedBox(),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SizedBox(),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Row(
                children: [
                  LikeButton(
                    isLiked: widget.likes!.contains(currentUser.uid),
                    onTap: () {
                      _toggleLike(widget.postId);
                    },
                  ),
                  SizedBox(width: 5),
                  Text(widget.likes!.length.toString()),
                ],
              ),
              const SizedBox(
                width: 20,
              ),
              CommentButton(onTap: showCommentDialog),
              SizedBox(width: 5),
              Text(widget.comments!.length.toString()),
            ],
          ),
        ],
      ),
    );
  }
}
