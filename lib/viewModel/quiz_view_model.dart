import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_e_book/model/quiz_model.dart';
import 'package:quiz_e_book/model/qustion.dart';
import 'package:quiz_e_book/resources/routes/route_name/route_name.dart';

class QuizViewModel with ChangeNotifier {
  List<Question> get getQuestion => [..._question];

  final List<Question> _question = [
    Question(
      level: "2",
      answer: 1,
      id: 1,
      options: ['Apple', 'Google', 'Facebook', 'Microsoft'],
      question:
          "Flutter is an open-source UI software development kit created by ______",
    ),
    Question(
      level: "1",
      id: 2,
      question: "When google release Flutter.",
      options: ['Jun 2017', 'Jun 2017', 'May 2017', 'May 2018'],
      answer: 2,
    ),
    Question(
      level: "1",
      id: 3,
      question: "A memory location that holds a single letter or number.",
      options: ['Double', 'Int', 'Char', 'Word'],
      answer: 3,
    ),
    Question(
      level: "1",
      id: 4,
      question: "What command do you use to output data to the screen?",
      options: ['Cin', 'Count>>', 'Cout', 'Output>>'],
      answer: 2,
    ),
  ];

  List<Quiz> get getQuiz => [..._quiz];
  final List<Quiz> _quiz = [
    Quiz(
      id: DateTime.now().toIso8601String(),
      image: "assets/images/quiz.jpg",
      level: "1",
      isLoacked: true,
    ),
    Quiz(
      id: DateTime.now().toIso8601String(),
      image: "assets/images/quiz.jpg",
      level: "2",
      isLoacked: true,
    ),
  ];

  void updateQuizLocked(String quizId, int length) {
    if (_quiz[length].isLoacked == true) {
      _quiz[length].isLoacked = false;
      notifyListeners();
    } else {
      return;
    }
  }

  bool _isAnswered = false;
  bool get isAnswered => _isAnswered;

  int? _correctAns;
  int get correctAns => _correctAns!;

  int? _selectedAns;
  int get selectedAns => _selectedAns!;

  int _numOfCorrectAns = 0;
  int get numOfCorrectAns => _numOfCorrectAns;

  int _questionNumber = 1;
  int get questionNumber => _questionNumber;
  int _questiionLength = 1;
  int get questiionLength => _questiionLength;

  void incrementQuestionNumber() {
    _questionNumber++;
    notifyListeners();
  }

  void checkAns(
    Question question,
    int selectedIndex,
    AnimationController animationController,
    PageController pageController,
    BuildContext context,
    List<Question> ques,
  ) {
    // because once user press any option then it will run
    _isAnswered = true;
    _correctAns = question.answer;
    _selectedAns = selectedIndex;

    if (_correctAns == _selectedAns) _numOfCorrectAns++;
    // It will stop the counter
    animationController.stop();
    notifyListeners();

    // Once user select an ans after 3s it will go to the next qn
    Future.delayed(const Duration(seconds: 3), () {
      nextQuestion(pageController, animationController, context, ques);
    });
  }

  void nextQuestion(
      PageController pageController,
      AnimationController animationController,
      BuildContext context,
      List<Question> ques) {
    if (_questionNumber != ques.length) {
      _questiionLength = ques.length;
      _isAnswered = false;
      pageController.nextPage(
          duration: const Duration(milliseconds: 250), curve: Curves.ease);

      animationController.reset();
      animationController.forward().whenComplete(() =>
          nextQuestion(pageController, animationController, context, ques));
    } else {
      GoRouter.of(context).push(RouteName.scoreScreen);
      _questionNumber = 1;
      _isAnswered = false;
    }
  }

  void updateTheQnNum(int index) {
    _questionNumber = index + 1;
    notifyListeners();
  }
}
