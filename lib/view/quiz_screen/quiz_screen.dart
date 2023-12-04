import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:quiz_e_book/extension/mediaquery_extension/mediaquery_extension.dart';
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
  @override
  void initState() {
    super.initState();
    context.read<QuizViewModel>().getProducts(context);
    context.read<QuizViewModel>().getQuestions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        title: const Text("Quiz"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Card(
          child: FutureBuilder(
            future: Future.wait([
              context.read<QuizViewModel>().getProducts(context),
              context.read<QuizViewModel>().getQuestions(),
            ]),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Utils.showLoadingSpinner(),
                );
              } else if (snapshot.hasError) {
                // Handle error
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Utils.showLoadingSpinner(),
                );
              } else {
                return Consumer<QuizViewModel>(builder: (context, value, _) {
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.1,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                    ),
                    itemBuilder: (context, index) {
                      final ques = context
                          .read<QuizViewModel>()
                          .findbyLevel(value.getQuestion[index].level!);
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (index == 0) {
                          value.updateQuizLocked(value.getQuiz[0].id!, 0);
                        }
                      });
                      return InkWell(
                        hoverColor: AppColors.bgColor,
                        onTap: () {
                          if (value.getQuiz[index].isLoacked) {
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
                          } else {
                            // Level is unlocked, navigate to the quiz screen
                            String selectedLevel = value.getQuiz[index].level!;
                            if (value
                                .areQuestionsAvailableForLevel(selectedLevel)) {
                              context.push(
                                RouteName.quizAnswerScreen,
                                extra: selectedLevel,
                              );
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('No Questions Available'),
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
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                12.0), // Set your desired border radius
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              color: AppColors.bgColor4.withOpacity(0.3),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12.0),
                                    child: Container(
                                      color: AppColors.white,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                value.getQuiz[index].image!,
                                            height: context.screenheight * .05,
                                            width: context.screenheight * .05,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'Level: ${value.getQuiz[index].level!}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(
                                            color: AppColors.bgColor,
                                            fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '${ques.length.toString()} Quizzes',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(
                                          color: AppColors.bgColor,
                                        ),
                                  )
                                ],
                              ),
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
      ),
    );
  }
}
// GridTile(
//                               footer: GridTileBar(
//                                 backgroundColor: value.getQuiz[index].isLoacked
//                                     ? Colors.black
//                                     : Colors.black87,
//                                 title: Text('Level:-${value.getQuiz[index].level}'),
//                               ),
//                               child: value.getQuiz[index].isLoacked
//                                   ? const Icon(
//                                       Icons.lock,
//                                       size: 50,
//                                     )
//                                   : Image.network(
//                                       value.getQuiz[index].image!,
//                                       fit: BoxFit.cover,
//                                     ),
//                             ),