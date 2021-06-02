import 'package:bmis_passenger/api/api.dart';
import 'package:bmis_passenger/models/login_model.dart';
import 'package:bmis_passenger/models/profile_model.dart';
import 'package:bmis_passenger/utils/shared_preferences.dart';
import '../utils/constants.dart';

class LoginApi {
  static Future<Map<String, dynamic>> login(LoginModel loginModel) async {
    var url = '$API_URL/api/login';
    final response = await ApiService.postRequest(
      uri: url,
      requestModel: loginModel.toJson(),
    );
    return response;
  }

  static Future<Map<String, dynamic>> updateProfile(RegisterModel registerModel) async {
    var url = '$API_URL/api/passenger/update';
    String token = await SharedService.getToken();
    final response = await ApiService.postRequest(
      uri: url,
      token: token,
      requestModel: registerModel.toJson(),
    );
    return response;
  }

  static Future<Map<String, dynamic>> register(RegisterModel registerModel) async {
    var url = '$API_URL/api/register';

    final response = await ApiService.postRequest(
      uri: url,
      requestModel: registerModel.toJson(),
    );
    return response;
  }

  static Future retrievePoint() async {
    var url = '$API_URL/api/passenger/retrieve-points';
    String token = await SharedService.getToken();
    final response = await ApiService.getResponse(uri: url, token: token);
    return response;
  }
}
