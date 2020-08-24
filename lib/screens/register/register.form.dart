import 'package:flutter/material.dart';
import 'package:flutterpress/services/app.routes.dart';
import 'package:flutterpress/services/app.service.dart';
import 'package:get/get.dart';
import 'package:flutterpress/controllers/wordpress.controller.dart';

class RegisterForm extends StatefulWidget {
  @override
  RegisterFormState createState() {
    return RegisterFormState();
  }
}

/// TODO
///   - Add validation
///   - Update UI
class RegisterFormState extends State<RegisterForm> {
  final WordpressController wc = Get.find();

  final _formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final pass = TextEditingController();
  final nickname = TextEditingController();

  // _onSubmit(String email, String password) {
  //   wc.register(userEmail: email, userPass: password).then((user) {
  //     Get.offNamed(AppRoutes.profile);
  //   }).catchError((err) {
  //     Get.snackbar(
  //       'Register Failed',
  //       '$err',
  //     );
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(hintText: 'email'),
            controller: email,
          ),
          TextFormField(
            decoration: InputDecoration(hintText: 'password'),
            controller: pass,
          ),
          TextFormField(
            decoration: InputDecoration(hintText: 'Nickname'),
            controller: nickname,
          ),
          RaisedButton(
            onPressed: () async {
              try {
                await wc.register({
                  'user_email': email.text,
                  'user_pass': pass.text,
                  'nickname': nickname.text,
                });
              } catch (e) {
                // AppService.error(e);
              }
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }
}
