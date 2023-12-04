
import 'package:flutter/foundation.dart';
import 'package:quiz_e_book/data/response/api_response.dart';
import 'package:quiz_e_book/model/users.dart';
import 'package:quiz_e_book/repositories/get_user_data/get_user_data.dart';

class GetAllUsers with ChangeNotifier {
  UserData userData = UserData();
  ApiResponse<List<Users>> apiresponse = ApiResponse.loading();

  setUserList(ApiResponse<List<Users>> response) {
    apiresponse = response;
    notifyListeners();
  }

  Future<void> getUserData(String token) async {
    setUserList(ApiResponse.loading());
    userData.getUserData({"Authorization": "Bearer $token"}).then((value) {
      if (kDebugMode) {
        print(value);
      }
      setUserList(ApiResponse.complete(value));
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error.toString());
      }
      setUserList(ApiResponse.error(error.toString()));
    });
  }
}
