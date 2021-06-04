import 'package:bmis_passenger/api/booking_api.dart';
import 'package:bmis_passenger/models/booking_model.dart';
import 'package:bmis_passenger/screens/bookings/my_bookings_container.dart';

import '../widgets/appbar.dart';
import 'package:flutter/material.dart';

class MyBookingsPage extends StatefulWidget {
  MyBookingsPage({Key key}) : super(key: key);

  @override
  _MyBookingsPageState createState() => _MyBookingsPageState();
}

class _MyBookingsPageState extends State<MyBookingsPage> {
  Future<List<BookingModel>> activeBookings;
  Future<List<BookingModel>> historyBookings;
  Future<List<BookingModel>> cancelledBookings;
  bool _isButtonDisabled = false;

  @override
  void initState() {
    activeBookings = BookingApi.getBookings(status: 'active');
    historyBookings = BookingApi.getBookings(status: 'inactive');
    cancelledBookings = BookingApi.getBookings(status: 'cancelled');
    super.initState();
  }

  TabBar tabBar() {
    return TabBar(
      tabs: <Widget>[
        Tab(
          child: Text(
            'ACTIVE',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        Tab(
          child: Text(
            'HISTORY',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        Tab(
          child: Text(
            'CANCELLED',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: CustomAppBar(
          'My Bookings',
          tabBar: tabBar(),
          size: 100.0,
        ),
        backgroundColor: Colors.white,
        body: TabBarView(
          children: <Widget>[
            listBookings(activeBookings),
            listBookings(historyBookings),
            listBookings(cancelledBookings),
          ],
        ),
      ),
    );
  }

  Widget listBookings(Future<List<BookingModel>> bookings) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: FutureBuilder(
          future: bookings,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case (ConnectionState.waiting):
                return Text('Loading');
              case (ConnectionState.active):
              case (ConnectionState.done):
                if (!snapshot.hasError) {
                  if (snapshot.hasData && snapshot.data.length > 0) {
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) =>
                          BookingContainer(snapshot.data[index], cancelBooking),
                    );
                  }
                }
                return Text('No Bookings Yet!');
              default:
                return Text('Error');
            }
          }),
    );
  }

  cancelBooking(BookingModel book) {
    if (_isButtonDisabled) {
      return;
    }
    _isButtonDisabled = true;
    BookingApi.cancelBooking(book.bookingCode).then((value) {
      if (value['error'] != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(value['error']),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(value['message']),
          ),
        );
        setState(() {
          activeBookings = BookingApi.getBookings(status: 'active');
        });
      }
      setState(() {
        _isButtonDisabled = false;
      });
    });
  }
}
