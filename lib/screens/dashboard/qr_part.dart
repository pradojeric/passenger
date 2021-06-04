import 'dart:core';
import 'package:bmis_passenger/screens/map_page.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:bmis_passenger/models/booking_model.dart';
import 'package:bmis_passenger/screens/booking_details_page.dart';
import 'package:bmis_passenger/widgets/label_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class QrPart extends StatefulWidget {
  QrPart(this.book);

  final Future<BookingModel> book;

  @override
  _QrPartState createState() => _QrPartState();
}

class _QrPartState extends State<QrPart> {
  bool _isButtonDisabled = false;
  Future<BookingModel> book;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    book = widget.book;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FutureBuilder<BookingModel>(
              future: book,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Container(
                      child: CircularProgressIndicator(),
                    );
                  case ConnectionState.active:
                  case ConnectionState.done:
                    if (snapshot.hasData && !snapshot.hasError) {
                      return populateQr(snapshot);
                    } else {
                      return Text('No ride today!');
                    }
                    break;
                  case ConnectionState.none:
                  default:
                    return Text('No internet connection!');
                }
              }),
        ],
      ),
    );
  }

  replaceDate({String text}) {
    String t = text.replaceAll('-', '');
    DateTime f = DateTime.parse(t);

    return DateFormat('EEEE, MMMM d, y').format(f);
  }

  Widget populateQr(AsyncSnapshot snapshot) {
    bool _trackable = false;
    bool aboard = snapshot.data.aboard;
    String t = snapshot.data.rideDate.replaceAll('-', '');
    var r = t + " " + snapshot.data.time;
    var ride = DateTime.parse(r);
    var today = DateTime.now();
    var tomorrow = DateTime(today.day, today.month, today.day + 1, 12);

    if (today.isAfter(ride) && tomorrow.isBefore(ride)) {
      _trackable = true;
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LabelButton(
              liteText: 'Ticket # ',
              liteFont: 18.0,
              boldText: '${snapshot.data.bookingCode}',
              boldFont: 18.0,
              pressed: () async {
                if (aboard) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingDetailsPage(snapshot.data),
                    ),
                  );
                } else {
                  await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Ticket'),
                          content: Text('You don\'t have ticket yet'),
                        );
                      });
                }
              },
            ),
          ],
        ),
        Text('Book date: ${replaceDate(text: snapshot.data.rideDate)}'),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            checkAboard(snapshot.data),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  primary: _trackable ? Colors.blue[900] : Colors.grey,
                ),
                onPressed: () {
                  if (!_trackable) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Track'),
                        content:
                            Text('Tracking is not available at the moment!'),
                      ),
                    );
                  } else {
                    navigateToMapsPage(snapshot.data);
                  }
                },
                child: Text(
                  "Track",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget checkAboard(BookingModel bookingModel) {
    if (bookingModel.aboard) {
      return Text('Ticket OK!');
    } else {
      return BarcodeWidget(
        barcode: Barcode.qrCode(),
        data: '${bookingModel.bookingCode}',
        width: 150,
        height: 150,
      );
    }
  }

  navigateToMapsPage(BookingModel bookingModel) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Map(
                bookingModel: bookingModel,
              )),
    );
  }
}

//  RaisedButton(
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10)),
//                 elevation: 0.0,
//                 child: Text(
//                   "Track",
//                   style: GoogleFonts.poppins(
//                     color: Colors.white,
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 onPressed: () {
//                   //navigateToMapsPage(snapshot.data);
//                   if (!_trackable) {
//                     showDialog(
//                       context: context,
//                       builder: (context) => AlertDialog(
//                         title: Text('Track'),
//                         content:
//                             Text('Tracking is not available at the moment!'),
//                       ),
//                     );
//                   } else {
//                     navigateToMapsPage(snapshot.data);
//                   }
//                 },
//                 color: _trackable ? Colors.blue[900] : Colors.grey,
//                 textColor: Colors.white,
//                 padding: EdgeInsets.all(8.0),
//                 splashColor: Colors.grey,
//               ),