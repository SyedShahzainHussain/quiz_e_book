import 'package:flutter/material.dart';

import 'package:quiz_e_book/extension/mediaquery_extension/mediaquery_extension.dart';
import 'package:quiz_e_book/resources/color/app_color.dart';
import 'package:quiz_e_book/resources/routes/route_name/route_name.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(

      backgroundColor: AppColors.white,
      child: Column(children: [
        SizedBox(
          width: double.infinity,
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                RouteName.userProfileScreen,
              );
            },
            child: DrawerHeader(
                curve: Curves.bounceIn,
                decoration: const BoxDecoration(color: AppColors.bgColor2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      backgroundColor: AppColors.bgColor4,
                      radius: 30,
                      backgroundImage: NetworkImage(
                          'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'),
                    ),
                    SizedBox(height: context.screenheight * .01),
                    const Text(
                      "Mare Suit",
                      style: TextStyle(color: AppColors.white),
                    ),
                    const Text(
                      "MareSuit@Gmail.com",
                      style: TextStyle(color: AppColors.white),
                    ),
                  ],
                )),
          ),
        )
      ]),
    );
  }
}
