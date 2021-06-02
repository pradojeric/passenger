class BookingModel {
  String companyName;
  int rideId;
  double points;
  String bookingCode;
  String bus;
  String busNo;
  String busPlate;
  String routeName;
  String startTerminal;
  String endTerminal;
  double distance;
  String trip;
  String time;
  String rideDate;
  int pax;
  double fare;
  String status;
  bool aboard;

  BookingModel({
    this.companyName,
    this.rideId,
    this.points,
    this.bookingCode,
    this.bus,
    this.busNo,
    this.busPlate,
    this.routeName,
    this.startTerminal,
    this.endTerminal,
    this.distance,
    this.time,
    this.trip,
    this.rideDate,
    this.pax,
    this.fare,
    this.status,
    this.aboard,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      companyName: json['company_name'],
      rideId: json['ride_id'],
      points: json['points'].toDouble(),
      bookingCode: json['booking_code'].toString(),
      bus: json['bus'],
      busNo: json['bus_no'],
      busPlate: json['bus_plate'],
      routeName: json['route_name'],
      distance: json['distance'].toDouble(),
      startTerminal: json['start_terminal'],
      endTerminal: json['end_terminal'],
      trip: json['trip'],
      time: json['time'],
      rideDate: json['ride_date'],
      pax: json['pax'],
      fare: json['fare'].toDouble(),
      status: json['status'],
      aboard: json['aboard'] == 1 ? true : false,
    );
  }
}
