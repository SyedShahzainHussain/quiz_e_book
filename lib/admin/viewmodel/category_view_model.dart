import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart';
import 'package:quiz_e_book/resources/urls/app_url.dart';
import 'package:http_parser/src/media_type.dart' show MediaType;
import 'package:quiz_e_book/utils/utils.dart';

import '../../resources/routes/route_name/route_name.dart';

class CategoryViewModel with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<void> uploadCategory(
    File? image,
    BuildContext context,
    String title,
    String token,
  ) async {
    setLoading(true);
    final request = MultipartRequest("POST", Uri.parse(AppUrl.createCategory));
    request.fields["title"] = title;
    request.headers['Authorization'] = 'Bearer $token';
    var file = await MultipartFile.fromPath(
      "image",
      image!.path,
      filename: "category_image.jpg",
      contentType: MediaType("image", "jpg"),
    );
    request.files.add(file);
    try {
      var response = await request.send();
      if (response.statusCode == 201) {
        setLoading(false);
        final responseJson = await response.stream.bytesToString();
        title = '';
        image = null;
        Utils.flushBarErrorMessage(
          "Category Create SuccessFully",
          context,
        );
        Future.delayed(const Duration(seconds: 3), () {
          GoRouter.of(context).go(RouteName.homeScreen);
        });
        if (kDebugMode) {
          print(responseJson);
        }
      } else if (response.statusCode == 400) {
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
    }
  }
}
