import "package:flutter/material.dart";
import "package:gap/gap.dart";
import "package:quiz_e_book/resources/color/app_color.dart";

class ContactTextField {
  static Container textfield(
      BuildContext context,
      String title,
      String fieldText,
      int? maxline,
      Widget? icon,
      TextEditingController textEditingController) {
    return Container(
      margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              icon!,
              const Gap(10),
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    fontWeight: FontWeight.bold, color: AppColors.textColor),
              )
            ],
          ),
          const Gap(10),
          TextField(
            cursorColor: const Color(0xffdd884d),
            controller: textEditingController,
            maxLines: maxline,
            decoration: InputDecoration(
                fillColor: AppColors.textfieldcolor,
                hintText: fieldText,
                filled: true,
                contentPadding: const EdgeInsets.all(15),
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(7))),
          )
        ],
      ),
    );
  }
}
