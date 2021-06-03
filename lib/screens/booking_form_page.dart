import 'package:bmis_passenger/api/booking_api.dart';
import 'package:bmis_passenger/models/ride_model.dart';
import 'package:flutter/services.dart';

import '../screens/booking_form_finalization_page.dart';
import '../widgets/appbar.dart';
import '../widgets/form_button.dart';
import '../widgets/form_text_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BookingFormPage extends StatefulWidget {
  BookingFormPage(this.ride);
  final RideModel ride;

  @override
  _BookingFormPageState createState() => _BookingFormPageState();
}

class _BookingFormPageState extends State<BookingFormPage> {
  GlobalKey<FormState> _form = GlobalKey<FormState>();
  int pax;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('Booking Form'),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _form,
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
                            '${widget.ride.companyName}',
                            style: GoogleFonts.poppins(
                                color: Colors.blue[900],
                                fontWeight: FontWeight.w900,
                                fontSize: 24.0),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text('Bus: ',
                              style: GoogleFonts.poppins(
                                  color: Colors.blue[900],
                                  fontWeight: FontWeight.bold)),
                          Text('${widget.ride.busName}'),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text('Bus No: ',
                              style: GoogleFonts.poppins(
                                  color: Colors.blue[900],
                                  fontWeight: FontWeight.bold)),
                          Text('${widget.ride.busNo}'),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text('Plate: ',
                              style: GoogleFonts.poppins(
                                  color: Colors.blue[900],
                                  fontWeight: FontWeight.bold)),
                          Text('${widget.ride.busPlate}'),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text('Trip: ',
                              style: GoogleFonts.poppins(
                                  color: Colors.blue[900],
                                  fontWeight: FontWeight.bold)),
                          Text('${widget.ride.routeName}'),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text('Start Terminal: ',
                              style: GoogleFonts.poppins(
                                  color: Colors.blue[900],
                                  fontWeight: FontWeight.bold)),
                          Text('${widget.ride.startTerminal}'),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text('Destination: ',
                              style: GoogleFonts.poppins(
                                  color: Colors.blue[900],
                                  fontWeight: FontWeight.bold)),
                          Text('${widget.ride.endTerminal}'),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text('Distance: ',
                              style: GoogleFonts.poppins(
                                  color: Colors.blue[900],
                                  fontWeight: FontWeight.bold)),
                          Text('${widget.ride.totalKm} km'),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text('Departure Time: ',
                              style: GoogleFonts.poppins(
                                  color: Colors.blue[900],
                                  fontWeight: FontWeight.bold)),
                          Text('${widget.ride.scheduledTime}'),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text('Booked: ',
                              style: GoogleFonts.poppins(
                                  color: Colors.blue[900],
                                  fontWeight: FontWeight.bold)),
                          Text(
                              '${widget.ride.occupiedSeat}/${widget.ride.busSeat}'),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: Column(
                    children: [
                      FormTextField(
                        autofocus: true,
                        initialValue: "0",
                        formatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        icon: Icons.person_outline,
                        hint: 'No of Pax',
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          pax = int.parse(value);
                          int available =
                              widget.ride.busSeat - widget.ride.occupiedSeat;
                          if (pax < 1) return 'You must enter greater than 0';
                          if (pax > available) return "No seats available!";
                        },
                        onSaved: (value) => pax = int.parse(value),
                      ),
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
                        btnText: 'Proceed',
                        pressed: () => navigateToBookingFormFinalizationPage(),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      FormButton(
                        btnText: 'Cancel',
                        pressed: () => navigateToBookingResultPage(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  navigateToBookingResultPage() {
    Navigator.pop(
      context,
    );
  }

  navigateToBookingFormFinalizationPage() async {
    final form = _form.currentState;
    if (form.validate()) {
      form.save();

      double fare = await BookingApi.getFare(widget.ride, pax);

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                BookingFormFinalizationPage(widget.ride, pax, fare)),
      );
    }
  }
}
