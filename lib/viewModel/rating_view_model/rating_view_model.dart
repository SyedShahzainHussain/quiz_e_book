import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:quiz_e_book/resources/urls/app_url.dart';
import 'package:quiz_e_book/utils/utils.dart';

class RatingViewModel with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<void> postRating(context, dynamic body, String token) async {
    setLoading(true);
    try {
      final response = await post(Uri.parse(AppUrl.rating),
          body: body, headers: {"Authorization": "Bearer $token"});

      if (response.statusCode == 201) {
        setLoading(false);
        return Utils.flushBarErrorMessage(
            "Your Feedback has been sent to the admin", context);
      }
    } catch (e) {
      setLoading(false);
      return Utils.flushBarErrorMessage("Server Error", context);
    }
  }
}
