import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:quiz_e_book/data/response/status.dart';
import 'package:quiz_e_book/data/services/splash_services.dart/splash_services.dart';
import 'package:quiz_e_book/extension/mediaquery_extension/mediaquery_extension.dart';
import 'package:quiz_e_book/model/login_model.dart';
import 'package:quiz_e_book/model/users.dart';
import 'package:quiz_e_book/resources/color/app_color.dart';
import 'package:quiz_e_book/resources/routes/route_name/route_name.dart';
import 'package:quiz_e_book/utils/utils.dart';
import 'package:quiz_e_book/viewModel/auth_view_model/auth_view_model.dart';
import 'package:quiz_e_book/viewModel/getAllUsers/get_all_users.dart';
import 'package:quiz_e_book/viewModel/quiz_view_model/quiz_view_model.dart';
import 'package:quiz_e_book/widget/Score_widget.dart';

import 'package:quiz_e_book/widget/drawer_widget.dart';
import 'package:quiz_e_book/widget/positioned_widget.dart';
import 'package:quiz_e_book/widget/quiz_ebook_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GetAllUsers getAllUsers = GetAllUsers();
  Future<LoginData> getUserData() => AuthViewModel().getUser();
  SplashService splashService = SplashService();
  ScrollController scrollController = ScrollController();
  Future<void> fetchData() async {
    try {
      LoginData userData = await getUserData();
      await getAllUsers.getUserData(userData.token.toString());
    } catch (error) {
      // Handle errors if needed
    }
  }

  bool _isReassembling = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Check if the screen is being reassembled
    if (!_isReassembling) {
      fetchData();
    }

    // Reset the flag after checking
    _isReassembling = false;
  }

  @override
  void initState() {
    fetchData();
    super.initState();

    context.read<QuizViewModel>().getToken();
  }

  Color determinePositionColor(int position) {
    switch (position) {
      case 1:
        return AppColors.secondpositioned;
      case 2:
        return AppColors.firstpositioned;
      case 3:
        return AppColors.bgColor;
      default:
        return Colors.grey; // Handle other positions as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    context.watch<QuizViewModel>();

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppColors.white),
        title: const Text(
          "Home",
          style: TextStyle(color: AppColors.white),
        ),
      ),
      drawer: const DrawerWidget(),
      body: ChangeNotifierProvider<GetAllUsers>(
          create: (BuildContext context) => getAllUsers,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Row(
                  children: [
                    QuizAndEbookWidget(
                        image: "assets/images/quiz.jpg",
                        title: "Quiz",
                        onTap: () {
                          GoRouter.of(context).push(RouteName.quizScreen);
                        }),
                    QuizAndEbookWidget(
                        image: "assets/images/e-book.jpg",
                        title: "E-Book",
                        onTap: () {
                          GoRouter.of(context).push(RouteName.ebookScreen);
                        }),
                  ],
                ),
                SizedBox(
                  height: context.screenheight * .05,
                ),
                ChangeNotifierProvider(
                  create: (BuildContext context) => getAllUsers,
                  child: Consumer<GetAllUsers>(
                    builder: (context, value, _) {
                      switch (value.apiresponse.status) {
                        case Status.loading:
                          return Center(child: Utils.showLoadingSpinner());
                        case Status.error:
                          // Error handling code here
                          return const SizedBox.shrink();
                        case Status.completed:
                          List<Users> sortedUsers =
                              List.from(value.apiresponse.data!);
                          sortedUsers
                              .sort((a, b) => b.scorrer!.compareTo(a.scorrer!));

                          List<Users> highPercentageUsers = sortedUsers
                              .where((user) => user.scorrer! >= 100)
                              .toList();
                          List<Users> mediumPercentageUsers = sortedUsers
                              .where((user) =>
                                  user.scorrer! >= 70 && user.scorrer! < 100)
                              .toList();
                          List<Users> lowPercentageUsers = sortedUsers
                              .where((user) =>
                                  user.scorrer! >= 50 && user.scorrer! < 70)
                              .toList();

                          // Take the top user from each category
                          List<Users> topUser = highPercentageUsers.isNotEmpty
                              ? [highPercentageUsers.first]
                              : lowPercentageUsers.isNotEmpty
                                  ? [lowPercentageUsers.first]
                                  : [];

                          List<Users> secondUser =
                              mediumPercentageUsers.isNotEmpty
                                  ? [mediumPercentageUsers.first]
                                  : lowPercentageUsers.length > 1
                                      ? [lowPercentageUsers[1]]
                                      : [];

                          List<Users> thirdUser = lowPercentageUsers.length > 2
                              ? [lowPercentageUsers[2]]
                              : mediumPercentageUsers.length > 1
                                  ? [mediumPercentageUsers[1]]
                                  : lowPercentageUsers.isNotEmpty
                                      ? [lowPercentageUsers.first]
                                      : [];

                          // Combine the users in the desired order
                          List<Users> topThreeUsers =
                              topUser + secondUser + thirdUser;

                          return Column(
                            children: [
                              Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: topThreeUsers.map((user) {
                                    final index = topThreeUsers.indexOf(user);
                                    final isCentered = index == 0;

                                    int? position;
                                    switch (index) {
                                      case 0:
                                        position =
                                            1; // Set to 2 if centered, else 1
                                        break;
                                      case 1:
                                        position =
                                            2; // Always set to 1 for the centered user
                                        break;
                                      case 2:
                                        position =
                                            3; // Set to 2 if centered, else 3
                                        break;
                                    }
                                    return PositionHolderWidget(
                                      height: isCentered
                                          ? context.screenheight *
                                              .2 // Adjust the factor as needed
                                          : context.screenheight * 0.15,
                                      width: context.screenwidth * .3,
                                      position: position.toString(),
                                      winnername: user.username!,
                                      totalScore: user.scorrer!,
                                      positionColor: determinePositionColor(
                                          topThreeUsers.indexOf(user) + 1),
                                      winnerprofile: user.profilePhoto!,
                                    );
                                  }).toList()),
                            ],
                          );
                        default:
                          return const SizedBox.shrink();
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: context.screenheight * .02,
                ),
                ScoreWidget(
                  scrollController: scrollController,
                ),
              ],
            ),
          )),
    );
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