import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_e_book/resources/color/app_color.dart';
import 'package:quiz_e_book/utils/utils.dart';

class Buttonwidget extends StatelessWidget {
  final String text;
  final Function()? onTap;
  final bool isLoading;
  const Buttonwidget(
      {super.key,
      required this.text,
      required this.onTap,
      this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(12.0),
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            gradient: const LinearGradient(
              colors: [
                AppColors.bgColor2,
                AppColors.bgColor,
                AppColors.bgColor4,
              ],
              begin: Alignment.topLeft,
              end: Alignment.centerRight,
            )),
        child: isLoading
            ? Utils.showLoadingSpinner()
            : Text(
                text,
                style: GoogleFonts.poppins(
                  color: AppColors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
      ),
    );
  }
}
