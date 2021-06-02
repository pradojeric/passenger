import 'package:bmis_passenger/utils/shared_preferences.dart';

import '../widgets/form_button.dart';
import 'package:flutter/material.dart';
import 'dashboard_page.dart';
import 'login_page.dart';
import 'register_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 120.0,
              child: Image.asset(
                "assets/logo.png",
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(
              height: 150,
            ),
            Container(
                child: Column(children: [
              FormButton(
                btnText: 'Sign In',
                pressed: () => navigateToLoginPage(),
              ),
              SizedBox(
                height: 10,
              ),
              FormButton(
                btnText: 'Sign Up',
                pressed: () => navigateToRegisterPage(),
              ),
            ])),
          ],
        ),
      ),
    );
  }

  navigateToLoginPage() async {
    if (await SharedService.getToken() != null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => DashboardPage()),
        (Route<dynamic> route) => false,
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
        (Route<dynamic> route) => false,
      );
    }
  }

  navigateToRegisterPage() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => RegisterPage()),
      (Route<dynamic> route) => false,
    );
  }
}
