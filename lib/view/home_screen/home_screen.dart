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
import 'package:quiz_e_book/viewModel/reward_add/reward_add.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {

    context.read<RewardAdd>().createReward();
    });
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
                          GoRouter.of(context).push(RouteName.categoriesScreen);
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
                          sortedUsers.sort(
                            (a, b) => b.scorrer!.compareTo(a.scorrer!),
                          );

                          List<Users> highPercentageUsers = sortedUsers
                              .where((user) => user.scorrer! >= 200)
                              .toList();

                          List<Users> mediumPercentageUsers = sortedUsers
                              .where((user) =>
                                  user.scorrer! >= 100 && user.scorrer! < 200)
                              .toList();
                          List<Users> lowPercentageUsers = sortedUsers
                              .where((user) =>
                                  user.scorrer! >= 50 && user.scorrer! < 100)
                              .toList();

                          // Select top users from each category
                          List<Users> topUser =
                              highPercentageUsers.take(1).toList();
                          List<Users> secondUser =
                              mediumPercentageUsers.take(1).toList();
                          List<Users> thirdUser =
                              lowPercentageUsers.take(1).toList();

                          // ! Combine the users in the desired order
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
                                    double height;
                                    int? position;
                                    // ! set the height of the positioned  and also set the positioned number by index
                                    switch (index) {
                                      case 0:
                                        position = 1;
                                        height = context.screenheight * .2;

                                        break;
                                      case 1:
                                        position = 2;
                                        height = context.screenheight * 0.17;
                                        break;
                                      case 2:
                                        position = 3;
                                        height = height =
                                            context.screenheight * 0.14;
                                        break;
                                      default:
                                        position = null;
                                        height = 0.0;
                                    }

                                    return PositionHolderWidget(
                                      height: height,
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