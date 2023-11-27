import 'package:quiz_e_book/data/network/base_api_services.dart';
import 'package:quiz_e_book/data/network/network_api_services.dart';
import 'package:quiz_e_book/model/users.dart';
import 'package:quiz_e_book/resources/urls/app_url.dart';

class UserData {
  BaseApiServices baseApiServices = NetworkApiServices();

  Future<List<Users>> getUserData(Map<String, String> headers) async {
    dynamic response = await baseApiServices.getGetApiResponse(
      AppUrl.getAllUsers,
      headers: headers,
    );

    var data = response as List;
    return data.map((dynamic json) {
      return Users.fromJson(json);
    }).toList();
  }
}
