import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_e_book/data/network/base_api_services.dart';
import 'package:quiz_e_book/data/network/network_api_services.dart';
import 'package:quiz_e_book/model/login_model.dart';
import 'package:quiz_e_book/resources/routes/route_name/route_name.dart';
import 'package:quiz_e_book/resources/urls/app_url.dart';
import 'package:quiz_e_book/utils/utils.dart';
import 'package:quiz_e_book/viewModel/auth_view_model/auth_view_model.dart';

class LoginViewModel with ChangeNotifier {
  final BaseApiServices baseApiServices = NetworkApiServices();
  final AuthViewModel authViewModel = AuthViewModel();
  bool _isloading = false;
  bool get isLoading => _isloading;
  setLoading(bool loading) {
    _isloading = loading;
    notifyListeners();
  }

  Future<void> loginApi(dynamic body, BuildContext context) async {
    setLoading(true);
    baseApiServices
        .getPostApiResponse(
      AppUrl.login,
      body,
    )
        .then((value) {
      setLoading(false);
      final String? token = value['token'];
      final String? id = value["_id"];
      final String? username = value["username"];
      final String? email = value["email"];
      final String? dob = value["dob"];
      final String? profilePhoto = value['profilePhoto'];
      final loginData = LoginData(
        token: token,
        email: email,
        dob: dob,
        profilePhoto: profilePhoto,
        sId: id,
        username: username,
      );
      authViewModel.saveUser(loginData);
      Navigator.pushNamedAndRemoveUntil(
          context, RouteName.homeScreen, (route) => false);
      Utils.flushBarErrorMessage(
        "User Login",
        context,
      );
      if (kDebugMode) {
        print(value.toString());
      }
    }).onError((error, stackTrace) {
      setLoading(false);
      Utils.flushBarErrorMessage(error.toString(), context);
      if (kDebugMode) {
        print(error.toString());
      }
    });
  }
}
