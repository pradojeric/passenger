import '../widgets/appbar.dart';
import 'package:flutter/material.dart';

class BookTrackingPage extends StatefulWidget {
  BookTrackingPage({Key key}) : super(key: key);

  @override
  _BookTrackingPageState createState() => _BookTrackingPageState();
}

class _BookTrackingPageState extends State<BookTrackingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('Tracking'),
      backgroundColor: Colors.white,
      body: Column(
        children: [],
      ),
    );
  }
}
