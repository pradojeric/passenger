class RideModel {
  int rideId;
  String routeName;
  String companyName;
  String busName;
  String busNo;
  String busPlate;
  double busRate;
  double totalKm;
  String scheduledTime;
  String startTerminal;
  String endTerminal;
  int busSeat;
  int occupiedSeat;

  String get getTime {
    var prefix = '0000-01-01T';
    var value = DateTime.parse(prefix + scheduledTime);
    return "${value.hour}:${value.minute}:${value.second}";
  }

  RideModel(
      {this.rideId,
      this.companyName,
      this.routeName,
      this.busName,
      this.busNo,
      this.busPlate,
      this.busRate,
      this.totalKm,
      this.scheduledTime,
      this.busSeat,
      this.occupiedSeat,
      this.startTerminal,
      this.endTerminal});

  factory RideModel.fromJson(Map<String, dynamic> json) {
    return RideModel(
      rideId: json['ride_id'],
      companyName: json['company_name'],
      routeName: json['route_name'],
      busName: json['bus_name'],
      scheduledTime: json['departure_time'],
      busSeat: json['bus_seat'],
      occupiedSeat: json['booked_seats'],
      startTerminal: json['start_terminal'],
      endTerminal: json['end_terminal'],
      busNo: json['bus_no'],
      busPlate: json['bus_plate'],
      busRate: json['bus_rate'].toDouble(),
      totalKm: json['total_km'].toDouble(),
    );
  }
}
