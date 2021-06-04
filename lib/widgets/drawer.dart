import 'package:bmis_passenger/models/profile_model.dart';
import 'package:bmis_passenger/screens/edit_profile_page.dart';
import 'package:bmis_passenger/screens/my_bookings_page.dart';
import 'package:bmis_passenger/utils/shared_preferences.dart';
import 'package:bmis_passenger/widgets/logout_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDrawer {
  Widget drawer(BuildContext context) => Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue[900],
              ),
              child: FutureBuilder<RegisterModel>(
                future: SharedService.getProfileDetails(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircularProgressIndicator(),
                        ],
                      );
                    case ConnectionState.active:
                    case ConnectionState.done:
                      if (snapshot.hasData) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '${snapshot.data.lastName}, ${snapshot.data.firstName}',
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24.0),
                            ),
                            Text(
                              '${snapshot.data.address}',
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 18.0),
                            ),
                            Text(
                              '${snapshot.data.email}',
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 18.0),
                            ),
                            Text(
                              '${snapshot.data.contact}',
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 18.0),
                            ),
                          ],
                        );
                      } else {
                        return Text('No Data');
                      }
                      break;
                    default:
                      return Text('Error');
                  }
                },
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.list,
              ),
              title: Text('My Bookings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyBookingsPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.perm_identity,
              ),
              title: Text('Edit Profile'),
              onTap: () => navigateToEditProfile(context),
            ),
            ListTile(
              leading: Icon(
                Icons.logout,
              ),
              title: Text('Logout'),
              onTap: () async {
                showDialog(
                    context: context, builder: (context) => LogoutDialog());
              },
            )
          ],
        ),
      );

  navigateToEditProfile(BuildContext context) async {
    RegisterModel profile = await SharedService.getProfileDetails();

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditProfilePage(profile)),
    );
  }
}
