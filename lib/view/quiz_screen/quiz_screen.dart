import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:quiz_e_book/resources/routes/route_name/route_name.dart';
import 'package:quiz_e_book/viewModel/quiz_view_model.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quiz"),
        
      ),
      body: Consumer<QuizViewModel>(
        builder: (context, value, child) {
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.5,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
            ),
            itemBuilder: (context, index) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (index == 0) {
                  value.updateQuizLocked(value.getQuiz[0].id, 0);
                }
              });
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: InkWell(
                    onTap: value.getQuiz[index].isLoacked
                        ? null
                        : () {
                            context.push(
                              RouteName.quizAnswerScreen,
                              extra: value.getQuiz[index].level,
                            );
                          },
                    child: GridTile(
                      footer: GridTileBar(
                        backgroundColor: value.getQuiz[index].isLoacked
                            ? Colors.black
                            : Colors.black87,
                        title: Text('Level:-${value.getQuiz[index].level}'),
                      ),
                      child: value.getQuiz[index].isLoacked
                          ? const Icon(
                              Icons.lock,
                              size: 50,
                            )
                          : Image.asset(value.getQuiz[index].image),
                    ),
                  ),
                ),
              );
            },
            itemCount: value.getQuiz.length,
          );
        },
      ),
    );
  }
}
