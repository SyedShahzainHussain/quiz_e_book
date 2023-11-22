import 'package:flutter/material.dart';
import 'package:quiz_e_book/extension/mediaquery_extension/mediaquery_extension.dart';
import 'package:quiz_e_book/extension/sizedbox_extension/sizedbox_extension.dart';
import 'package:quiz_e_book/resources/color/app_color.dart';
import 'package:quiz_e_book/resources/routes/route_name/route_name.dart';

import 'package:quiz_e_book/widget/drawer_widget.dart';
import 'package:quiz_e_book/widget/score_board_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // void pickFile() async {
    //   FilePickerResult? result = await FilePicker.platform.pickFiles(
    //     type: FileType.custom,
    //     allowedExtensions: ['pdf'],
    //   );
    //   if (result != null && result.files.first.path != null) {
    //     File file = File(result.files.single.path!);
    //     print(file);
    //   } else {
    //     print('user cancel');
    //   }
    // }

    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: AppColors.white),
          title: const Text(
            "Home",
            style: TextStyle(color: AppColors.white),
          ),
        ),
        drawer: const DrawerWidget(),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {},
                      child: Container(
                          width: context.screenwidth * .5,
                          height: context.screenheight * .15,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            image: const DecorationImage(
                              image: AssetImage(
                                'assets/images/quiz.jpg',
                              ),
                              opacity: 0.7,
                              fit: BoxFit.fill,
                            ),
                          ),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              "Quiz",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.black),
                            ),
                          )),
                    ),
                  )),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, RouteName.ebookScreen);
                      },
                      child: Container(
                          decoration: BoxDecoration(
                            image: const DecorationImage(
                              image: AssetImage(
                                'assets/images/e-book.jpg',
                              ),
                              opacity: 0.7,
                              fit: BoxFit.fill,
                            ),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          width: context.screenwidth * .5,
                          height: context.screenheight * .15,
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              "E-Book",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.black),
                            ),
                          )),
                    ),
                  )),
                ],
              ),
              SizedBox(
                height: context.screenheight * .02,
              ),
              SizedBox(
                height: context.screenheight * .65 -
                    MediaQuery.paddingOf(context).top -
                    MediaQuery.paddingOf(context).bottom,
                child: Card(
                  color: AppColors.bgColor2,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(children: [
                      Text(
                        "Score Board",
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      10.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Name",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(fontWeight: FontWeight.w700),
                          ),
                          Text(
                            "Total Score",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(fontWeight: FontWeight.w700),
                          )
                        ],
                      ),
                      const Divider(),
                      ScoreBoard()
                    ]),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
