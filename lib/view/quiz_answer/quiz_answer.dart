import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:quiz_e_book/data/response/status.dart';
import 'package:quiz_e_book/extension/mediaquery_extension/mediaquery_extension.dart';
import 'package:quiz_e_book/model/login_model.dart';

import 'package:quiz_e_book/resources/color/app_color.dart';
import 'package:quiz_e_book/resources/urls/app_url.dart';
import 'package:quiz_e_book/viewModel/auth_view_model/auth_view_model.dart';
import 'package:quiz_e_book/viewModel/getAllUsers/get_all_users.dart';
import 'package:quiz_e_book/viewModel/get_single_user_view_model/get_single_user_view_model.dart';
import 'package:quiz_e_book/viewModel/quiz_view_model/quiz_view_model.dart';
import 'package:quiz_e_book/viewModel/score_view_model/score_view_model.dart';

class QuizAnswer extends StatefulWidget {
  final String level;

  const QuizAnswer({super.key, required this.level});

  @override
  State<QuizAnswer> createState() => _QuizAnswerState();
}

class _QuizAnswerState extends State<QuizAnswer>
    with SingleTickerProviderStateMixin {
  late Animation animation;
  late AnimationController animationController;
  late PageController _pageController;
  GetAllUsers getAllUsers = GetAllUsers();
  Future<LoginData> getUserData() => AuthViewModel().getUser();
  GetSingleUserViewModel getSingleUserViewModel = GetSingleUserViewModel();
  Future<void> fetchData() async {
    try {
      LoginData userData = await getUserData();
      await getSingleUserViewModel.getSingleUsers(
          userData.token.toString(), userData.sId.toString());
    } catch (error) {
      // Handle errors if needed
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    getUserData()
        .then((value) => {getAllUsers.getUserData(value.token.toString())});
    context.read<QuizViewModel>().createRewardAdd();
    _pageController = PageController();
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 60));
    animation = Tween(begin: 0.0, end: 1.0).animate(animationController)
      ..addListener(() {
        setState(() {});
      });
    animationController.forward().whenComplete(() {
      final ques = context
          .read<QuizViewModel>()
          .getQuestion
          .where((e) => e.level == widget.level)
          .toList();
      context
          .read<QuizViewModel>()
          .nextQuestion(_pageController, animationController, context, ques);
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
     animationController.forward().whenComplete(() {
      final ques = context
          .read<QuizViewModel>()
          .getQuestion
          .where((e) => e.level == widget.level)
          .toList();
      context
          .read<QuizViewModel>()
          .nextQuestion(_pageController, animationController, context, ques);
    });
    final quizViewModel = context.read<QuizViewModel>();
    // ! checking the level is matach then show that question
    final ques = context.read<QuizViewModel>().findbyLevel(widget.level);

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        actions: [
          ChangeNotifierProvider(
            create: (BuildContext context) => getSingleUserViewModel,
            child: Consumer<GetSingleUserViewModel>(
              builder: (context, getAllUsers, child) {
                switch (getAllUsers.apiresponse.status) {
                  case Status.loading:
                    return const Center(
                      child: Text(
                        "Loading..",
                        style: TextStyle(color: AppColors.white),
                      ),
                    );

                  case Status.error:
                    return const Center(
                      child: Text("Error"),
                    );
                  case Status.completed:
                    return TextButton(
                      onPressed: () async {
                        final score =
                            getAllUsers.apiresponse.data!['scorrer'] ?? 0;
                        if (score == 0) {
                          showDialog(
                            context:
                                context, // Provide the actual context where you want to show the dialog
                            builder: (context) => AlertDialog(
                              title: const Text('Zero Score Dialog'),
                              content: const Text(
                                  'Your score is zero. you cannot to skip?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    // Close the dialog
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Cancel'),
                                ),
                              ],
                            ),
                          );
                        } else {
                          AuthViewModel().getUser().then((value2) {
                            int score = 10;
                            final body = {
                              "decrementValue": score.toString(),
                            };
                            context.read<ScoreViewModel>().updateScore(
                                AppUrl.decrement, body, context, headers: {
                              "Authorization": "Bearer ${value2.token}"
                            }).then((value) {
                              quizViewModel.nextQuestion(
                                _pageController,
                                animationController,
                                context,
                                ques,
                              );
                            });
                          });
                        }
                      },
                      child: const Text("Skip",
                          style: TextStyle(color: AppColors.white)),
                    );

                  default:
                    return const SizedBox.shrink();
                }
              },
            ),
          )
        ],
      ),
      // ignore: deprecated_member_use
      body: WillPopScope(
        onWillPop: () async {
          quizViewModel.updateTheQnNum(0);
          return true;
        },
        child: SingleChildScrollView(
          child: SizedBox(
            height: context.screenheight -
                MediaQuery.paddingOf(context).top -
                MediaQuery.paddingOf(context).bottom -
                AppBar().preferredSize.height,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 35,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.white, width: 3),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Stack(
                      children: [
                        LayoutBuilder(
                            builder: (context, constraints) => Container(
                                  width: constraints.maxWidth * animation.value,
                                  decoration: BoxDecoration(
                                      gradient: AppColors.kPrimaryGradient,
                                      borderRadius: BorderRadius.circular(50)),
                                )),
                        Positioned.fill(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${(animation.value * 60).round()} sec',
                                  style: const TextStyle(
                                    color: AppColors.white,
                                  ),
                                ),
                                Image.asset("assets/images/clock.png")
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const Gap(10),
                  Consumer<QuizViewModel>(
                    builder: (context, value, child) => Text.rich(
                      TextSpan(
                        text: "Question ${value.questionNumber}",
                        style:
                            Theme.of(context).textTheme.headlineSmall!.copyWith(
                                  color: AppColors.white,
                                ),
                        children: [
                          TextSpan(
                            text: "/${ques.length}",
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  color: AppColors.white,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    thickness: 1.5,
                    color: AppColors.bgColor,
                  ),
                  const Gap(20),
                  Expanded(
                    child: PageView.builder(
                      itemCount: ques.length,
                      onPageChanged: quizViewModel.updateTheQnNum,
                      physics: const NeverScrollableScrollPhysics(),
                      controller: _pageController,
                      itemBuilder: (context, index) {
                        return SingleChildScrollView(
                          child: Container(
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                              vertical: 30,
                            ),
                            padding: const EdgeInsets.only(
                              top: 12.0,
                              left: 12.0,
                              right: 12.0,
                              bottom: 25,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  ques[index].question.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(
                                        color: AppColors.bgColor,
                                      ),
                                ),
                                const Gap(20),
                                ...List.generate(ques[index].options!.length,
                                    (index1) {
                                  Color getTheRightColor() {
                                    bool isAnswered = quizViewModel.isAnswered;

                                    if (isAnswered) {
                                      if (index1 == quizViewModel.correctAns) {
                                        return Colors.green;
                                      } else if (index1 ==
                                              quizViewModel.selectedAns &&
                                          quizViewModel.selectedAns !=
                                              quizViewModel.correctAns) {
                                        return Colors.red;
                                      }
                                    }
                                    return AppColors.black;
                                  }

                                  IconData getTheRightIcon() {
                                    return getTheRightColor() == Colors.red
                                        ? Icons.close
                                        : Icons.done;
                                  }

                                  return Consumer<QuizViewModel>(builder:
                                      (BuildContext context,
                                          QuizViewModel value, Widget? child) {
                                    return InkWell(
                                      onTap: () {
                                        quizViewModel.checkAns(
                                            ques[index],
                                            index1,
                                            animationController,
                                            _pageController,
                                            context,
                                            ques,
                                            widget.level);
                                      },
                                      child: Container(
                                        margin:
                                            const EdgeInsets.only(top: 12.0),
                                        padding: const EdgeInsets.all(12.0),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: getTheRightColor()),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: AnimatedOpacity(
                                          duration:
                                              const Duration(milliseconds: 500),
                                          opacity:
                                              quizViewModel.isHidden(index1)
                                                  ? 0.0
                                                  : 1.0,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  '${index1 + 1}.${ques[index].options![index1]}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleSmall!
                                                      .copyWith(
                                                        color:
                                                            getTheRightColor(),
                                                      ),
                                                ),
                                              ),
                                              const Gap(10),
                                              Container(
                                                height: 26,
                                                width: 26,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50.0),
                                                  border: Border.all(
                                                    color: getTheRightColor() ==
                                                            Colors.grey
                                                        ? Colors.transparent
                                                        : getTheRightColor(),
                                                  ),
                                                ),
                                                child: getTheRightColor() ==
                                                        AppColors.black
                                                    ? null
                                                    : Icon(getTheRightIcon(),
                                                        size: 16),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  });
                                }),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        child: const Text("Reward"),
                        onPressed: () {
                          quizViewModel.showRewardAdd(
                            ques,
                            _pageController,
                            animationController,
                            context,
                          );
                        }),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
