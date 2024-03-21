import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:occupational_health/model/comment.dart';
import 'package:occupational_health/pages/my_account_page.dart';
import 'package:occupational_health/pages/community_page/components/community_post.dart';
import 'package:occupational_health/helper/helper_method.dart';

class CommentWidget extends StatelessWidget {
  final Comment comment;

  const CommentWidget({Key? key, required this.comment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(4),
      ),
      margin: const EdgeInsets.only(bottom: 5, top: 10),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Comment text
          SizedBox(
            width: 180,
            child: Text(comment.text,)),

          const SizedBox(height: 5),

          // Username
          Text(
            "Name: ${comment.user}",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),

          // Timestamp
          Text(
            "${formatData(comment.timestamp)}",
          ),
        ],
      ),
    );
  }
}
