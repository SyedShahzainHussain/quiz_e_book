import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:quiz_e_book/repositories/update_level/update_level.dart';

class UpdateLevelViewModel with ChangeNotifier {
  UpdateLevel updateLevels = UpdateLevel();

  void updateLevel(String token, dynamic body, BuildContext context) async {
    updateLevels.updateLevel(body, token).then((value) {
      if (kDebugMode) {
        print(value);
      }
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error);
        print(stackTrace);
      }
    });
  }

  Future<void> updateLevelss(
      String token, Map<String, dynamic> body, BuildContext context) async {
    try {
      final response = await put(
        Uri.parse('https://quiz-backend-vc19.onrender.com/unlocked'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );
      if (response.statusCode == 200) {
        print("done");
      } else {
        print(response.body);
      }
      // Handle the response here
    } catch (e) {
      print("Error during the HTTP request: $e");
    }
  }
}
