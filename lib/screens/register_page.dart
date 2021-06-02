import 'package:bmis_passenger/api/login_api.dart';
import 'package:bmis_passenger/models/profile_model.dart';
import 'package:flutter/material.dart';
import '../widgets/form_button.dart';
import '../widgets/form_text_field.dart';
import '../widgets/label_button.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  RegisterModel register = RegisterModel();
  bool isButtonDisabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 70),
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
                    icon: Icons.person_outline,
                    hint: 'First Name',
                    validator: firstNameValidator,
                    onSaved: firstNameOnSaved,
                  ),
                  FormTextField(
                    icon: Icons.person_outline,
                    hint: 'Last Name',
                    validator: lastNameValidator,
                    onSaved: lastNameOnSaved,
                  ),
                  FormTextField(
                    icon: Icons.verified_user,
                    hint: 'Username',
                    validator: userNameValidator,
                    onSaved: userNameOnSaved,
                  ),
                  FormTextField(
                    icon: Icons.phone_android,
                    hint: 'Phone Number',
                    keyboardType: TextInputType.number,
                    validator: contactValidator,
                    onSaved: contactOnSaved,
                  ),
                  FormTextField(
                    icon: Icons.house,
                    hint: 'Address',
                    validator: addressValidator,
                    onSaved: addressOnSaved,
                  ),
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
                  FormButton(
                    btnText: 'Create Account',
                    pressed: () => formSaved(register),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  LabelButton(
                    liteText: 'Already Registered?',
                    boldText: ' Sign In.',
                    pressed: () => navigateToLoginPage(),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  firstNameValidator(var value) => value == null || value.isEmpty ? 'Please enter first name' : null;
  firstNameOnSaved(var value) => register.firstName = value;

  lastNameValidator(var value) => value == null || value.isEmpty ? 'Please enter last name' : null;
  lastNameOnSaved(var value) => register.lastName = value;

  userNameValidator(var value) => value == null || value.isEmpty ? 'Please enter username' : null;
  userNameOnSaved(var value) => register.userName = value;

  contactValidator(var value) => value == null || value.isEmpty ? 'Please enter contact' : null;
  contactOnSaved(var value) => register.contact = value;

  addressValidator(var value) => value == null || value.isEmpty ? 'Please enter address' : null;
  addressOnSaved(var value) => register.address = value;

  emailValidator(var input) => !input.contains("@") ? "Please enter email address" : null;
  emailOnSaved(var input) => register.email = input;

  passwordValidator(var input) => input.length < 7 ? "Password must have more than 7 characters" : null;
  passwordOnSaved(var input) => register.password = input;

  formSaved(RegisterModel model) {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      LoginApi.register(model).then((value) {
        print(value);
        if (value['message'] == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${value.values.first}'),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${value.values.first}'),
            ),
          );
          navigateToLoginPage();
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

  navigateToLoginPage() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (Route<dynamic> route) => false,
    );
  }
}
