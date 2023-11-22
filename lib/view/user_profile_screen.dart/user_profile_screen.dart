import 'package:flutter/material.dart';
import 'package:quiz_e_book/extension/mediaquery_extension/mediaquery_extension.dart';
import 'package:quiz_e_book/resources/color/app_color.dart';
import 'package:quiz_e_book/resources/routes/route_name/route_name.dart';
import 'package:quiz_e_book/widget/button_widget.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile Screen"),
      ),
      
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: context.screenwidth * .15,
                    backgroundImage: const NetworkImage(
                        'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'),
                  ),
                  Positioned(
                    bottom: -10,
                    right: 0,
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.camera_alt,
                      ),
                    ),
                  ),
                ],
              ),
              Card(
                color: AppColors.bgColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: context.screenheight * .01,
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.person, color: AppColors.white),
                            SizedBox(),
                            Text(
                              "Mare Suit",
                              style: TextStyle(color: AppColors.white),
                            ),
                          ],
                        ),
                        const Divider(
                          color: Colors.white,
                        ),
                        SizedBox(
                          height: context.screenheight * .01,
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.email, color: AppColors.white),
                            SizedBox(),
                            Text(
                              "MareSuit@Gmail.com",
                              style: TextStyle(color: AppColors.white),
                            )
                          ],
                        ),
                        const Divider(
                          color: Colors.white,
                        ),
                      ]),
                ),
              ),
              SizedBox(
                height: context.screenheight * .05,
              ),
              Buttonwidget(
                  text: "Logout",
                  onTap: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, RouteName.loginScreen, (route) => false);
                  })
            ]),
      ),
    );
  }
}
