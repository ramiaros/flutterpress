import 'package:flutterpress/models/comment.model.dart';
import 'package:flutterpress/models/file.model.dart';

class PostModel {
  dynamic data;

  int id;
  int authorId;
  String authorName;
  String title;
  String content;
  String slug;

  bool deleted;

  List<CommentModel> comments;
  List<FileModel> files;

  PostModel({
    this.data,
    this.id,
    this.authorId,
    this.authorName,
    this.title,
    this.content,
    this.slug,
    comments,
    files,
    this.deleted,
  })  : this.comments = comments ?? [],
        this.files = files ?? [];

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

    List<FileModel> _files = [];
    if (data['files'] != null && data['files'].length > 0) {
      _files = data['files'].map<FileModel>((f) {
        return FileModel.fromBackendData(f);
      }).toList();
    }

    return PostModel(
      data: data,
      id: data['ID'],
      authorId: int.parse(data['post_author']),
      authorName: data['author_name'],
      title: data['post_title'],
      content: data['post_content'],
      slug: data['slug'],
      comments: _comments,
      files: _files,
      deleted: false,
    );
  }

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
    content = '';
    title = '( deleted )';
    id = 0;
  }

  deleteFile(FileModel file) {
    files.removeWhere((f) => f.id == file.id);
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
