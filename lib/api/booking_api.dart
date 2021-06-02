import 'package:bmis_passenger/api/api.dart';
import 'package:bmis_passenger/models/booking_model.dart';
import 'package:bmis_passenger/models/ride_model.dart';
import 'package:bmis_passenger/models/terminal_model.dart';
import 'package:bmis_passenger/utils/shared_preferences.dart';
import '../utils/constants.dart';

class BookingApi {
  static Future<List<RideModel>> getRides(SearchRide searchRide) async {
    String startTerminal = 'start=${searchRide.startTerminal}';
    String endTerminal = 'end=${searchRide.endTerminal}';
    String date = 'travel_date=${searchRide.dateTime}';
    String token = await SharedService.getToken();
    String url =
        '$API_URL/api/passenger/search-rides?$startTerminal&$endTerminal&$date';
    final response = await ApiService.getResponseList(uri: url, token: token);

    List<RideModel> rides = [];
    for (int i = 0; i < response.length; i++) {
      RideModel r = RideModel.fromJson(response[i]);
      rides.add(r);
    }
    await SharedService.setSearchRide(searchRide);
    return rides;
  }

  static Future<List<TerminalModel>> getTerminals() async {
    String url = '$API_URL/api/passenger/get-terminals';
    String token = await SharedService.getToken();
    final response = await ApiService.getResponseList(uri: url, token: token);
    List<TerminalModel> terminals = [];
    for (int i = 0; i < response.length; i++) {
      TerminalModel t = TerminalModel.fromJson(response[i]);
      terminals.add(t);
    }
    return terminals;
  }

  static Future<RideModel> getRide(SearchRide searchRide, int rideId) async {
    String token = await SharedService.getToken();
    String startTerminal = 'start=${searchRide.startTerminal}';
    String endTerminal = 'end=${searchRide.endTerminal}';
    String date = 'travel_date=${searchRide.dateTime}';
    String ride = 'ride_id=$rideId';
    String url =
        '$API_URL/api/passenger/book?$startTerminal&$endTerminal$date&$ride';
    final response = await ApiService.getResponse(uri: url, token: token);
    return RideModel.fromJson(response);
  }

  static Future<double> getFare(RideModel ride, int pax) async {
    String token = await SharedService.getToken();
    String noOfPax = 'pax=${pax.toString()}';
    String totalKm = 'total_km=${ride.totalKm.toString()}';
    String rideId = 'ride_id=${ride.rideId}';
    String url =
        '$API_URL/api/passenger/compute-fare?$noOfPax&$totalKm&$rideId';
    final response = await ApiService.getResponse(uri: url, token: token);
    return response.toDouble();
  }

  static Future bookRide(RideModel ride, int pax, String by) async {
    String token = await SharedService.getToken();
    String url;
    if (by == 'cash') {
      url = '$API_URL/api/passenger/book-by-cash';
    } else {
      url = '$API_URL/api/passenger/book-by-points';
    }

    SearchRide search = await SharedService.getSearchRide();

    Map<String, dynamic> body = {
      'ride_id': ride.rideId,
      'start_terminal_id': search.startTerminal,
      'end_terminal_id': search.endTerminal,
      'travel_date': search.dateTime,
      'pax': pax,
    };

    final response = await ApiService.postRequest(
        uri: url, token: token, requestModel: body);
    return response;
  }

  static Future<List<BookingModel>> getBookings({String status}) async {
    String token = await SharedService.getToken();
    String url = '$API_URL/api/passenger/bookings/$status';

    final response = await ApiService.getResponseList(uri: url, token: token);
    List<BookingModel> bookings = [];
    for (int i = 0; i < response.length; i++) {
      BookingModel b = BookingModel.fromJson(response[i]);
      bookings.add(b);
    }

    return bookings;
  }

  static Future<BookingModel> getBook() async {
    String token = await SharedService.getToken();
    String url = '$API_URL/api/passenger/get-book';

    final response = await ApiService.getResponse(uri: url, token: token);
    return BookingModel.fromJson(response);
  }

  static Future getPoints() async {
    String token = await SharedService.getToken();
    String url = '$API_URL/api/passenger/retrieve-points';

    final response = await ApiService.getResponse(uri: url, token: token);
    return response;
  }

  static Future getPointsCompany(int rideId) async {
    String token = await SharedService.getToken();
    String url = '$API_URL/api/passenger/retrieve-points-company/$rideId';

    final response = await ApiService.getResponse(uri: url, token: token);
    return response;
  }

  static Future cancelBooking(String bookingCode) async {
    String token = await SharedService.getToken();
    String url = '$API_URL/api/passenger/cancel-booking/$bookingCode';

    final response = await ApiService.getResponse(uri: url, token: token);
    return response;
  }
}
