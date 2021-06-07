import 'dart:convert';
import 'package:bmis_passenger/models/profile_model.dart';
import 'package:bmis_passenger/models/terminal_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'constants.dart';
import '../models/login_model.dart';

class SharedService {
  // static Future<SharedPreferences> get _instance async => _prefsInstance ??= await SharedPreferences.getInstance();
  // static SharedPreferences _prefsInstance;

  // static Future<SharedPreferences> init() async {
  //   _prefsInstance = await _instance;
  //   return _prefsInstance;
  // }

  // static Future<bool> setString(String key, String value) async {
  //   var prefs = await _instance;
  //   return prefs?.setString(key, value) ?? Future.value(false);
  // }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token") != null ? true : false;
  }

  static Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString("token", token != null ? token : null);
  }

  static Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  static Future<void> setProfileDetails(RegisterModel model) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(
        "profileDetails", model != null ? jsonEncode(model.toJson()) : null);
  }

  static Future<RegisterModel> getProfileDetails() async {
    final prefs = await SharedPreferences.getInstance();
    return RegisterModel.fromJson(
        jsonDecode(prefs.getString('profileDetails')));
  }

  static Future<void> setEmail(LoginModel model) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(
        "email", model != null ? jsonEncode(model.toJson()) : null);
  }

  static Future getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return jsonDecode(prefs.getString('email'))['email'];
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    await http.post(Uri.parse('$API_URL/api/passenger/logout'), headers: {
      'Authorization': 'Bearer $token',
    });
    await prefs.clear();
  }

  static Future<void> setSearchRide(SearchRide ride) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        "searchRides", ride != null ? jsonEncode(ride.toJson()) : null);
  }

  static Future<SearchRide> getSearchRide() async {
    final prefs = await SharedPreferences.getInstance();
    return SearchRide.fromJson(jsonDecode(prefs.getString("searchRides")));
  }
}
