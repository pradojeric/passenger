import 'package:bmis_passenger/widgets/logout_button.dart';

import '../screens/dashboard_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;
  final String title;
  final TabBar tabBar;
  final double size;

  CustomAppBar(
    this.title, {
    Key key,
    this.tabBar,
    this.size = 56.0,
  })  : preferredSize = Size.fromHeight(size),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: <Widget>[
        IconButton(
          color: Colors.white,
          icon: Icon(Icons.home_rounded),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => DashboardPage()),
              (Route<dynamic> route) => false,
            );
          },
        ),
      ],
      elevation: 0.0,
      backgroundColor: Colors.blue[900],
      automaticallyImplyLeading: true,
      bottom: tabBar,
    );
  }
}
