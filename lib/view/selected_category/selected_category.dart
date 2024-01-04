import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:quiz_e_book/model/qustion.dart';
import 'package:quiz_e_book/resources/routes/route_name/route_name.dart';
import 'package:quiz_e_book/utils/utils.dart';
import 'package:quiz_e_book/viewModel/auth_view_model/auth_view_model.dart';
import 'package:quiz_e_book/viewModel/quiz_view_model/quiz_view_model.dart';
import 'package:quiz_e_book/viewModel/update_level_view_model/update_level_view_model.dart';

class SelectedCategory extends StatefulWidget {
  final String? title;

  const SelectedCategory({
    super.key,
    required this.title,
  });

  @override
  State<SelectedCategory> createState() => _SelectedCategoryState();
}

class _SelectedCategoryState extends State<SelectedCategory> {
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    await context.read<QuizViewModel>().getProducts(context, widget.title!);
    await context.read<QuizViewModel>().getQuestions();
    await context.read<QuizViewModel>().getAllUser(widget.title!);
  }

  @override
  Widget build(BuildContext context) {
    final Set<String> unlockedLevelsSet = Set<String>.from(context
        .read<QuizViewModel>()
        .allUnlockedArrays
        .map((e) => e.toString()));
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Select Level",
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: Colors.white),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<QuizViewModel>().getProducts(context, "");
          // ignore: use_build_context_synchronously
          await context.read<QuizViewModel>().getAllUser(widget.title!);
          // ignore: use_build_context_synchronously
          await context.read<QuizViewModel>().getQuestions();
          setState(() {});
        },
        child: FutureBuilder(
          future: Future.wait([
            context.read<QuizViewModel>().getProducts(context, widget.title!),
            context.read<QuizViewModel>().getQuestions(),
            context.read<QuizViewModel>().getAllUser(widget.title!),
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
            } else if (!snapshot.hasData) {
              return const Center(
                child: Text("No Data Available"),
              );
            } else {
              return Consumer<QuizViewModel>(builder: (context, value, _) {
                return value.getQuiz.isEmpty
                    ? Center(
                        child: Text(
                          "No Data Available!",
                          style:
                              Theme.of(context).textTheme.titleSmall!.copyWith(
                                    color: const Color(0xff030605),
                                    fontWeight: FontWeight.bold,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                        ),
                      )
                    : ListView.builder(
                        itemBuilder: (context, index) {
                          bool isLevelUnlocked = unlockedLevelsSet
                              .contains(value.getQuiz[index].level!);
                          if (index == 0) {
                            if (!context
                                .read<QuizViewModel>()
                                .islevelUnlocked) {
                              AuthViewModel().getUser().then((user) {
                                final body2 = {
                                  "unlocked": [
                                    {
                                      "type": widget.title,
                                      "values": [1]
                                    }
                                  ]
                                };
                                context.read<UpdateLevelViewModel>().updateLevelss(
                                    user.token!, body2, context);
                              });
                            }
                            isLevelUnlocked = true;
                          }
                          return Padding(
                            padding: const EdgeInsets.only(
                              left: 12.0,
                              right: 12.0,
                              bottom: 6.0,
                              top: 5.0,
                            ),
                            child: Card(
                              elevation: 4,
                              child: GestureDetector(
                                onTap: () {
                                  if (isLevelUnlocked || index == 0) {
                                    String selectedLevel =
                                        value.getQuiz[index].level!;
                                    List<Question>? specificQuestion = context
                                        .read<QuizViewModel>()
                                        .getSpecificQuestion(
                                            selectedLevel, widget.title!);
                                    print(
                                        "Selected Level: $selectedLevel, Title: ${widget.title}");
                                    if (specificQuestion != null) {
                                      print(
                                          "Number of Questions: ${specificQuestion.length}");
                                      specificQuestion.forEach((question) {
                                        print("Question: ${question.title}");
                                      });
                                    }

                                    if (value.areQuestionsAvailableForLevel(
                                        selectedLevel, widget.title!)) {
                                      print(specificQuestion!.length);
                                      context.push(
                                        RouteName.quizAnswerScreen,
                                        extra: {
                                          'level': selectedLevel,
                                          'title': widget.title,
                                          "question": specificQuestion,
                                        },
                                      );
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text(
                                              'No Questions Available'),
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
                                child: ClipRRect(
                                  // Set your desired border radius
                                  child: Container(
                                      color: const Color(0xffffffff),
                                      padding: const EdgeInsets.all(4.0),
                                      child: ListTile(
                                        leading: Consumer<QuizViewModel>(
                                          builder: (context, value, _) =>
                                              Container(
                                            width: 50,
                                            height: 50,
                                            color: const Color(0xffedeeee),
                                            child: isLevelUnlocked
                                                ? const Icon(
                                                    Icons.lock_open_outlined)
                                                : const Icon(Icons.lock),
                                          ),
                                        ),
                                        title: Text(
                                          "Level: ${value.getQuiz[index].level!}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall!
                                              .copyWith(
                                                color: const Color(0xff030605),
                                                fontWeight: FontWeight.bold,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                        ),
                                        trailing: const Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          color: Colors.black,
                                          size: 20,
                                        ),
                                      )),
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: value.getQuiz.length,
                      );
              });
            }
          },
        ),
      ),
    );
  }
}
