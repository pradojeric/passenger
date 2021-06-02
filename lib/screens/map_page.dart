import 'dart:async';
import 'package:bmis_passenger/models/booking_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Map extends StatefulWidget {
  Map({@required this.bookingModel});

  final BookingModel bookingModel;
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  var data;
  var lat, long;

  Completer<GoogleMapController> _controller = Completer();
  static const LatLng _center = const LatLng(16.050841249999998, 120.34084646235496);
  final databaseReference = FirebaseDatabase.instance.reference();

  final Set<Marker> _markers = {};
  // ignore: unused_field
  LatLng _lastMapPosition = _center;
  MapType _currentMapType = MapType.normal;
  // ignore: unused_field
  static final CameraPosition _position1 = CameraPosition(
    bearing: 192.833,
    target: LatLng(16.050841249999998, 120.34084646235496),
    zoom: 15.0,
  );
  // ignore: missing_return
  Future<Widget> _gotoPosition1() async {
    CameraPosition _po1 = CameraPosition(
      target: LatLng(double.parse(lat), double.parse(long)),
      zoom: 15.0,
    );
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_po1));
  }

  void initState() {
    super.initState();

    databaseReference.child('ride${widget.bookingModel.rideId}').once().then((DataSnapshot snapshot) {
      long = snapshot.value['long'];
      lat = snapshot.value['lat'];
      LatLng position = LatLng(double.parse(lat), double.parse(long));
      _onAddMarkerButton(position);
      data = snapshot.value;
    });
    databaseReference.child('ride${widget.bookingModel.rideId}').onChildAdded.listen(_onEntryAdded);
    databaseReference.child('ride${widget.bookingModel.rideId}').onChildChanged.listen(_onEntryAdded);

  }

  _onEntryAdded(Event event) {
    if (!mounted) return;

    if (event.snapshot.key == "lat") {
      setState(() {
        lat = event.snapshot.value;
        LatLng position = LatLng(
          double.parse(lat),
          double.parse(long),
        );
        _onAddMarkerButton(position);
      });
    }
    if (event.snapshot.key == "long") {
      setState(() {
        long = event.snapshot.value;
        LatLng position = LatLng(
          double.parse(lat),
          double.parse(long),
        );
        _onAddMarkerButton(position);
      });
    }
  }

  _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  _onMapTypePressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal ? MapType.hybrid : MapType.normal;
    });
  }

  // ignore: non_constant_identifier_names
  _ChangePos(position) async {
    final GoogleMapController controller = await _controller.future;
    CameraPosition _position1 = CameraPosition(
      bearing: 192.833,
      target: position,
      zoom: 15.0,
    );
    controller.animateCamera(CameraUpdate.newCameraPosition(_position1));
  }

  _onAddMarkerButton(position) {
    setState(() {
      _markers.add(Marker(
        markerId: MarkerId("${widget.bookingModel.routeName}"),
        position: position,
        infoWindow: InfoWindow(
          title: 'Driver',
          snippet: 'Current Location',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ));
    });
    _ChangePos(position);
  }

  // ignore: non_constant_identifier_names
  Process() {
    LatLng position = LatLng(26.676913, 64.440629);
    _onAddMarkerButton(position);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(target: _center, zoom: 15.0),
            mapType: _currentMapType,
            markers: _markers,
            onCameraMove: _onCameraMove,
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.topRight,
              child: Column(
                children: <Widget>[
                  button(_onMapTypePressed, Icons.map, 'Type'),
                  SizedBox(
                    height: 16.0,
                  ),
                  button(_gotoPosition1, Icons.location_searching, 'Position')
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget button(Function function, IconData icon, String a) {
    return FloatingActionButton(
      heroTag: a,
      onPressed: function,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      backgroundColor: Colors.blue[900],
      child: Icon(
        icon,
        size: 20,
      ),
    );
  }
}
