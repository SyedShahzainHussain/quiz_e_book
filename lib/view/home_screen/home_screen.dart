import 'package:flutter/material.dart';
import 'package:quiz_e_book/extension/mediaquery_extension/mediaquery_extension.dart';
import 'package:quiz_e_book/resources/color/app_color.dart';
import 'package:quiz_e_book/resources/routes/route_name/route_name.dart';
import 'package:quiz_e_book/widget/Score_widget.dart';

import 'package:quiz_e_book/widget/drawer_widget.dart';
import 'package:quiz_e_book/widget/positioned_widget.dart';
import 'package:quiz_e_book/widget/quiz_ebook_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: AppColors.white),
          title: const Text(
            "Home",
            style: TextStyle(color: AppColors.white),
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(
                left: 5,
                right: 15,
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: AppColors.bgColor3),
              padding: const EdgeInsets.all(5.0),
              child: Row(
                children: [
                  Text(
                    '100',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Image.asset(
                    "assets/images/coin.gif",
                    width: 20,
                  ),
                ],
              ),
            )
          ],
        ),
        drawer: const DrawerWidget(),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Row(
                children: [
                  QuizAndEbookWidget(
                      image: "assets/images/quiz.jpg",
                      title: "Quiz",
                      onTap: () {}),
                  QuizAndEbookWidget(
                      image: "assets/images/e-book.jpg",
                      title: "E-Book",
                      onTap: () {
                        Navigator.pushNamed(context, RouteName.ebookScreen);
                      }),
                ],
              ),
              SizedBox(
                height: context.screenheight * .05,
              ),
              Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      PositionHolderWidget(
                        height: context.screenheight * .15,
                        width: context.screenwidth * .3,
                        position: '2',
                        winnername: "Alishba",
                        totalScore: "800",
                        positionColor: AppColors.secondpositioned,
                        winnerprofile:
                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS9j-T0S_IkBKoSDse9xf_4PmgvPjtrN6zwLg&usqp=CAU',
                      ),
                      PositionHolderWidget(
                        height: context.screenheight * .2,
                        width: context.screenwidth * .3,
                        position: '1',
                        winnername: "Sadia",
                        totalScore: "1000",
                        positionColor: AppColors.firstpositioned,
                        winnerprofile:
                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSQAnbGam3LTcANNzA138-7xvcuzrTO5eqlnw&usqp=CAU',
                      ),
                      PositionHolderWidget(
                        height: context.screenheight * .15,
                        width: context.screenwidth * .3,
                        position: '3',
                        winnername: "Shariq",
                        totalScore: "900",
                        positionColor: AppColors.bgColor,
                        winnerprofile:
                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTcNPOPDCWiEvN0x11fc_02MzdhtzcLOwg-qg&usqp=CAU',
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: context.screenheight * .02,
              ),
              const ScoreWidget()
            ],
          ),
        ));
  }
}


// SizedBox(
              //   height: context.screenheight * .65 -
              //       MediaQuery.paddingOf(context).top -
              //       MediaQuery.paddingOf(context).bottom,
              //   child: Card(
              //     color: AppColors.bgColor2,
              //     child: Padding(
              //       padding: const EdgeInsets.all(12.0),
              //       child: Column(children: [
              //         Text(
              //           "Score Board",
              //           style: Theme.of(context)
              //               .textTheme
              //               .headlineMedium!
              //               .copyWith(fontWeight: FontWeight.bold),
              //         ),
              //         10.height,
              //         Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             Text(
              //               "Name",
              //               style: Theme.of(context)
              //                   .textTheme
              //                   .titleMedium!
              //                   .copyWith(fontWeight: FontWeight.w700),
              //             ),
              //             Text(
              //               "Total Score",
              //               style: Theme.of(context)
              //                   .textTheme
              //                   .titleMedium!
              //                   .copyWith(fontWeight: FontWeight.w700),
              //             )
              //           ],
              //         ),
              //         const Divider(),
              //         ScoreBoard()
              //       ]),
              //     ),
              //   ),
              // )