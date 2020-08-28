import 'package:flutter/material.dart';
import 'package:flutterpress/controllers/wordpress.controller.dart';
import 'package:flutterpress/flutter_library/library.dart';
import 'package:flutterpress/models/post.model.dart';
import 'package:flutterpress/screens/post_list/post.dart';
import 'package:get/get.dart';

class PostList extends StatefulWidget {
  PostList(this.posts);
  final List<PostModel> posts;
  @override
  _PostListState createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  final WordpressController wc = Get.find();

  @override
  Widget build(BuildContext context) {
    var postList = widget.posts;

    if (isEmpty(postList))
      return Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('loading'.tr),
        ),
      );

    return Column(
      children: [for (PostModel post in widget.posts) Post(post: post)],
    );
  }
}
