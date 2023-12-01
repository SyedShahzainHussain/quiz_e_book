import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:quiz_e_book/extension/mediaquery_extension/mediaquery_extension.dart';
import 'package:quiz_e_book/resources/color/app_color.dart';
import 'package:quiz_e_book/resources/routes/route_name/route_name.dart';
import 'package:quiz_e_book/viewModel/quiz_view_model/quiz_view_model.dart';

class ScoreScreen extends StatelessWidget {
  const ScoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = context.read<QuizViewModel>();
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
                    ElevatedButton(
                        onPressed: () {
                          context.go(RouteName.homeScreen);
                          data.resetcorrectAns();
                          data.updateTheQnNum(0);
                        },
                        child: Text(buttonText))
                  ]),
            ),
          );
        }),
      ),
    );
  }
}
