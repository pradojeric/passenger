import 'package:bmis_passenger/api/booking_api.dart';
import 'package:bmis_passenger/models/ride_model.dart';
import 'package:bmis_passenger/models/terminal_model.dart';
import 'package:bmis_passenger/utils/shared_preferences.dart';
import '../screens/booking_form_page.dart';
import '../widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BookingResultPage extends StatefulWidget {
  BookingResultPage(this.rides);
  final List<RideModel> rides;

  @override
  _BookingResultPageState createState() => _BookingResultPageState();
}

class _BookingResultPageState extends State<BookingResultPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('Result'),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            viewResults(widget.rides),
          ],
        ),
      ),
    );
  }

  Widget viewResults(List<RideModel> data) {
    if (data.isNotEmpty) {
      return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: data.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.all(5.0),
            decoration: new BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[100],
            ),
            child: Container(
              padding: EdgeInsets.all(10.0),
              child: _buildColumn(
                data[index],
              ),
            ),
          );
        },
      );
    }
    return Text('No Rides Available');
  }

  Widget _buildColumn(RideModel data) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              '${data.companyName}',
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
                    color: Colors.blue[900], fontWeight: FontWeight.bold)),
            Text('${data.busName}'),
          ],
        ),
        Row(
          children: <Widget>[
            Text('Trip: ',
                style: GoogleFonts.poppins(
                    color: Colors.blue[900], fontWeight: FontWeight.bold)),
            Text('${data.routeName}'),
          ],
        ),
        Row(
          children: <Widget>[
            Text('Departure Time: ',
                style: GoogleFonts.poppins(
                    color: Colors.blue[900], fontWeight: FontWeight.bold)),
            Text('${data.scheduledTime}'),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                primary: checkSeats(data) ? Colors.red : Colors.green,
              ),
              onPressed: () {
                navigateToBookingFormPage(data);
              },
              child: Text(
                "Book ${data.occupiedSeat} / ${data.busSeat}",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  bool checkSeats(RideModel data) {
    return data.occupiedSeat >= data.busSeat;
  }

  navigateToBookingFormPage(RideModel ride) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BookingFormPage(ride)),
    );
  }
}
