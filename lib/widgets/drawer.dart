import 'package:bmis_passenger/models/profile_model.dart';
import 'package:bmis_passenger/screens/edit_profile_page.dart';
import 'package:bmis_passenger/screens/my_bookings_page.dart';
import 'package:bmis_passenger/utils/shared_preferences.dart';
import 'package:bmis_passenger/widgets/logout_dialog.dart';
import 'package:flutter/material.dart';

class CustomDrawer {
  Widget drawer(BuildContext context) => Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Card(
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
                          return ListView(
                            children: <Widget>[
                              Text('${snapshot.data.lastName}, ${snapshot.data.firstName}'),
                              Text('${snapshot.data.address}'),
                              Text('${snapshot.data.email}'),
                              Text('${snapshot.data.contact}'),
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
                showDialog(context: context, builder: (context) => LogoutDialog());
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
