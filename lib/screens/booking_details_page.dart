import 'package:barcode_widget/barcode_widget.dart';
import 'package:bmis_passenger/models/booking_model.dart';
import 'package:bmis_passenger/models/ride_model.dart';
import 'package:bmis_passenger/utils/constants.dart';

import '../screens/my_bookings_page.dart';
import '../widgets/appbar.dart';
import '../widgets/form_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BookingDetailsPage extends StatefulWidget {
  BookingDetailsPage(this.booking);

  final BookingModel booking;

  @override
  _BookingDetailsPageState createState() => _BookingDetailsPageState();
}

class _BookingDetailsPageState extends State<BookingDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('Booking Details'),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(20.0),
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[200],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          '${widget.booking.companyName}',
                          style: GoogleFonts.poppins(color: Colors.blue[900], fontWeight: FontWeight.w900, fontSize: 24.0),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'Ticket #: ',
                          style: GoogleFonts.poppins(color: Colors.blue[900], fontWeight: FontWeight.w900, fontSize: 16.0),
                        ),
                        Text('${widget.booking.bookingCode}'),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text('Bus: ', style: GoogleFonts.poppins(color: Colors.blue[900], fontWeight: FontWeight.bold)),
                        Text('${widget.booking.bus}'),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text('Bus No: ', style: GoogleFonts.poppins(color: Colors.blue[900], fontWeight: FontWeight.bold)),
                        Text('${widget.booking.busNo}'),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text('Plate: ', style: GoogleFonts.poppins(color: Colors.blue[900], fontWeight: FontWeight.bold)),
                        Text('${widget.booking.busPlate}'),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text('Trip: ', style: GoogleFonts.poppins(color: Colors.blue[900], fontWeight: FontWeight.bold)),
                        Text('${widget.booking.routeName}'),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text('Distance: ', style: GoogleFonts.poppins(color: Colors.blue[900], fontWeight: FontWeight.bold)),
                        Text('${widget.booking.distance} km'),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text('Departure Time: ', style: GoogleFonts.poppins(color: Colors.blue[900], fontWeight: FontWeight.bold)),
                        Text('${widget.booking.time}'),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text('Terminal: ', style: GoogleFonts.poppins(color: Colors.blue[900], fontWeight: FontWeight.bold)),
                        Text('${widget.booking.startTerminal}'),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text('No of Pax: ', style: GoogleFonts.poppins(color: Colors.blue[900], fontWeight: FontWeight.bold)),
                        Text('${widget.booking.pax}'),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text('Dest. Terminal: ', style: GoogleFonts.poppins(color: Colors.blue[900], fontWeight: FontWeight.bold)),
                        Text('${widget.booking.endTerminal}'),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text('Amount: ', style: GoogleFonts.poppins(color: Colors.blue[900], fontWeight: FontWeight.bold)),
                        Text('${widget.booking.fare.toStringAsFixed(2)}'),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text('Bus Points: ', style: GoogleFonts.poppins(color: Colors.blue[900], fontWeight: FontWeight.bold)),
                        Text('${widget.booking.points}'),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BarcodeWidget(
                          barcode: Barcode.qrCode(),
                          data: '${widget.booking.bookingCode}',
                          width: 150,
                          height: 150,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Text('QR code must be scanned by the'
                            '\n bus conductors as you board the bus.')
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Column(
                  children: [
                    FormButton(
                      btnText: 'Done',
                      pressed: () => navigateToMyBookingsPage(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  navigateToMyBookingsPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyBookingsPage()),
    );
  }
}
