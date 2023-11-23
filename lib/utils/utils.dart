import 'package:flutter/material.dart';
// ! pacakge
import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:quiz_e_book/resources/color/app_color.dart';

class Utils {
  static void flushBarErrorMessage(
    String message,
    BuildContext context,) {
    showFlushbar(
      context: context,
      flushbar: Flushbar(
        message: message,
        forwardAnimationCurve: Curves.decelerate,
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        duration: const Duration(seconds: 5),
        borderRadius: BorderRadius.circular(10),
      )..show(
          context,
        ),
    );
  }

  static showLoadingSpinner() {
    return SpinKitChasingDots(
      size: 30.0,
      itemBuilder: (BuildContext context, int index) {
        return const ClipOval(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.white,
              gradient: LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                colors: [
                  AppColors.bgColor,
                  AppColors.bgColor,
                  AppColors.bgColor3,
                  AppColors.bgColor4,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
