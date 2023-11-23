import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quiz_e_book/repositories/registered_repo.dart/registered_repo.dart';
import 'package:quiz_e_book/resources/color/app_color.dart';
import 'package:quiz_e_book/resources/routes/route_name/route_name.dart';
import 'package:quiz_e_book/resources/urls/app_url.dart';
// ignore: depend_on_referenced_packages, implementation_imports
import 'package:http_parser/src/media_type.dart' show MediaType;
import 'package:http/http.dart';
import 'package:quiz_e_book/utils/utils.dart';

class RegisteredViewModel with ChangeNotifier {
  final RegisteredRepo registeredRepo = RegisteredRepo();

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  setLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  void registerApi(
    String username,
    email,
    password,
    dateofbirth,
    File? image,
    context,
  ) async {
    setLoading(true);
    final request =
        MultipartRequest("POST", Uri.parse('${AppUrl.baseUrl}/register'));
    request.fields['username'] = username.toString();
    request.fields['email'] = email.toString();
    request.fields['password'] = password.toString();
    request.fields['dob'] = dateofbirth.toString();
    var file = await MultipartFile.fromPath("image", image!.path,
        filename: "profile_photo.jpg", contentType: MediaType("image", "jpg"));
    request.files.add(file);
    try {
      var response = await request.send();
      if (response.statusCode == 201) {
        setLoading(false);
        final responseJson = response.stream.bytesToString();

        username = '';
        email = '';
        password = '';
        dateofbirth = '';
        image = null;
        Navigator.pushNamedAndRemoveUntil(
          context,
          RouteName.loginScreen,
          (route) => false,
        );
        Utils.flushBarErrorMessage(
          "Registerd SuccessFully",
          context,
        );
        if (kDebugMode) {
          print(responseJson);
        }
      } else if (response.statusCode == 400) {
        // Handle specific error case, e.g., email already exists
        final errorResponse = await response.stream.bytesToString();
        final errorJson = jsonDecode(errorResponse);
        final errorMessage =
            errorJson['error'] ?? 'An unexpected error occurred';
        Utils.flushBarErrorMessage(errorMessage, context);
        setLoading(false);
      } else {
        setLoading(false);
        Utils.flushBarErrorMessage(response.reasonPhrase.toString(), context);
      }
    } catch (e) {
      setLoading(false);
      Utils.flushBarErrorMessage('An unexpected error occurred', context);
    }
  }
}
