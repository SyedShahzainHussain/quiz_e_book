import 'package:flutter/cupertino.dart';
import 'package:quiz_e_book/model/login_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthViewModel with ChangeNotifier {
  LoginData? _loginData;

  LoginData? get loginData => _loginData;

  Future<void> fetchLoginData() async {
    _loginData = await getUser();
    notifyListeners();
  }

  

  Future<bool> saveUser(LoginData loginData) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString("token", loginData.token.toString());
    sp.setString("username", loginData.username.toString());
    sp.setString("profileImage", loginData.profilePhoto.toString());
    sp.setString("email", loginData.email.toString());
    sp.setString("uuid", loginData.sId.toString());
    sp.setString("dob", loginData.dob.toString());
    sp.setString("role", loginData.role.toString());
    notifyListeners();
    return true;
  }

  Future<LoginData> getUser() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    final String? token = sp.getString("token");
    final String? username = sp.getString("username");
    final String? profileImage = sp.getString("profileImage");
    final String? email = sp.getString("email");
    final String? uuid = sp.getString("uuid");
    final String? dob = sp.getString("dob");
    final String? role = sp.getString("role");
    return LoginData(
      token: token,
      username: username,
      email: email,
      sId: uuid,
      profilePhoto: profileImage,
      dob: dob,
      role: role,
    );
  }

 

  Future<bool> remove() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.remove("token");
    sp.remove("username");
    sp.remove("profileImage");
    sp.remove("email");
    sp.remove("uuid");
    sp.remove("dob");
    sp.remove("role");
    return true;
  }


}
