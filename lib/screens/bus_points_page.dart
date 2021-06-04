import 'package:bmis_passenger/api/booking_api.dart';
import 'package:bmis_passenger/widgets/appbar.dart';
import 'package:bmis_passenger/widgets/drawer.dart';
import 'package:flutter/material.dart';

class BusPointsPage extends StatefulWidget {
  @override
  _BusPointsPageState createState() => _BusPointsPageState();
}

class _BusPointsPageState extends State<BusPointsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar('My Bus Points'),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: FutureBuilder(
          future: BookingApi.getPoints(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return CircularProgressIndicator();
              case ConnectionState.active:
              case ConnectionState.done:
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (data, index) {
                      return Container(
                        margin: EdgeInsets.all(5.0),
                        decoration: new BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey[100],
                        ),
                        child: Column(
                          children: [
                            Text('Bus Points'),
                            Container(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                "${snapshot.data[index]['company_name']} : ${snapshot.data[index]['pivot']['points']} pts",
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  return Text('No Bus points');
                }
                break;
              default:
                return Text('No Bus points available');
                break;
            }
          },
        ),
      ),
    );
  }
}
