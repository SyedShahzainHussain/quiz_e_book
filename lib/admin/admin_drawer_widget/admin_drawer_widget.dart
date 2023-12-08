import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_e_book/extension/mediaquery_extension/mediaquery_extension.dart';
import 'package:quiz_e_book/resources/color/app_color.dart';
import 'package:quiz_e_book/resources/routes/route_name/route_name.dart';

class AdminDrawerWidget extends StatelessWidget {
  const AdminDrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.white,
      child: Column(children: [
        SizedBox(
          width: double.infinity,
          child: DrawerHeader(
              curve: Curves.bounceIn,
              decoration: const BoxDecoration(color: AppColors.bgColor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    backgroundColor: AppColors.bgColor4,
                    radius: 30,
                    backgroundImage: NetworkImage(
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTfGtrAgOIg4722RdOT1PRNtcq0fXIjIzlPqQ&usqp=CAU'),
                  ),
                  SizedBox(height: context.screenheight * .01),
                  Expanded(
                      child: Text('Admin..',
                          maxLines: 1,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  fontWeight: FontWeight.bold,
                                  overflow: TextOverflow.ellipsis,
                                  color: AppColors.white))),
                ],
              )),
        ),
        ListTile(
          onTap: () async {
            GoRouter.of(context).push(RouteName.adminRatingScreen);
          },
          title: const Text("Users Rating"),
          leading: const Icon(Icons.rate_review_outlined),
        ),
        ListTile(
          onTap: () async {
            GoRouter.of(context).push(RouteName.contactShow);
          },
          title: const Text("Users Contacts"),
          leading: const Icon(Icons.contact_mail),
        ),
        ListTile(
          onTap: () async {
            GoRouter.of(context).push(RouteName.uploadPdfScreen);
          },
          title: const Text("Upload Pdf"),
          leading: const Icon(Icons.picture_as_pdf),
        ),
        ListTile(
          onTap: () async {
            GoRouter.of(context).push(RouteName.uploadQuizScreen);
          },
          title: const Text("Upload Quiz Level"),
          leading: const Icon(Icons.quiz),
        ),
        ListTile(
          onTap: () async {
            GoRouter.of(context).push(RouteName.uploadQuestionScreen);
          },
          title: const Text("Upload Quiz Question"),
          leading: const Icon(Icons.question_answer),
        ),
        ListTile(
          onTap: () async {
            GoRouter.of(context).go(RouteName.homeScreen);
          },
          title: const Text("Back To Home"),
          leading: const Icon(Icons.backspace),
        ),
      ]),
    );
  }
}
