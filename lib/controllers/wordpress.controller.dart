import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutterpress/defines.dart';
import 'package:flutterpress/flutter_library/library.dart';
import 'package:flutterpress/models/user.model.dart';
import 'package:flutterpress/services/app.config.dart';
import 'package:get/state_manager.dart';
import 'package:hive/hive.dart';

class WordpressController extends GetxController {
  WordpressController() {
    _initCurrentUser();
  }
  Box userBox = Hive.box(HiveBox.user);
  UserModel user;

  bool get isUserLoggedIn => user != null;

  Future<dynamic> getHttp(Map<String, dynamic> params,
      {List<String> require}) async {
    Dio dio = Dio();

    if (isEmpty(params['route'])) throw 'route empty happend on client';
    if (require != null) {
      require.forEach((e) {
        if (isEmpty(params[e])) throw e + ' is empty';
      });
    }

    dio.interceptors.add(LogInterceptor());
    Response response = await dio.get(
      AppConfig.apiUrl,
      queryParameters: params,
    );
    if (response.data is String) throw response.data;
    return response.data;
  }

  /// Get version of backend API.
  ///
  /// ```dart
  /// wc.version().then((re) => print);
  /// ```
  Future<dynamic> version() async {
    return getHttp({'route': 'app.version'});
  }

  _initCurrentUser() {
    Box userBox = Hive.box(HiveBox.user);
    if (userBox.isNotEmpty) {
      var data = userBox.get(BoxKey.currentUser);
      user = UserModel.fromBackendData(data);
      update();
    }
  }

  /// Updates the user instance and notify or update listeners.
  ///
  /// TODO:
  ///  - Save user data with `HIVE`
  _updateCurrentUser(Map<String, dynamic> res) {
    this.user = UserModel.fromBackendData(res);
    userBox.put(BoxKey.currentUser, res);
    update();
  }

  /// Handle user related http request.
  ///
  /// setting `updateUserToNull` to true will let this function update the class member
  /// `user` to null. it is false by default.
  ///
  /// Ex) user login
  /// ```dart
  ///   final params = {'user_email': userEmail, 'user_pass': userPass};
  ///   params['route'] = 'user.login';
  ///   return await _onUserRequest(params);
  /// ```
  // Future<UserModel> _onUserRequest(
  //   dynamic params, {
  //   bool updateUserToNull = false,
  // }) async {
  //   if (params['route'] == null || params['route'].isEmpty) {
  //     throw 'route_param_empty';
  //   }

  //   dynamic re = await getHttp(params);
  //   if (re is String) throw re; // error string from backend.

  //   _updateUser(updateUserToNull ? null : UserModel.fromJson(re));
  //   return user;
  // }

  /// Login a user.
  ///
  /// ```dart
  ///   WordpressController
  ///     .login(userEmail: 'berry@test.com', userPass: 'berry@test.com')
  ///       .then((value) => print(value))
  ///       .catchError((e) => print(e));
  /// ```
  Future<UserModel> login({
    @required String userEmail,
    @required String userPass,
  }) async {
    if (userEmail.isEmpty) throw 'email_is_empty';
    if (userEmail.isEmpty) throw 'password_is_empty';

    final params = {'user_email': userEmail, 'user_pass': userPass};
    params['route'] = 'user.login';

    // return await _onUserRequest(params);
  }

  /// Register a new user.
  ///
  /// ```dart
  ///   WordpressController
  ///     .register(userEmail: 'berry@test.com', userPass: 'berry@test.com')
  ///       .then((value) => print(value))
  ///       .catchError((e) => print(e));
  /// ```
  ///
  /// TODO: Update additional parameters like first_name, last_name, nickname, etc.
  Future<UserModel> register(Map<String, dynamic> params) async {
    params['route'] = 'user.register';
    var data = await getHttp(params, require: [
      'user_email',
      'user_pass',
      'nickname',
    ]);
    return _updateCurrentUser(data);
  }

  /// Get user information from the backend.
  ///
  profile() {}

  /// Update user information.
  ///
  Future<UserModel> profileUpdate({String firstName = ''}) async {
    final params = {'route': 'user.update', 'session_id': user.sessionId};
    if (firstName.isNotEmpty) params['first_name'] = firstName;

    // return await _onUserRequest(params);
  }

  /// Resigns or removes the user information from the backend.
  ///
  Future resign() async {
    // return await _onUserRequest({
    //   'route': 'user.resign',
    //   'session_id': user.sessionId,
    // }, updateUserToNull: true);
  }

  /// Logouts the current logged in user.
  ///
  logout() {
    user = null;
    userBox.delete(BoxKey.currentUser);
    update();

    // _updateCurrentUser(null);
  }

  /// Create new post
  ///
  postCreate() {}

  /// Update an existing post.
  ///
  postUpdate() {}

  /// Delete an existing post.
  ///
  postDelete() {}

  /// Get a single post from backend.
  ///
  getPost() {}

  /// Gets more than one posts
  ///
  /// To get only one post, use [getPost]
  getPosts() {}

  /// Create a new comment
  ///
  commentCreate() {}

  /// Update an existing comment.
  ///
  commentUpdate() {}

  /// Delete an existing comment.
  ///
  commentDelete() {}

  /// Upload a file to backend.
  ///
  fileUpload() {}

  /// Delete an existing file from backend.
  ///
  fileDelete() {}

  /// Like a post or comment.
  ///
  like() {}

  /// Dislike a post or comment.
  ///
  dislike() {}
}
