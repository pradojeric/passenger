import 'package:bmis_passenger/api/booking_api.dart';
import 'package:bmis_passenger/models/booking_model.dart';
import 'package:bmis_passenger/models/profile_model.dart';
import 'package:bmis_passenger/widgets/drawer.dart';
import 'package:bmis_passenger/widgets/label_button.dart';
import 'package:intl/intl.dart';
import '../screens/dashboard/qr_part.dart';
import '../utils/shared_preferences.dart';
import '../screens/book_tacking_page.dart';
import '../screens/booking_page.dart';
import '../widgets/appbar.dart';
import '../widgets/form_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'bus_points_page.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Future<BookingModel> book;
  // Future points;
  String button = "Book Now";
  bool _isButtonDisabled = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    book = BookingApi.getBook();
    // points = BookingApi.getPoints();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer().drawer(context),
      backgroundColor: Colors.white,
      appBar: CustomAppBar('Dashboard'),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Today: ${DateFormat('EEEE, MMMM d, y').format(DateTime.now())}',
              style: TextStyle(
                fontSize: 10,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: new BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[100],
              ),
              child: Column(
                children: [
                  FutureBuilder<RegisterModel>(
                    future: SharedService.getProfileDetails(),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return CircularProgressIndicator();
                        case ConnectionState.active:
                        case ConnectionState.done:
                          print(snapshot);
                          if (snapshot.hasData) {
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    Text('Welcome!'),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '${snapshot.data.firstName} ${snapshot.data.lastName}!',
                                      style: GoogleFonts.poppins(
                                          color: Colors.blue[900],
                                          fontWeight: FontWeight.normal,
                                          fontSize: 18.0),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          }
                          return Text('Error');
                        default:
                          return Text(snapshot.error);
                          break;
                      }
                    },
                  ),
                  LabelButton(
                    liteText: 'See all my bus points >',
                    pressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BusPointsPage()));
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.all(20.0),
              width: double.infinity,
              constraints: BoxConstraints(
                minHeight: 200.0,
              ),
              decoration: new BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[100],
              ),
              child: QrPart(book),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: Column(
                children: [
                  Column(
                    children: [
                      Column(children: [
                        FormButton(
                          btnText: button,
                          pressed: () => navigateToBookingPage(),
                        ),
                      ]),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  navigateToBookingPage() async {
    if (_isButtonDisabled) return;

    setState(() {
      button = "Loading";
      _isButtonDisabled = true;
    });

    BookingApi.getTerminals().then(
      (value) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => BookingPage(terminals: value)),
        );

        setState(() {
          button = "Book Now";
          _isButtonDisabled = false;
        });
      },
      onError: (e) {
        throw e;
      },
    );
  }

  navigateToBookTrackingPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BookTrackingPage()),
    );
  }
}
