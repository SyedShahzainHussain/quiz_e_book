import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_e_book/firebase/firebase_storage/firebase_storeage.dart';
import 'package:quiz_e_book/model/quiz_model.dart';
import 'package:quiz_e_book/model/qustion.dart';
import 'package:quiz_e_book/resources/routes/route_name/route_name.dart';
import 'package:quiz_e_book/utils/utils.dart';

class QuizViewModel with ChangeNotifier {
  List<Question> get getQuestion => [..._question];
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  bool _isLoading = false;
  get isLoading => _isLoading;

  setLoading(loading) {
    _isLoading = loading;
    notifyListeners();
  }

  bool _isLoading2 = false;
  get isLoading2 => _isLoading2;

  setLoading2(loading) {
    _isLoading2 = loading;
    notifyListeners();
  }

  List<Question> _question = [];

  final List<int> _unlockedLevels = [1]; // List to track unlocked levels

  List<int> get unlockedLevels => _unlockedLevels;

  void unlockNextLevel() {
    int nextLevel = _unlockedLevels.isNotEmpty
        ? _unlockedLevels.first + 1
        : 1; // Unlock the next level
    if (nextLevel <= _quiz.length) {
      // Update the isLoacked status for the unlocked level
      _quiz[nextLevel - 1].isLoacked = false;

      // Add the unlocked level to the list
      _unlockedLevels.add(nextLevel);

      String? quizId = _quiz[nextLevel - 1].id;
      firebaseFirestore
          .collection('quiz')
          .doc(quizId)
          .update({'isLoacked': false}).then((_) {
        // Add the unlocked level to the list
        _unlockedLevels.add(nextLevel);

        notifyListeners();
      }).catchError((error) {
        if (kDebugMode) {
          print("Error updating isLocked status in Firebase: $error");
        }
      });
    }
  }

  List<int> hiddenIncorrectIndices = [];
  void rewardButtonPressed(
    PageController pageController,
    AnimationController animationController,
    BuildContext context,
    List<Question> ques,
  ) {
    if (_isAnswered) {
      // If the current question is already answered, return
      return;
    }

    // Get the current question index
    int currentIndex = pageController.page?.round() ?? 0;

    // Get the current question
    Question currentQuestion = ques[currentIndex];

    // Find the indices of the incorrect options
    List<int> incorrectIndices = [];
    for (int i = 0; i < currentQuestion.options!.length; i++) {
      if (i != currentQuestion.answer) {
        incorrectIndices.add(i);
      }
    }

    // Shuffle the incorrectIndices array
    incorrectIndices.shuffle();

    // Hide the first two elements from the shuffled array
    hiddenIncorrectIndices = [
      incorrectIndices[0],
      incorrectIndices[1],
    ];

    notifyListeners();
  }

// * find by level
  List<Question> findbyLevel(String level) {
    return getQuestion.where((e) => e.level == level).toList();
  }

  List<Quiz> get getQuiz => [..._quiz];
  List<Quiz> _quiz = [];

  Future<void> uploadQuestion(
    int id,
    String? question,
    List<String> options,
    int answer,
    String? level,
    BuildContext context,
  ) async {
    setLoading2(true);
    try {
      final questions = Question(
        answer: answer,
        id: id,
        question: question,
        level: level,
        options: options,
      );
      firebaseFirestore
          .collection('question')
          .doc(id.toString())
          .set(questions.toJson())
          .then((value) {
        setLoading2(false);
      });
    } catch (e) {
      setLoading2(false);
      Utils.flushBarErrorMessage(e.toString(), context);
    }
  }

  Future<void> getQuestions() async {
    try {
      QuerySnapshot snapshot =
          await firebaseFirestore.collection("question").get();
      List<Question> questions = [];
      for (var docs in snapshot.docs) {
        Map<String, dynamic> data = docs.data() as Map<String, dynamic>;
        Question question = Question.fromJson(data);
        questions.add(question);
      }
      _question = questions;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching quiz data: $e");
      }
    }
  }

  Future<void> getProducts() async {
    try {
      QuerySnapshot snapshot = await firebaseFirestore.collection("quiz").get();
      List<Quiz> quizs = [];
      for (var docs in snapshot.docs) {
        Map<String, dynamic> data = docs.data() as Map<String, dynamic>;
        Quiz quiz = Quiz.fromJson(data);
        quizs.add(quiz);
      }
      _quiz = quizs;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching quiz data: $e");
      }
    }
  }

  Future<void> uploadImageToFirebase(
      File? image, BuildContext context, String level) async {
    setLoading(true);
    try {
      // Check if a quiz with the same level already exists
      QuerySnapshot querySnapshot = await firebaseFirestore
          .collection('quiz')
          .where('level', isEqualTo: level)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setLoading(false);
        // ignore: use_build_context_synchronously
        Utils.flushBarErrorMessage(
          "Quiz level already exists. Choose a different level.",
          context,
        );
        return;
      }
      // ignore: use_build_context_synchronously
      StorageModel()
          .uploadImage("Quiz", image!, context, "Image")
          .then((value) {
        final quiz = Quiz(
            id: DateTime.now().toIso8601String(),
            image: value!,
            level: level,
            isLoacked: true);

        firebaseFirestore
            .collection('quiz')
            .doc(quiz.id)
            .set(quiz.toJson())
            .then((value) {
          setLoading(false);
          context.go(RouteName.homeScreen);
          Future.delayed(const Duration(seconds: 2), () {
            Utils.flushBarErrorMessage("Quiz level Upload", context);
          });
        }).onError((error, stackTrace) {
          setLoading(false);
        });
      });
    } catch (e) {
      setLoading(false);
      print("Error checking duplicate levels: $e");
    }
  }

  void updateQuizLocked(String quizId, int length) {
    if (_quiz[length].isLoacked == true) {
      _quiz[length].isLoacked = false;
      firebaseFirestore
          .collection('quiz')
          .doc(quizId)
          .update({'isLoacked': false});
      notifyListeners();
    } else {
      return;
    }
  }

  bool areQuestionsAvailableForLevel(String level) {
    return getQuestion.any((question) => question.level == level);
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

  void resetcorrectAns() {
    _numOfCorrectAns = 0;
    _questiionLength = 1;
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
    Future.delayed(const Duration(seconds: 1), () {
      nextQuestion(
        pageController,
        animationController,
        context,
        ques,
      );
    });
    animationController.forward().whenComplete(() => nextQuestion(
          pageController,
          animationController,
          context,
          ques,
        ));
  }

  void nextQuestion(
    PageController pageController,
    AnimationController animationController,
    BuildContext context,
    List<Question> ques,
  ) {
    if (_questionNumber != ques.length) {
      hiddenIncorrectIndices = [];
      _questiionLength = ques.length;
      _isAnswered = false;
      pageController.nextPage(
          duration: const Duration(milliseconds: 150), curve: Curves.ease);

      animationController.reset();
      animationController.forward().whenComplete(() => nextQuestion(
            pageController,
            animationController,
            context,
            ques,
          ));
    } else {
      GoRouter.of(context).push(RouteName.scoreScreen);
      hiddenIncorrectIndices = [];
      _questionNumber = 1;
      _isAnswered = false;
    }
    notifyListeners();
  }

  void updateTheQnNum(int index) {
    _questionNumber = index + 1;
    notifyListeners();
  }
}
