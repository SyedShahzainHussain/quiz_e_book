import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:quiz_e_book/extension/mediaquery_extension/mediaquery_extension.dart';
import 'package:quiz_e_book/model/qustion.dart';

import 'package:quiz_e_book/resources/color/app_color.dart';
import 'package:quiz_e_book/viewModel/quiz_view_model/quiz_view_model.dart';
import 'package:quiz_e_book/widget/button_widget.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class QuizAnswer extends StatefulWidget {
  final String level;

  const QuizAnswer({Key? key, required this.level});

  @override
  State<QuizAnswer> createState() => _QuizAnswerState();
}

class _QuizAnswerState extends State<QuizAnswer>
    with SingleTickerProviderStateMixin {
  late Animation animation;
  late AnimationController animationController;
  late PageController _pageController;

  // ! advertising
  RewardedAd? rewardedAd;
  // InterstitialAd? interstitialAd;

  void createRewardAdd() {
    RewardedAd.load(
        adUnitId: 'ca-app-pub-3940256099942544/5224354917',
        request:
            const AdRequest(contentUrl: "https://zeecodercraft-a5508.web.app/"),
        rewardedAdLoadCallback: RewardedAdLoadCallback(onAdLoaded: (ad) {
          rewardedAd = ad;
          setState(() {});
        }, onAdFailedToLoad: (error) {
          rewardedAd = null;
          setState(() {});
          print("Failed $error");
        }));
  }

  void _showRewardAdd(List<Question> ques) {
    if (rewardedAd != null) {
      rewardedAd!.fullScreenContentCallback =
          FullScreenContentCallback(onAdDismissedFullScreenContent: (ad) {
        print("succes");
        createRewardAdd();
      }, onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        createRewardAdd();
      });
      rewardedAd!.show(
          onUserEarnedReward: (ad, reward) => setState(() {
                context.read<QuizViewModel>().rewardButtonPressed(
                    _pageController, animationController, context, ques);
              }));
      rewardedAd = null;
    }
  }

  @override
  void initState() {
    super.initState();
    createRewardAdd();
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
    final quizViewModel = context.read<QuizViewModel>();
    // ! checking the level is matach then show that question
    final ques = context.read<QuizViewModel>().findbyLevel(widget.level);
    //
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {
              quizViewModel.nextQuestion(
                _pageController,
                animationController,
                context,
                ques,
              );
            },
            child: const Text("Skip", style: TextStyle(color: AppColors.white)),
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
                        borderRadius: BorderRadius.circular(50)),
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
                        return Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 30),
                          padding: const EdgeInsets.only(
                              top: 12.0, left: 12.0, right: 12.0, bottom: 25),
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

                                bool isHidden(int indexToCheck) {
                                  return quizViewModel.hiddenIncorrectIndices
                                      .contains(indexToCheck);
                                }

                                return Consumer<QuizViewModel>(builder:
                                    (BuildContext context, QuizViewModel value,
                                        Widget? child) {
                                  return InkWell(
                                    onTap: () {
                                      quizViewModel.checkAns(
                                          ques[index],
                                          index1,
                                          animationController,
                                          _pageController,
                                          context,
                                          ques);
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(top: 12.0),
                                      padding: const EdgeInsets.all(12.0),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: getTheRightColor()),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: AnimatedOpacity(
                                        duration:
                                            const Duration(milliseconds: 500),
                                        opacity: isHidden(index1) ? 0.0 : 1.0,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${index1 + 1}.${ques[index].options![index1]}',
                                              style: TextStyle(
                                                color: getTheRightColor(),
                                                fontSize: 16,
                                              ),
                                            ),
                                            Container(
                                              height: 26,
                                              width: 26,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(50.0),
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
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        child: const Text("Reward"),
                        onPressed: () {
                          //   context
                          //       .read<QuizViewModel>()
                          //       .rewardButtonPressed(_pageController,
                          //           animationController, context, ques);

                          //   // Hide the selected indices when the reward button is pressed
                          //   int firstHiddenIndex =
                          //       quizViewModel.hiddenIncorrectIndices[0];
                          //   int secondHiddenIndex =
                          //       quizViewModel.hiddenIncorrectIndices[1];

                          //   // Now, you can hide or perform any other action with these indices
                          //   print(
                          //       "Hide indices: $firstHiddenIndex, $secondHiddenIndex");
                          _showRewardAdd(ques);
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
