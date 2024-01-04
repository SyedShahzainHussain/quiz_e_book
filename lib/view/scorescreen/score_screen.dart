import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:quiz_e_book/extension/mediaquery_extension/mediaquery_extension.dart';
import 'package:quiz_e_book/model/login_model.dart';
import 'package:quiz_e_book/resources/color/app_color.dart';
import 'package:quiz_e_book/resources/routes/route_name/route_name.dart';
import 'package:quiz_e_book/resources/urls/app_url.dart';
import 'package:quiz_e_book/viewModel/auth_view_model/auth_view_model.dart';
import 'package:quiz_e_book/viewModel/getAllUsers/get_all_users.dart';
import 'package:quiz_e_book/viewModel/quiz_view_model/quiz_view_model.dart';
import 'package:quiz_e_book/viewModel/score_view_model/score_view_model.dart';
import 'package:quiz_e_book/viewModel/update_level_view_model/update_level_view_model.dart';

class ScoreScreen extends StatefulWidget {
  final String? title;
  const ScoreScreen({super.key, this.title});

  @override
  State<ScoreScreen> createState() => _ScoreScreenState();
}

class _ScoreScreenState extends State<ScoreScreen> {
  bool completionHandled = false; // Add this flag

  Future<void> fetchData() async {
    try {
      LoginData userData = await AuthViewModel().getUser();
      await GetAllUsers().getUserData(userData.token.toString());
    } catch (error) {
      // Handle errors if needed
    }
  }

  Future<void> _handleQuizCompletion(
      QuizViewModel value, BuildContext context) async {
    if (completionHandled) {
      return; // Exit if already handled
    }

    if ((value.numOfCorrectAns / value.questiionLength * 100).round() < 50) {
      // Quiz Uncompleted
      // You can add any additional logic here
      // ...
    } else {
      // Quiz completed successfully
      completionHandled = true;
      value.unlockNextLevel();
      AuthViewModel().getUser().then((value2) async {
        int score = value.numOfCorrectAns * 10;
        final body = {
          "incrementValue": score.toString(),
        };
        await context.read<ScoreViewModel>().updateScore(
          AppUrl.increment,
          body,
          context,
          headers: {"Authorization": "Bearer ${value2.token}"},
        ).then((value3) async {
          final currentLevel = int.parse(value.level);
          int newLevel = currentLevel + 1;
          final levelsArray = [newLevel];

          final body2 = {
            "unlocked": [
              {
                "type": widget.title,
                "values": levelsArray,
              }
            ]
          };
          await context.read<UpdateLevelViewModel>().updateLevelss(
            value2.token!,
            body2,
            context,
          );
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = context.read<QuizViewModel>();

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        title: const Text("Score Screen"),
      ),
      body: WillPopScope(
        onWillPop: () async {
          context.go(RouteName.homeScreen);
          data.resetcorrectAns();
          data.updateTheQnNum(0);
          return true;
        },
        child: Consumer<QuizViewModel>(builder: (context, value, child) {
          return FutureBuilder<void>(
            future: _handleQuizCompletion(value, context),
            builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // You can return a loading indicator if needed
                return const CircularProgressIndicator();
              } else {
                // Handle completed or error state
                if (snapshot.hasError) {
                  // Handle error state
                  return Text('Error: ${snapshot.error}');
                } else {
                  print("hello");
                  // UI based on completion status
                  if ((value.numOfCorrectAns / value.questiionLength * 100)
                          .round() <
                      50) {
                    // Quiz Uncompleted
                    return _buildUncompletedUI(context, value, data);
                  } else {
                    // Quiz completed successfully
                    return _buildCompletedUI(context, value, data);
                  }
                }
              }
            },
          );
        }),
      ),
    );
  }

  Center _buildCompletedUI(
    BuildContext context,
    QuizViewModel value,
    QuizViewModel data,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(22.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          SizedBox(
            width: double.infinity,
            child: Card(
              color: AppColors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
              child: Padding(
                padding: const EdgeInsets.all(22.0),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/winner.png',
                      width: context.screenwidth * .5,
                      height: context.screenheight * .15,
                      alignment: Alignment.center,
                    ),
                    const Gap(10),
                    Text(
                      "Congrats!",
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: AppColors.black,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                            "${(value.numOfCorrectAns / value.questiionLength * 100).round()}%",
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(
                                  color: AppColors.green,
                                  fontWeight: FontWeight.bold,
                                )),
                        const Gap(10),
                        Text(
                          "Score",
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(
                                color: AppColors.green,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    const Gap(10),
                    Text(
                      "Quiz completed successfully.",
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: AppColors.green,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const Gap(10),
                    Text.rich(
                      TextSpan(
                          text: "You attempt ",
                          style:
                              Theme.of(context).textTheme.titleSmall!.copyWith(
                                    color: AppColors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                          children: [
                            TextSpan(
                              text: '${value.questiionLength} questions',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                    color: AppColors.bgColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            TextSpan(
                              text: ' and \n from that ',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                    color: AppColors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            TextSpan(
                              text: '${value.numOfCorrectAns} answer ',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                    color: AppColors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            TextSpan(
                              text: 'is correct. ',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                    color: AppColors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ]),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Consumer<ScoreViewModel>(
            builder: (context, value, _) => ElevatedButton(
                onPressed: () {
                  fetchData().then((value) {
                    context.go(RouteName.homeScreen);
                    data.resetcorrectAns();
                    data.updateTheQnNum(0);
                  });
                },
                child: value.loading
                    ? const Text("Loading....")
                    : const Text("Back to Home")),
          )
        ]),
      ),
    );
  }

  Center _buildUncompletedUI(
    BuildContext context,
    QuizViewModel value,
    QuizViewModel data,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(22.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          SizedBox(
            width: double.infinity,
            child: Card(
              color: AppColors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
              child: Padding(
                padding: const EdgeInsets.all(22.0),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/next_time.png',
                      width: context.screenwidth * .5,
                      height: context.screenheight * .15,
                      alignment: Alignment.center,
                    ),
                    const Gap(10),
                    Text(
                      "Better luck next time!",
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: AppColors.black,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                            "${(value.numOfCorrectAns / value.questiionLength * 100).round()}%",
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(
                                  color: AppColors.red,
                                  fontWeight: FontWeight.bold,
                                )),
                        const Gap(10),
                        Text(
                          "Score",
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(
                                color: AppColors.red,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    const Gap(10),
                    Text(
                      'Quiz UnCompleted.',
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: AppColors.red,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const Gap(10),
                    Text.rich(
                      TextSpan(
                          text: "You attempt ",
                          style:
                              Theme.of(context).textTheme.titleSmall!.copyWith(
                                    color: AppColors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                          children: [
                            TextSpan(
                              text: '${value.questiionLength} questions',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                    color: AppColors.bgColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            TextSpan(
                              text: ' and \n from that ',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                    color: AppColors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            TextSpan(
                              text: '${value.numOfCorrectAns} answer ',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                    color: AppColors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            TextSpan(
                              text: 'is correct. ',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                    color: AppColors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ]),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Consumer<ScoreViewModel>(
            builder: (context, value, _) => ElevatedButton(
                onPressed: () {
                  fetchData().then((value) {
                    context.go(RouteName.homeScreen);
                    data.resetcorrectAns();
                    data.updateTheQnNum(0);
                  });
                },
                child: value.loading
                    ? const Text("Loading....")
                    : const Text("Back to Home")),
          )
        ]),
      ),
    );
  }
}
