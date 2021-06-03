import 'package:bmis_passenger/api/booking_api.dart';
import 'package:bmis_passenger/models/booking_model.dart';
import 'package:bmis_passenger/models/ride_model.dart';

import '../widgets/appbar.dart';
import '../widgets/form_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'dashboard_page.dart';

class BookingFormFinalizationPage extends StatefulWidget {
  final RideModel ride;
  final int pax;
  final double fare;

  BookingFormFinalizationPage(this.ride, this.pax, this.fare);

  @override
  _BookingFormFinalizationPageState createState() =>
      _BookingFormFinalizationPageState();
}

class _BookingFormFinalizationPageState
    extends State<BookingFormFinalizationPage> {
  bool isDisabled = false;
  bool bookByPoints = false;
  Color colour = Colors.blue[900];
  double points = 0.00;
  String message = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPoints();
  }

  void getPoints() async {
    BookingApi.getPointsCompany(widget.ride.rideId).then((value) {
      setState(() {
        print(value);
        points = value.toDouble();
        if (checkIfPointsIsAvailable(widget.fare, points)) {
          bookByPoints = true;
        } else {
          print("shit12");
          message = 'Not enough points';
          colour = Colors.red[900];
        }
      });
    });
  }

  bool checkIfPointsIsAvailable(var fare, var points) {
    if (points > fare) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('Finalization'),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(20.0),
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
                  Row(
                    children: <Widget>[
                      Text('No of Pax: ',
                          style: GoogleFonts.poppins(
                              color: Colors.blue[900],
                              fontWeight: FontWeight.bold)),
                      Text('${widget.pax}'),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text('Amount: ',
                          style: GoogleFonts.poppins(
                              color: Colors.blue[900],
                              fontWeight: FontWeight.bold)),
                      Text('P ${widget.fare}'),
                    ],
                  ),
                  Row(
                    children: [
                      Row(
                        children: [
                          Text('Points Remaining: $points',
                              style: GoogleFonts.poppins(
                                  color: Colors.blue[900],
                                  fontWeight: FontWeight.bold)),
                          Text(' $message'),
                        ],
                      ),
                    ],
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
                  Row(
                    children: [
                      Text('Your reservation is almost done.'
                          '\n Payment is required to finalize your booking.'
                          '\n Choose your payment method to proceed to your payment.')
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
                  Row(
                    children: [
                      Expanded(
                        child: FormButton(
                          colour: bookByPoints ? Colors.blue[900] : Colors.grey,
                          btnText: 'Points',
                          pressed: () async {
                            if (bookByPoints) {
                              navigateToDashboard(widget.ride, 'points');
                            } else {
                              await showDialog(
                                context: context,
                                builder: (_) {
                                  return AlertDialog(
                                    title: Text('Bus Points'),
                                    content: Text(
                                        'You do not have enough points to book'),
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: FormButton(
                          btnText: 'Pay',
                          pressed: () =>
                              {navigateToDashboard(widget.ride, 'cash')},
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FormButton(
                    btnText: 'Back',
                    pressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  navigateToDashboard(RideModel ride, String by) async {
    if (isDisabled == true) return;

    setState(() {
      isDisabled = true;
    });

    final response = await BookingApi.bookRide(ride, widget.pax, by);
    if (response['error'] != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response['error']),
        ),
      );
    } else {
      BookingModel booking = BookingModel.fromJson(response);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Booked Successfully'),
        ),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DashboardPage()),
      );
    }
  }
}
