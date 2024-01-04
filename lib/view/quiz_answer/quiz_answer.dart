import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gap/gap.dart';
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
  final Map<String, dynamic> data;

  const QuizAnswer({super.key, required this.data});

  @override
  State<QuizAnswer> createState() => _QuizAnswerState();
}

class _QuizAnswerState extends State<QuizAnswer> with TickerProviderStateMixin {
  late Animation animation;
  late AnimationController animationController;
  List<Animation<Offset>>? slideAnimation;
  late AnimationController optionControllers;
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
    context.read<QuizViewModel>().createRewardAdd();

    super.initState();
    fetchData();
    getUserData()
        .then((value) => {getAllUsers.getUserData(value.token.toString())});

    _pageController = PageController();
    // * slide Animation
    optionControllers = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    optionControllers.forward();
    // * animation controller

    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 25));
    animation = Tween(begin: 0.0, end: 25.0).animate(animationController)
      ..addListener(() {
        setState(() {});
      });
    animationController.forward().whenComplete(() {
      final ques = context
          .read<QuizViewModel>()
          .getQuestion
          .where((e) =>
              e.level == widget.data["level"] &&
              e.title == widget.data["title"])
          .toList();
      context.read<QuizViewModel>().nextQuestion(_pageController,
          animationController, context, ques, widget.data["title"]);
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    optionControllers.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final quizViewModel = context.read<QuizViewModel>();

    return Scaffold(
        extendBody: true,
        backgroundColor: const Color(0xffeeeeee),
        appBar: AppBar(
          elevation: 0,
          title: Text(
            "Level : ${widget.data["level"]}",
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Colors.white),
          ),
          backgroundColor: const Color(0xff454fb9),
        ),
        body: WillPopScope(
          onWillPop: () async {
            quizViewModel.updateTheQnNum(0);
            quizViewModel.isHiddenRemove();
            return true;
          },
          child: SingleChildScrollView(
            child: SizedBox(
              height: context.screenheight -
                  MediaQuery.paddingOf(context).top -
                  MediaQuery.paddingOf(context).bottom -
                  AppBar().preferredSize.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    width: double.infinity,
                    color: const Color(0xffffffff),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          height: 50,
                          width: 50,
                          child: CircularProgressIndicator(
                            value: animation.value / 25.0,
                            strokeCap: StrokeCap.round,
                            color: const Color(0xff497486),
                            backgroundColor: const Color(0xffd8d8d8),
                            strokeWidth: 5.0,
                          ),
                        ),
                        Text(
                          '${(animation.value).toInt()}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff497486),
                          ),
                        )
                      ],
                    ),
                  ),
                  const Gap(20),
                  Expanded(
                    child: PageView.builder(
                      itemCount: widget.data["question"].length,
                      onPageChanged: quizViewModel.updateTheQnNum,
                      physics: const NeverScrollableScrollPhysics(),
                      controller: _pageController,
                      itemBuilder: (context, index) {
                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 12.0,
                                  vertical: 30,
                                ),
                                padding: const EdgeInsets.only(
                                  right: 12.0,
                                  bottom: 25,
                                ),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8.0)),
                                child: Column(
                                  children: [
                                    Consumer<QuizViewModel>(
                                      builder: (context, value, _) => Align(
                                        alignment: Alignment.topLeft,
                                        child: Container(
                                          alignment: Alignment.topLeft,
                                          height: 50,
                                          width: 50,
                                          decoration: const BoxDecoration(
                                              color: Color(0xff306c84),
                                              borderRadius: BorderRadius.only(
                                                bottomRight:
                                                    Radius.circular(15.0),
                                                topLeft: Radius.circular(8.0),
                                              )),
                                          child: Center(
                                              child: Text(
                                            value.questionNumber.toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelMedium!
                                                .copyWith(
                                                  color: AppColors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          )),
                                        ),
                                      ),
                                    ),
                                    const Gap(10),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        widget.data["question"][index].question
                                            .toString(),
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .copyWith(
                                                color: AppColors.black,
                                                fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemBuilder: (context, index1) {
                                      slideAnimation = List.generate(
                                          widget.data["question"][index]
                                              .options!.length,
                                          (index) => Tween(
                                                  begin: const Offset(-1, 1),
                                                  end: Offset.zero)
                                              .animate(CurvedAnimation(
                                                  parent: optionControllers,
                                                  curve: Interval(
                                                      index * (1 / 8),
                                                      1)))).toList();

                                      Color getTheRightColor() {
                                        bool isAnswered =
                                            quizViewModel.isAnswered;

                                        if (isAnswered) {
                                          if (index1 ==
                                              quizViewModel.correctAns) {
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
                                              QuizViewModel value,
                                              Widget? child) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            right: 12.0,
                                            left: 12.0,
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              quizViewModel.checkAns(
                                                widget.data["question"][index],
                                                index1,
                                                animationController,
                                                _pageController,
                                                context,
                                                widget.data["question"],
                                                widget.data["level"],
                                                widget.data["title"],
                                              );
                                            },
                                            child: SlideTransition(
                                              position: slideAnimation![index1],
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                    top: 12.0),
                                                padding:
                                                    const EdgeInsets.all(12.0),
                                                decoration: BoxDecoration(
                                                  color: AppColors.white,
                                                  border: Border.all(
                                                      color:
                                                          getTheRightColor()),
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                child: AnimatedOpacity(
                                                  duration: const Duration(
                                                      milliseconds: 500),
                                                  opacity: quizViewModel
                                                          .isHidden(index1)
                                                      ? 0.0
                                                      : 1.0,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              width: 30,
                                                              height: 30,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            6),
                                                                color: const Color(
                                                                    0xff306c84),
                                                              ),
                                                              child: Center(
                                                                child: Text(
                                                                  String.fromCharCode(
                                                                      'A'.codeUnitAt(
                                                                              0) +
                                                                          index1),
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .titleMedium!
                                                                      .copyWith(
                                                                        color: AppColors
                                                                            .white,
                                                                      ),
                                                                ),
                                                              ),
                                                            ),
                                                            const Gap(10),
                                                            Text(
                                                              widget
                                                                  .data[
                                                                      "question"]
                                                                      [index]
                                                                  .options![index1],
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .titleSmall!
                                                                  .copyWith(
                                                                    color:
                                                                        getTheRightColor(),
                                                                  ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const Gap(10),
                                                      Container(
                                                        height: 26,
                                                        width: 26,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      50.0),
                                                          border: Border.all(
                                                            color: getTheRightColor() ==
                                                                    Colors.grey
                                                                ? Colors
                                                                    .transparent
                                                                : getTheRightColor(),
                                                          ),
                                                        ),
                                                        child: getTheRightColor() ==
                                                                AppColors.black
                                                            ? null
                                                            : Icon(
                                                                getTheRightIcon(),
                                                                size: 16),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      });
                                    },
                                    itemCount: widget.data["question"][index]
                                        .options!.length,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Container(
          height: kToolbarHeight,
          width: double.infinity,
          color: AppColors.white,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            GestureDetector(
              onTap: () {
                quizViewModel.showRewardAdd(
                  widget.data["question"],
                  _pageController,
                  animationController,
                  context,
                );
              },
              child: quizViewModel.isAdLoading
                  ? const SpinKitCircle(
                      color: AppColors.bgColor,
                      size: 20,
                    )
                  : Image.asset(
                      "assets/images/3284076.png",
                      width: 30,
                      height: 30,
                    ),
            ),
            const Gap(10),
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
                            if (score > 10) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Confirm Skip'),
                                  content: const Text(
                                      'Are you sure you want to skip? Your score will be decreased by 10 points.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        // Close the dialog
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        // Close the dialog
                                        Navigator.pop(context);

                                        // Perform the skip operation
                                        AuthViewModel()
                                            .getUser()
                                            .then((value2) {
                                          int scoreToDecrement = 10;
                                          final body = {
                                            "decrementValue":
                                                scoreToDecrement.toString(),
                                          };
                                          context
                                              .read<ScoreViewModel>()
                                              .updateScore(
                                            AppUrl.decrement,
                                            body,
                                            context,
                                            headers: {
                                              "Authorization":
                                                  "Bearer ${value2.token}",
                                            },
                                          ).then((value) {
                                            // Perform any additional actions after decrementing the score
                                            quizViewModel.nextQuestion(
                                                _pageController,
                                                animationController,
                                                context,
                                                widget.data["question"],
                                                widget.data["title"]);
                                          });
                                        });
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Insufficient Score'),
                                  content: const Text(
                                      'Your score is not sufficient to skip.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        // Close the dialog
                                        Navigator.pop(context);
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                          child: const Icon(
                            Icons.skip_next_outlined,
                            color: Color(0xff286c76),
                            size: 30,
                          ));

                    default:
                      return const SizedBox.shrink();
                  }
                },
              ),
            )
          ]),
        ));
  }
}
