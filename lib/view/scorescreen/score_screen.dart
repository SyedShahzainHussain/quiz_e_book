import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:quiz_e_book/resources/color/app_color.dart';
import 'package:quiz_e_book/resources/routes/route_name/route_name.dart';
import 'package:quiz_e_book/viewModel/quiz_view_model.dart';

class ScoreScreen extends StatelessWidget {
  const ScoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Score Screen"),),
      body: WillPopScope(
        onWillPop: () async {
          context.go(RouteName.homeScreen);
          return true;
        },
        child: Consumer<QuizViewModel>(
          builder: (context, value, index) => Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(22.0),
                  child: Column(
                    children: [
                      Text(
                        "Score",
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(color: AppColors.bgColor),
                      ),
                      const Gap(20),
                      Text(
                          "${value.numOfCorrectAns * 10}/${value.questiionLength * 10}",
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(
                                color: AppColors.black,
                              ))
                    ],
                  ),
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
