import 'package:bmis_passenger/models/booking_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../booking_details_page.dart';

class BookingContainer extends StatefulWidget {
  BookingContainer(this.book, this.cancelBooking);
  final BookingModel book;
  final Function(BookingModel book) cancelBooking;
  @override
  _BookingContainerState createState() => _BookingContainerState();
}

class _BookingContainerState extends State<BookingContainer> {
  BookingModel book;

  bool compareDates(BookingModel booking) {
    String t = booking.rideDate.replaceAll('-', '');
    var r = t + " " + booking.time;
    var ride = DateTime.parse(r);
    var today = DateTime.now();

    return today.isAfter(ride);
  }

  Color containerColor(BookingModel booking) {
    if (booking.status == 'rejected') {
      return Colors.red[100];
    } else if (booking.status == 'cancelled by user') {
      return Colors.red[300];
    } else {
      if (compareDates(booking)) {
        return Colors.grey[500];
      } else {
        return Colors.grey[100];
      }
    }
  }

  Widget ticketButton(BookingModel book) {
    if (compareDates(book)) {
      if (book.status == 'confirmed' || book.status == 'done') {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookingDetailsPage(book),
              ),
            );
          },
          child: Text(
            '${book.bookingCode}',
            style: GoogleFonts.poppins(
              color: Colors.blue[900],
              decoration: TextDecoration.underline,
            ),
          ),
        );
      }
    }
    return Text('${book.bookingCode}');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    book = widget.book;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      margin: EdgeInsets.symmetric(vertical: 5.0),
      decoration: new BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: containerColor(book)),
      child: Column(
        children: <Widget>[
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: <Widget>[
                      Text('Ticket #: ',
                          style: GoogleFonts.poppins(
                            color: Colors.blue[900],
                            fontWeight: FontWeight.bold,
                          )),
                      ticketButton(book),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text('${book.rideDate}',
                          style: GoogleFonts.poppins(
                            color: Colors.blue[900],
                            fontWeight: FontWeight.bold,
                          )),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text('Bus: ',
                          style: GoogleFonts.poppins(
                            color: Colors.blue[900],
                            fontWeight: FontWeight.bold,
                          )),
                      Text('${book.bus}'),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text('Trip: ',
                          style: GoogleFonts.poppins(
                            color: Colors.blue[900],
                            fontWeight: FontWeight.bold,
                          )),
                      Text('${book.trip}'),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text('Departure Time: ',
                          style: GoogleFonts.poppins(
                            color: Colors.blue[900],
                            fontWeight: FontWeight.bold,
                          )),
                      Text('${book.time}'),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: <Widget>[
                      Text('Price: ',
                          style: GoogleFonts.poppins(
                            color: Colors.blue[900],
                            fontWeight: FontWeight.bold,
                          )),
                      Text('P ${book.fare.toStringAsFixed(2)}'),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text('Pax: ',
                          style: GoogleFonts.poppins(
                            color: Colors.blue[900],
                            fontWeight: FontWeight.bold,
                          )),
                      Text('${book.pax}'),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text('Points: ',
                          style: GoogleFonts.poppins(
                            color: Colors.blue[900],
                            fontWeight: FontWeight.bold,
                          )),
                      Text('${book.points}'),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text('Status: ',
                          style: GoogleFonts.poppins(
                            color: Colors.blue[900],
                            fontWeight: FontWeight.bold,
                          )),
                      Text(
                        '${book.status}',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
          book.status == 'confirmed' && !compareDates(book)
              ? ElevatedButton(
                  onPressed: () async {
                    await showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (_) {
                        return AlertDialog(
                          title: Text('Cancel Booking'),
                          content: Text(
                              'If you cancel your booking, your cash will not return but it will be added to your points. Proceed?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                widget.cancelBooking(book);
                                Navigator.pop(context);
                              },
                              child: Text('Yes'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('No'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text('Cancel'),
                )
              : Text(''),
        ],
      ),
    );
  }
}
