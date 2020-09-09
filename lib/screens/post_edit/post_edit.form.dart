import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutterpress/controllers/wordpress.controller.dart';
import 'package:flutterpress/models/post.model.dart';
import 'package:flutterpress/defines.dart';
import 'package:flutterpress/services/keys.dart';
import 'package:flutterpress/services/app.service.dart';
import 'package:flutterpress/widgets/app.text_input_field.dart';
import 'package:flutterpress/widgets/file_display.dart';
import 'package:flutterpress/widgets/file_upload_button.dart';
import 'package:get/get.dart';

class PostEditForm extends StatefulWidget {
  @override
  _PostEditFormState createState() => _PostEditFormState();
}

class _PostEditFormState extends State<PostEditForm> with AfterLayoutMixin {
  final WordpressController wc = Get.find();

  final _formKey = GlobalKey<FormState>();
  final title = TextEditingController();
  final content = TextEditingController();

  String slug;
  PostModel post = PostModel();
  bool isUpdate = false;

  double progress = 0;

  @override
  void initState() {
    Map args = Get.arguments;
    if (args['slug'] != null) {
      slug = args['slug'];
    } else {
      post = args['post'];
      isUpdate = true;
      title.text = post.title;
      content.text = post.content;
    }
    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) {}

  void onSubmit() async {
    var params = {
      'slug': slug ?? '',
      'post_title': title.text,
      'post_content': content.text,
    };

    var fileIds = [];
    if (post.files.length > 0) {
      for (var file in post.files) fileIds.add(file.id);
      params['files'] = fileIds.join(',');
    }

    try {
      if (isUpdate) params['ID'] = post.id.toString();
      var res = await wc.postEdit(params, isUpdate: isUpdate);
      Get.back(result: res);
    } catch (e) {
      AppService.error('$e'.tr);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(md),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            AppTextInputField(
              key: ValueKey(Keys.postTitleInput),
              hintText: 'title'.tr,
              controller: title,
              inputAction: TextInputAction.done,
            ),
            AppTextInputField(
              key: ValueKey(Keys.postContentInput),
              hintText: 'content'.tr,
              controller: content,
              inputAction: TextInputAction.done,
            ),
            SizedBox(height: lg),
            FileDisplay(post.files, inEdit: true, onFileDeleted: (file) {
              post.deleteFile(file);
              setState(() {});
            }),
            SizedBox(height: lg),
            Row(
              children: [
                FileUploadButton(
                  onProgress: (value) {
                    progress = value;
                    setState(() {});
                  },
                  onUploaded: (file) {
                    post.files.add(file);
                    progress = 0;
                    setState(() {});
                  },
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: sm),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor:
                          progress > 0 ? Colors.grey : Colors.transparent,
                    ),
                  ),
                ),
                RaisedButton(
                  key: ValueKey(Keys.formSubmitButton),
                  onPressed: onSubmit,
                  child: Text('submit'.tr),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
