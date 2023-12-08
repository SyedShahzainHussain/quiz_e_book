import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:quiz_e_book/extension/mediaquery_extension/mediaquery_extension.dart';
import 'package:quiz_e_book/resources/color/app_color.dart';
import 'package:quiz_e_book/resources/routes/route_name/route_name.dart';
import 'package:quiz_e_book/viewModel/auth_view_model/auth_view_model.dart';
import 'package:share_plus/share_plus.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({
    super.key,
  });

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  void initState() {
    super.initState();
    context.read<AuthViewModel>().fetchLoginData();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.white,
      child: Column(children: [
        SizedBox(
          width: double.infinity,
          child: GestureDetector(
            onTap: () {
              GoRouter.of(context).push(RouteName.userProfileScreen);
            },
            child: Consumer<AuthViewModel>(
              builder: (context, value, child) => DrawerHeader(
                  curve: Curves.bounceIn,
                  decoration: const BoxDecoration(color: AppColors.bgColor),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColors.bgColor4,
                        radius: 30,
                        backgroundImage: NetworkImage(value
                                .loginData?.profilePhoto ??
                            'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'),
                      ),
                      SizedBox(height: context.screenheight * .01),
                      Expanded(
                          child: Text(value.loginData?.username ?? 'loading..',
                              maxLines: 1,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      overflow: TextOverflow.ellipsis,
                                      color: AppColors.white))),
                      Expanded(
                        child: Text(value.loginData?.email ?? 'loading..',
                            maxLines: 1,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    fontWeight: FontWeight.bold,
                                    overflow: TextOverflow.ellipsis,
                                    color: AppColors.white)),
                      ),
                    ],
                  )),
            ),
          ),
        ),
        Builder(
          builder: (BuildContext context) {
            final authViewModel = Provider.of<AuthViewModel>(context);
            final role = authViewModel.loginData?.role;
            if (role == 'admin') {
              return ListTile(
                onTap: () {
                  GoRouter.of(context).push(RouteName.adminScreen);
                },
                title: const Text("Admin"),
                leading: const FaIcon(FontAwesomeIcons.userPlus),
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
        ListTile(
          onTap: () {
            Navigator.pop(context);
            context.push(RouteName.aboutScreen);
          },
          title: const Text("About Us"),
          leading: const FaIcon(FontAwesomeIcons.circleInfo),
        ),
        ListTile(
          onTap: () {
            Navigator.pop(context);
            context.push(RouteName.contactScreen);
          },
          title: const Text("Contacts Us"),
          leading: const FaIcon(FontAwesomeIcons.addressCard),
        ),
        ListTile(
          onTap: () {
            Navigator.pop(context);
            context.push(RouteName.ratingScreen);
          },
          title: const Text("Rating Us"),
          leading: const FaIcon(FontAwesomeIcons.star),
        ),
        ListTile(
          onTap: () {
            Navigator.pop(context);
            Share.share(
              "https://zain.page.link/home_screen",
            );
          },
          title: const Text("Share App"),
          leading: const FaIcon(FontAwesomeIcons.share),
        ),
      ]),
    );
  }
}
