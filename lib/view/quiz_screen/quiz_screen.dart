import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:quiz_e_book/model/qustion.dart';
import 'package:quiz_e_book/resources/color/app_color.dart';
import 'package:quiz_e_book/resources/routes/route_name/route_name.dart';
import 'package:quiz_e_book/utils/utils.dart';
import 'package:quiz_e_book/viewModel/quiz_view_model/quiz_view_model.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  bool _dataLoaded = false;
  Future<void> fetchData() async {
    context.read<QuizViewModel>().getProducts(context,"");
    await context.read<QuizViewModel>().getQuestions();
    await context.read<QuizViewModel>().getAllUser("");
    setState(() {
      _dataLoaded = true;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_dataLoaded) {
      fetchData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Set<String> unlockedLevelsSet =
        Set<String>.from(context.read<QuizViewModel>().allUnlockedArrays);
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        title: const Text("Selected Quiz"),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<QuizViewModel>().getProducts(context,"");
          // ignore: use_build_context_synchronously
          await context.read<QuizViewModel>().getAllUser("");
          // ignore: use_build_context_synchronously
          await context.read<QuizViewModel>().getQuestions();
          setState(() {});
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: FutureBuilder(
            future: Future.wait([
              context.read<QuizViewModel>().getProducts(context,''),
              context.read<QuizViewModel>().getQuestions(),
              context.read<QuizViewModel>().getAllUser(""),
            ]),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Utils.showLoadingSpinner(),
                );
              } else if (snapshot.hasError) {
                // Handle error
                return const Center(
                  child: Text('Error:'),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Utils.showLoadingSpinner(),
                );
              } else {
                return Consumer<QuizViewModel>(builder: (context, value, _) {
                  return ListView.builder(
                    key: UniqueKey(),
                    itemBuilder: (context, index) {
                      final String level = value.getQuiz[index].level!;
                      final bool isLevelUnlocked =
                          unlockedLevelsSet.contains(level);
                      List<Question> questionsForLevel = value
                          .getQuestionsByLevel(value.getQuiz[index].level!,"");
                      return InkWell(
                          hoverColor: AppColors.bgColor,
                          onTap: () {
                            if (isLevelUnlocked) {
                              // Level is unlocked, navigate to the quiz screen
                              String selectedLevel =
                                  value.getQuiz[index].level!;
                              if (value.areQuestionsAvailableForLevel(
                                  selectedLevel,"")) {
                                context.push(
                                  RouteName.quizAnswerScreen,
                                  extra: selectedLevel,
                                );
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title:
                                        const Text('No Questions Available'),
                                    content: Text(
                                        'There are no questions available for this level ${value.getQuiz[index].level}.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            } else {
                              // Level is locked, show the dialog
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Level Locked'),
                                  content: const Text(
                                      'This level is currently locked.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  6.0), // Set your desired border radius
                              child: Container(
                                  color: Colors.white,
                                  padding: const EdgeInsets.all(4.0),
                                  child: ListTile(
                                    leading: Image.network(
                                      value.getQuiz[index].image!,
                                      height: 30,
                                      width: 30,
                                    ),
                                    title: Text(
                                      'science',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(
                                            color: AppColors.bgColor,
                                            fontWeight: FontWeight.bold,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                    ),
                                  )),
                            ),
                          ));
                    },
                    itemCount: value.getQuiz.length,
                  );
                });
              }
            },
          ),
        ),
      ),
    );
  }
}
