import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:quiz_e_book/admin/viewmodel/get_category_view_model.dart';
import 'package:quiz_e_book/data/response/status.dart';
import 'package:quiz_e_book/model/login_model.dart';
import 'package:quiz_e_book/model/quiz_model.dart';
import 'package:quiz_e_book/resources/color/app_color.dart';
import 'package:quiz_e_book/utils/utils.dart';

import 'package:quiz_e_book/viewModel/auth_view_model/auth_view_model.dart';
import 'package:quiz_e_book/viewModel/quiz_view_model/quiz_view_model.dart';
import 'package:quiz_e_book/widget/button_widget.dart';
import 'package:quiz_e_book/widget/text_form_widget.dart';

class UploadQuiz extends StatefulWidget {
  const UploadQuiz({super.key});

  @override
  State<UploadQuiz> createState() => _UploadQuizState();
}

class _UploadQuizState extends State<UploadQuiz> {
  Future<LoginData> getUserData() => AuthViewModel().getUser();
  GetCategoryViewModel getCategoryViewModel = GetCategoryViewModel();

  final _form = GlobalKey<FormState>();
  String? level;
  String? dropdownvalue;

  @override
  void initState() {
    super.initState();
    getCategoryViewModel.getCategory();
  }

  void save() async {
    final validate = _form.currentState!.validate();
    if (!validate) return;
    if (validate && dropdownvalue != null) {
      _form.currentState!.save();
      getUserData().then((value) {
        // Check if quiz with the same title and level already exists
        if (!context
            .read<QuizViewModel>()
            .quizAlreadyExists(title: dropdownvalue!, level: level!)) {
          context
              .read<QuizViewModel>()
              .uploadQuiz(context, level!, value.token!, true, dropdownvalue!);
        } else {
          // Show an error message or handle the case where the quiz already exists
          // For example, you can show a dialog or print a message
          Utils.flushBarErrorMessage(
              "Quiz with the same title and level already exists", context);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload Quiz Level"),
      ),
      body: Form(
        key: _form,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Textformwidget(
                  keyboardType: TextInputType.number,
                  onSave: (value) {
                    level = value;
                  },
                  title: "Level ",
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
                  }),
              const Gap(20),
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
                        value: dropdownvalue,
                        hint: const Text("Selected Category"),
                        items: value.apiResponse.data!
                            .map((e) => DropdownMenuItem(
                                  value: e.title,
                                  child: Text(e.title!),
                                ))
                            .toList(),
                        onChanged: (newValue) {
                          setState(() {
                            dropdownvalue = newValue.toString();
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
                    isLoading: value.isLoading,
                    text: "Submit",
                    onTap: () {
                      save();
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
