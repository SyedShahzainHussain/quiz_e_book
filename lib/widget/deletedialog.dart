import 'package:flutter/material.dart';
import 'package:quiz_e_book/resources/color/app_color.dart';

class DeleteDialog {
  static Future<dynamic> showdialog(
      BuildContext context, void Function()? delete) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: const Text("Are you sure you want to delete ?"),
            actions: <Widget>[
              TextButton(
                child: Text("Cancel",
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                          color: AppColors.black,
                        )),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              FilledButton.tonal(
                onPressed: delete,
                child: Text("Delete",
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                          color: AppColors.red,
                        )),
              ),
            ],
          );
        });
  }
}
