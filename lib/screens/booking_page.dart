import 'package:bmis_passenger/api/booking_api.dart';
import 'package:bmis_passenger/models/ride_model.dart';
import 'package:bmis_passenger/models/terminal_model.dart';
import 'package:date_field/date_field.dart';
import 'package:google_fonts/google_fonts.dart';
import '../screens/booking_result_page.dart';
import '../widgets/appbar.dart';
import '../widgets/form_button.dart';
import 'package:flutter/material.dart';

class BookingPage extends StatefulWidget {
  BookingPage({this.terminals});
  final List<TerminalModel> terminals;

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  SearchRide searchRide;
  Future<List<RideModel>> rides;
  TerminalModel startTerminal;
  TerminalModel endTerminal;
  String date;
  var today = DateTime.now().add(Duration(days: 1));
  bool _isButtonDisabled = false;

  @override
  void initState() {
    super.initState();
    date = today.toString();
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> _form = GlobalKey<FormState>();

    return Scaffold(
      appBar: CustomAppBar('Book'),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              constraints: BoxConstraints(
                minHeight: 200.0,
                minWidth: double.infinity,
              ),
              padding: EdgeInsets.all(20.0),
              decoration: new BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[200],
              ),
              child: Form(
                key: _form,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Start Terminal',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      child: DropdownButton(
                        isExpanded: true,
                        isDense: true,
                        value: startTerminal,
                        elevation: 16,
                        iconSize: 24,
                        onChanged: (val) {
                          setState(() {
                            startTerminal = val;
                          });
                        },
                        items: widget.terminals
                            .map(
                              (TerminalModel fc) =>
                                  DropdownMenuItem<TerminalModel>(
                                child: Text(fc.terminalName),
                                value: fc,
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Destination Terminal',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      child: DropdownButton(
                        value: endTerminal,
                        isExpanded: true,
                        isDense: true,
                        elevation: 16,
                        iconSize: 24,
                        onChanged: (val) {
                          setState(() {
                            endTerminal = val;
                          });
                        },
                        items: widget.terminals
                            .map(
                              (TerminalModel fc) =>
                                  DropdownMenuItem<TerminalModel>(
                                child: Text(fc.terminalName),
                                value: fc,
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    DateTimeFormField(
                      decoration: InputDecoration(
                        labelText: 'Travel Date: ',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      firstDate: today,
                      initialValue: DateTime.parse(date),
                      mode: DateTimeFieldPickerMode.date,
                      autovalidateMode: AutovalidateMode.always,
                      onDateSelected: (DateTime value) {
                        date = value.toString();
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              child: Column(
                children: [
                  Column(
                    children: [
                      Column(children: [
                        FormButton(
                          btnText: 'Search',
                          pressed: () => navigateToBookingResultPage(),
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

  navigateToBookingResultPage() async {
    if (_isButtonDisabled) return;

    _isButtonDisabled = true;

    if (startTerminal == null || endTerminal == null || date == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill up the form'),
        ),
      );
      _isButtonDisabled = false;
      return;
    }

    searchRide = SearchRide(
        startTerminal: startTerminal.terminalId,
        endTerminal: endTerminal.terminalId,
        dateTime: date);
    BookingApi.getRides(searchRide).then((rides) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BookingResultPage(rides)),
      );
      setState(() {
        _isButtonDisabled = false;
      });
    });
  }
}
