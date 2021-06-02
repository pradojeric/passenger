import 'dart:convert';

import 'package:bmis_passenger/api/login_api.dart';
import 'package:bmis_passenger/models/login_model.dart';
import 'package:bmis_passenger/models/profile_model.dart';
import 'package:bmis_passenger/utils/shared_preferences.dart';

import '../screens/dashboard_page.dart';
import '../widgets/form_button.dart';
import '../widgets/form_text_field.dart';
import '../widgets/label_button.dart';
import 'package:flutter/material.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  LoginModel loginModel = LoginModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: 70),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 80.0,
                      child: Image.asset(
                        "assets/logo.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(height: 20),
                    FormTextField(
                      icon: Icons.email_outlined,
                      hint: 'Email Address',
                      keyboardType: TextInputType.emailAddress,
                      validator: emailValidator,
                      onSaved: emailOnSaved,
                    ),
                    FormTextField(
                      icon: Icons.lock_outline,
                      hint: 'Password',
                      pass: true,
                      validator: passwordValidator,
                      onSaved: passwordOnSaved,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: LabelButton(
                        liteText: '',
                        boldText: 'Forgot Password?',
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    FormButton(
                      btnText: 'Sign In',
                      pressed: () => formSaved(loginModel),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    LabelButton(
                      liteText: 'Not registered yet?',
                      boldText: ' Create Account.',
                      pressed: () => navigateToRegisterPage(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  emailValidator(var input) => !input.contains("@") ? "Please enter email address" : null;
  emailOnSaved(var input) => loginModel.email = input;

  passwordValidator(var input) => input.length < 7 ? "Password must have more than 7 characters" : null;
  passwordOnSaved(var input) => loginModel.password = input;

  formSaved(LoginModel model) {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      LoginApi.login(model).catchError((e) {
        print('Error $e');
      }).then((value) async {
        if (value['token'] != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Login Successful'),
            ),
          );

          await SharedService.setToken(value['token']);
          await SharedService.setProfileDetails(RegisterModel.fromJson(value['profile']));
          // await SharedService.setEmail(LoginModel.fromJson(value['user']));

          navigateToDashboardPage();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(value['message']),
            ),
          );
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login Failed! Please Check your Credentials'),
        ),
      );
    }
  }

  navigateToDashboardPage() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => DashboardPage()),
      (Route<dynamic> route) => false,
    );
  }

  navigateToRegisterPage() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => RegisterPage()),
      (Route<dynamic> route) => false,
    );
  }

  checkIfLogin() async {
    if (await SharedService.isLoggedIn()) {
      navigateToDashboardPage();
    }
  }
}
