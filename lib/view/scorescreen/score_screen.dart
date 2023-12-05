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

class ScoreScreen extends StatelessWidget {
  const ScoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = context.read<QuizViewModel>();
    Future<LoginData> getUserData() => AuthViewModel().getUser();
    GetAllUsers getAllUsers = GetAllUsers();
    String message;
    Color messageColor;
    String image;
    String quizComplete;
    String buttonText;
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
          if ((value.numOfCorrectAns / value.questiionLength * 100).round() <
              50) {
            message = "Better luck next time!";
            messageColor = AppColors.red;
            image = 'assets/images/next_time.png';
            quizComplete = 'Quiz UnCompleted.';
            buttonText = "Back to Home";
          } else {
            message = "Congrats!";
            messageColor = AppColors.green;
            image = 'assets/images/winner.png';
            quizComplete = "Quiz completed successfully.";
            buttonText = "Back to Home";
            value.unlockNextLevel();
            AuthViewModel().getUser().then((value2) {
              int score = value.numOfCorrectAns * 10;
              final body = {
                "incrementValue": score.toString(),
              };
              context.read<ScoreViewModel>().updateScore(
                  AppUrl.increment, body, context, headers: {
                "Authorization": "Bearer ${value2.token}"
              }).then((value3) {
                final currentLevel = int.parse(value.level);
                int newLevel = currentLevel + 1;
                String newLevelString = newLevel.toString();

                final body2 = {"newString": newLevelString.toString()};
                context.read<UpdateLevelViewModel>().updateLevel(
                      value2.token!,
                      body2,
                      context,
                    );
              });
            });
          }
          Future<void> fetchData() async {
            try {
              LoginData userData = await getUserData();
              await getAllUsers.getUserData(userData.token.toString());
            } catch (error) {
              // Handle errors if needed
            }
          }

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(22.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                                image,
                                width: context.screenwidth * .5,
                                height: context.screenheight * .15,
                                alignment: Alignment.center,
                              ),
                              const Gap(10),
                              Text(
                                message,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
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
                                            color: messageColor,
                                            fontWeight: FontWeight.bold,
                                          )),
                                  const Gap(10),
                                  Text(
                                    "Score",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium!
                                        .copyWith(
                                          color: messageColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              ),
                              const Gap(10),
                              Text(
                                quizComplete,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(
                                      color: messageColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const Gap(10),
                              Text.rich(
                                TextSpan(
                                    text: "You attempt ",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(
                                          color: AppColors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                    children: [
                                      TextSpan(
                                        text:
                                            '${value.questiionLength} questions',
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
                                        text:
                                            '${value.numOfCorrectAns} answer ',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .copyWith(
                                              color: messageColor,
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
                              : Text(buttonText)),
                    )
                  ]),
            ),
          );
        }),
      ),
    );
  }
}
