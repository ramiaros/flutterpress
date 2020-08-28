import 'package:flutterpress/models/comment.model.dart';

class PostModel {
  dynamic data;

  int id;
  int authorId;
  String authorName;
  String title;
  String content;
  String slug;

  List<CommentModel> comments;

  PostModel({
    this.data,
    this.id,
    this.authorId,
    this.authorName,
    this.title,
    this.content,
    this.slug,
    this.comments,
  });

  factory PostModel.fromBackendData(dynamic data) {
    if (data is String) {
      return PostModel(data: data);
    }

    List<CommentModel> _comments = [];
    if (data['comments'] != null && data['comments'].length > 0) {
      _comments = data['comments'].map<CommentModel>((c) {
        return CommentModel.fromBackendData(c);
      }).toList();
    }

    data['comments'].map((c) => CommentModel.fromBackendData(c));

    return PostModel(
        data: data,
        id: data['ID'],
        authorId: int.parse(data['post_author']),
        authorName: data['author_name'],
        title: data['post_title'],
        content: data['post_content'],
        slug: data['slug'],
        comments: _comments);
  }

  bool deleted = false;

  insertComment(int commentParentId, CommentModel comment) {
    int i = 0;
    int depth = 1;
    if (commentParentId > 0) {
      i = comments.indexWhere((c) {
            depth = c.depth + 1;
            return c.id == commentParentId;
          }) +
          1;
    }
    comment.depth = depth;
    comments.insert(i, comment);
  }

  delete() {
    deleted = true;
    content = '( deleted )';
    title = '( deleted )';
    id = 0;
  }

  update(PostModel post) {
    data = post.data;
    title = post.title;
    content = post.content;
    slug = post.slug;
  }

  @override
  String toString() {
    return data.toString();
  }
}