import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:quiz_e_book/admin/viewmodel/get_category_view_model.dart';
import 'package:quiz_e_book/data/response/status.dart';
import 'package:quiz_e_book/resources/color/app_color.dart';
import 'package:quiz_e_book/utils/utils.dart';
import 'package:quiz_e_book/viewModel/quiz_view_model/quiz_view_model.dart';
import 'package:quiz_e_book/widget/button_widget.dart';
import 'package:quiz_e_book/widget/text_form_widget.dart';

class AddQuestionForm extends StatefulWidget {
  const AddQuestionForm({super.key});

  @override
  State<AddQuestionForm> createState() => _AddQuestionFormState();
}

const List<String> items = [
  '1',
  '2',
  '3',
  '4',
];

class _AddQuestionFormState extends State<AddQuestionForm> {
  final TextEditingController levelController = TextEditingController();
  final TextEditingController questionController = TextEditingController();
  final TextEditingController optionsController = TextEditingController();
  final TextEditingController answerController = TextEditingController();
  final _form = GlobalKey<FormState>();
  GetCategoryViewModel getCategoryViewModel = GetCategoryViewModel();

  @override
  void initState() {
    super.initState();
    getCategoryViewModel.getCategory();
  }

  String? dropdownvalue;
  String? categoryValue;

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
                    if (!value.endsWith(',')) {
                      return "Comma is compulsory after each option";
                    }

                    return null;
                  },
                ),
                const Gap(10),
                DropdownButton<String?>(
                    hint: const Text('Select an option'),
                    value: dropdownvalue,
                    elevation: 10,
                    underline: Container(
                      height: 3,
                      color: AppColors.bgColor,
                    ),
                    isExpanded: true,
                    padding: const EdgeInsets.all(8.0),
                    items: [
                      ...items.map((String item) {
                        int internalValue =
                            int.parse(item) - 1; // Adjust the internal value
                        return DropdownMenuItem<String?>(
                          value: internalValue.toString(),
                          child: Text(item),
                        );
                      }),
                    ],
                    onChanged: (value) {
                      setState(() {
                        dropdownvalue = value!;
                      });
                    }),
                const Gap(10),
                ChangeNotifierProvider(
                  create: (context) => getCategoryViewModel,
                  child: Consumer<GetCategoryViewModel>(
                      builder: (context, value, _) {
                    switch (value.apiResponse.status) {
                      case Status.loading:
                        return const Text("Loading...");
                      case Status.error:
                        return Text(value.apiResponse.message!);
                      case Status.completed:
                        return DropdownButton(
                          elevation: 10,
                          underline: Container(
                            height: 3,
                            color: AppColors.bgColor,
                          ),
                          padding: const EdgeInsets.all(8.0),
                          isExpanded: true,
                          value: categoryValue,
                          hint: const Text("Selected Category"),
                          items: value.apiResponse.data!
                              .map((e) => DropdownMenuItem(
                                    value: e.title,
                                    child: Text(e.title!),
                                  ))
                              .toList(),
                          onChanged: (newValue) {
                            setState(() {
                              categoryValue = newValue.toString();
                            });
                          },
                        );
                      default:
                        return const SizedBox.shrink();
                    }
                  }),
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
    List<String> questionOptions = optionsController.text
        .split(',')
        .map((option) => option.trim()) // Trim each option
        .where((option) => option.isNotEmpty)
        .toList();
    if (validate &&
        questionOptions.length == 4 &&
        dropdownvalue != null &&
        categoryValue != null) {
      _form.currentState!.save();

      context
          .read<QuizViewModel>()
          .uploadQuestion(
            DateTime.april,
            questionController.text,
            questionOptions,
            dropdownvalue!,
            levelController.text,
            categoryValue,
            context,
          )
          .then((value) {
        // Clear text field controllers
        levelController.clear();
        questionController.clear();
        optionsController.clear();
        answerController.clear();
        dropdownvalue = null;
        categoryValue = null;
      });
    } else if (dropdownvalue == null) {
      // Handle the case where dropdownvalue is null
      Utils.flushBarErrorMessage(
          "Please select a value from the dropdown", context);
    } else {
      Utils.flushBarErrorMessage("At least add 4 options", context);
    }
  }
}
