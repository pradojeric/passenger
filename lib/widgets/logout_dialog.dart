import 'package:bmis_passenger/screens/home_page.dart';
import 'package:flutter/material.dart';
import '../utils/shared_preferences.dart';

class LogoutDialog extends StatefulWidget {
  LogoutDialog({this.callback});
  final Function(bool) callback;

  @override
  _LogoutDialogState createState() => _LogoutDialogState();
}

class _LogoutDialogState extends State<LogoutDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Logout'),
      content: Text('Do you want to logout?'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            setState(() {
              SharedService.logout().then((_) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                  (Route<dynamic> route) => false,
                );
              });
            });
          },
          child: Text('Yes'),
        ),
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('No'))
      ],
    );
  }
}
