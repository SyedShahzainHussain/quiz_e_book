import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:quiz_e_book/model/qustion.dart';
import 'package:quiz_e_book/viewModel/quiz_view_model/quiz_view_model.dart';
import 'package:quiz_e_book/widget/button_widget.dart';
import 'package:quiz_e_book/widget/text_form_widget.dart';

class AddQuestionForm extends StatefulWidget {
  const AddQuestionForm({super.key});

  @override
  State<AddQuestionForm> createState() => _AddQuestionFormState();
}

class _AddQuestionFormState extends State<AddQuestionForm> {
  final TextEditingController levelController = TextEditingController();
  final TextEditingController questionController = TextEditingController();
  final TextEditingController optionsController = TextEditingController();
  final TextEditingController answerController = TextEditingController();
  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Question"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _form,
            child: Column(
              children: [
                Textformwidget(
                  keyboardType: TextInputType.number,
                  controller: levelController,
                  title: 'Level',
                  onSave: (value) {
                    levelController.text = value!;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter the level number";
                    }
                    try {
                      int level = int.parse(value);
                      // Check if the number is negative or zero
                      if (level <= 0) {
                        return "Enter a positive level number start from 1";
                      }
                    } catch (e) {
                      return "Enter a valid number";
                    }
                    return null;
                  },
                ),
                const Gap(10),
                Textformwidget(
                  controller: questionController,
                  title: 'Question',
                  onSave: (value) {
                    questionController.text = value!;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter a valid question";
                    }
                    return null;
                  },
                ),
                const Gap(10),
                Textformwidget(
                  controller: optionsController,
                  title: 'Options (comma-separated)',
                  onSave: (value) {
                    optionsController.text = value!;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter a valid option with comma";
                    }
                    if (!value.endsWith(',') ) {
                      return "Comma is compulsory after each option";
                    }

                    return null;
                  },
                ),
                const Gap(10),
                Textformwidget(
                  keyboardType: TextInputType.number,
                  controller: answerController,
                  title: 'Answer Index',
                  onSave: (value) {
                    answerController.text = value!;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter a answer number";
                    }
                    try {
                      int level = int.parse(value);
                      // Check if the number is negative or zero
                      if (level < 0) {
                        return "Enter a positive level number start from 0";
                      }
                    } catch (e) {
                      return "Enter a valid number";
                    }
                    return null;
                  },
                ),
                const Gap(10),
                Consumer<QuizViewModel>(
                  builder: (context, value, _) => Buttonwidget(
                    isLoading: value.isLoading2,
                    text: "Add Question",
                    onTap: () {
                      addQuestion();
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void addQuestion() {
    final validate = _form.currentState!.validate();
    if (!validate) return;
    if (validate) {
      _form.currentState!.save();

      List<String> questionOptions = optionsController.text
          .split(',')
          .map((option) => option.trim()) // Trim each option
          .where((option) => option.isNotEmpty)
          .toList();

      Question newQuestion = Question(
        level: levelController.text,
        question: questionController.text,
        options: questionOptions,
        answer: int.tryParse(answerController.text),
        id: DateTime.now().second, // Assign a unique ID based on your logic
      );

      context.read<QuizViewModel>().uploadQuestion(
          newQuestion.id!,
          newQuestion.question,
          newQuestion.options!,
          newQuestion.answer!,
          newQuestion.level,
          context);

      // Clear text field controllers
      levelController.clear();
      questionController.clear();
      optionsController.clear();
      answerController.clear();
    }
  }
}
