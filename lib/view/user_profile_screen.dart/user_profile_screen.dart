import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_e_book/extension/mediaquery_extension/mediaquery_extension.dart';
import 'package:quiz_e_book/resources/color/app_color.dart';
import 'package:quiz_e_book/resources/routes/route_name/route_name.dart';
import 'package:quiz_e_book/viewModel/auth_view_model/auth_view_model.dart';
import 'package:quiz_e_book/widget/button_widget.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AuthViewModel>().fetchLoginData();
  }

  @override
  Widget build(BuildContext context) {
    final data = context.read<AuthViewModel>();
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text("Profile Screen"),
      ),
      body: Consumer<AuthViewModel>(builder: (context, value, child) {
        String dateString = value.loginData?.dob.toString() ?? "loading...";
        DateTime dateTime = DateTime.parse(dateString);
        String formattedDate =
            "${dateTime.year}/${dateTime.month}/${dateTime.day}";

        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: context.screenwidth * .15,
                  backgroundImage: NetworkImage(value.loginData?.profilePhoto ??
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTcNPOPDCWiEvN0x11fc_02MzdhtzcLOwg-qg&usqp=CAU'),
                ),
                // Positioned(
                //   bottom: -10,
                //   right: 0,
                //   child: IconButton(
                //     onPressed: () {},
                //     icon: const Icon(
                //       Icons.camera_alt,
                //     ),
                //   ),
                // ),

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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Icon(Icons.person, color: AppColors.white),
                              const SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: Text(
                                  value.loginData?.username ?? 'loading..',
                                  maxLines: 1,
                                  style: const TextStyle(
                                      color: AppColors.white,
                                      overflow: TextOverflow.ellipsis),
                                ),
                              ),
                            ],
                          ),
                          const Divider(
                            color: AppColors.white,
                          ),
                          SizedBox(
                            height: context.screenheight * .01,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Icon(Icons.email, color: AppColors.white),
                              const SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: Text(
                                  value.loginData?.email ?? 'loading..',
                                  maxLines: 1,
                                  style: const TextStyle(
                                      color: AppColors.white,
                                      overflow: TextOverflow.ellipsis),
                                ),
                              )
                            ],
                          ),
                          const Divider(color: AppColors.white),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Icon(Icons.calendar_month_outlined,
                                  color: AppColors.white),
                              const SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: Text(
                                  formattedDate,
                                  maxLines: 1,
                                  style: const TextStyle(
                                      color: AppColors.white,
                                      overflow: TextOverflow.ellipsis),
                                ),
                              )
                            ],
                          ),
                          const Divider(
                            color: AppColors.white,
                          ),
                        ]),
                  ),
                ),
                SizedBox(
                  height: context.screenheight * .05,
                ),
                Card(
                  elevation: 5,
                  child: Buttonwidget(
                      text: "Logout",
                      onTap: () {
                        data.remove().then((value2) {
                          Navigator.pushNamedAndRemoveUntil(
                              context, RouteName.loginScreen, (route) => false);
                        });
                      }),
                )
              ]),
        );
      }),
    );
  }
}
