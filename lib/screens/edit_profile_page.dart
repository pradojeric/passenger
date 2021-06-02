import 'package:bmis_passenger/api/login_api.dart';
import 'package:bmis_passenger/models/profile_model.dart';
import 'package:bmis_passenger/screens/dashboard_page.dart';
import 'package:bmis_passenger/utils/shared_preferences.dart';
import 'package:flutter/material.dart';
import '../widgets/form_button.dart';
import '../widgets/form_text_field.dart';
import '../widgets/label_button.dart';
import 'login_page.dart';

class EditProfilePage extends StatefulWidget {
  EditProfilePage(this.profile);

  final RegisterModel profile;

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  GlobalKey<FormState> _formUpdate = GlobalKey<FormState>();
  RegisterModel register;
  bool isButtonDisabled = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setProfile();
  }

  setProfile() async {
    register = await SharedService.getProfileDetails();
    // register.email = await SharedService.getEmail();
    print(register.toJson());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formUpdate,
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
                    initialValue: '${widget.profile.firstName}',
                    icon: Icons.person_outline,
                    hint: 'First Name',
                    validator: firstNameValidator,
                    onSaved: firstNameOnSaved,
                  ),
                  FormTextField(
                    initialValue: '${widget.profile.lastName}',
                    icon: Icons.person_outline,
                    hint: 'Last Name',
                    validator: lastNameValidator,
                    onSaved: lastNameOnSaved,
                  ),
                  FormTextField(
                    initialValue: '${widget.profile.userName}',
                    icon: Icons.verified_user,
                    hint: 'Username',
                    validator: userNameValidator,
                    onSaved: userNameOnSaved,
                  ),
                  FormTextField(
                    initialValue: '${widget.profile.contact}',
                    icon: Icons.phone_android,
                    hint: 'Phone Number',
                    keyboardType: TextInputType.number,
                    validator: contactValidator,
                    onSaved: contactOnSaved,
                  ),
                  FormTextField(
                    initialValue: '${widget.profile.address}',
                    icon: Icons.house,
                    hint: 'Address',
                    validator: addressValidator,
                    onSaved: addressOnSaved,
                  ),
                  FormTextField(
                    icon: Icons.lock_outline,
                    hint: 'Password',
                    pass: true,
                    validator: passwordValidator,
                    onSaved: passwordOnSaved,
                  ),
                  FormTextField(
                    icon: Icons.lock_outline,
                    hint: 'Confirm Password',
                    pass: true,
                    validator: passwordConfirmValidator,
                    onSaved: passwordConfirmOnSaved,
                  ),
                  FormButton(
                    btnText: 'Update Account',
                    pressed: () => formSaved(register),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  LabelButton(
                    boldText: 'Back',
                    pressed: () => navigateToDashboardPage(),
                  ),
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

  passwordValidator(var input) => input.length < 7 ? "Password must have more than 7 characters" : null;
  passwordOnSaved(var input) => register.password = input;

  passwordConfirmValidator(var input) => input.length < 7 ? "Password must have more than 7 characters" : null;
  passwordConfirmOnSaved(var input) => register.confirmedPassword = input;

  formSaved(RegisterModel model) {
    final form = _formUpdate.currentState;
    if (form.validate()) {
      form.save();
      LoginApi.updateProfile(model).then((value) async {
        if (value['message'] == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${value.values.first}'),
            ),
          );
          return;
        }
        await SharedService.setProfileDetails(RegisterModel.fromJson(value['profile']));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile Updated Successfully'),
          ),
        );
        navigateToDashboardPage();
      });
    } else {}
  }

  navigateToDashboardPage() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => DashboardPage()),
      (Route<dynamic> route) => false,
    );
  }
}
