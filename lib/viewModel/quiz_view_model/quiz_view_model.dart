import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart';
import 'package:quiz_e_book/model/login_model.dart';
import 'package:quiz_e_book/model/quiz_model.dart';
import 'package:quiz_e_book/model/qustion.dart';
import 'package:quiz_e_book/model/users.dart';
import 'package:quiz_e_book/repositories/quiz_repo/quiz_repository.dart';
import 'package:quiz_e_book/resources/routes/route_name/route_name.dart';
import 'package:quiz_e_book/resources/urls/app_url.dart';
import 'package:quiz_e_book/utils/utils.dart';
import 'package:quiz_e_book/viewModel/auth_view_model/auth_view_model.dart';

class QuizViewModel with ChangeNotifier {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  Future<LoginData> getUserData() => AuthViewModel().getUser();

  String? _token;
  String? get token => _token;

  getToken() {
    getUserData().then((value) {
      _token = value.token;
      notifyListeners();
    });
  }

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

  List<Users> _users = [];
  List<Users> get getUsers => _users;
  List<dynamic> _allUnlockedArrays = [];
  List<dynamic> get allUnlockedArrays => _allUnlockedArrays;
  bool _isLevelUnlocked = false;
  get islevelUnlocked => _isLevelUnlocked;
  Future<void> getAllUser(String type) async {
    try {
      final value = await getUserData();

      final user =
          await QuizRepository().getSIngleData(value.token!, value.sId!);

      if (user['unlocked'] != null) {
        List<dynamic> unlockedLevels = user['unlocked']!;

        // Add the unlockedLevels to _allUnlockedArrays
        _allUnlockedArrays.clear();
        for (var unlockedLevel in unlockedLevels) {
          // Check if the type is "Math"
          if (unlockedLevel['type'] == type) {
            if (unlockedLevel['values'].contains(1)) {
              _isLevelUnlocked = true;
            }
            // Add the values of the "Math" type to _allUnlockedArrays
            _allUnlockedArrays.addAll(unlockedLevel['values']);
            break; // Break the loop once you find the desired type
          }
        }

        // Optionally, you can also update _users with the user

        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching quiz data: $e");
      }
    }
  }

  // * quiz question

  List<Question> _question = [];
  List<Question> get getQuestion => _question;

  Future<void> uploadQuestion(
    int? id,
    String? question,
    List<String> options,
    String answer,
    String? level,
    String? title,
    BuildContext context,
  ) async {
    setLoading2(true);
    AuthViewModel().getUser().then((value) async {
      try {
        var body = {
          "level": level,
          "id": id.toString(),
          "question": question,
          "options": options,
          "answer": answer.toString(),
          "title": title.toString(),
        };

        String bodyAsString = json.encode(body);

        final response = await post(
          Uri.parse(AppUrl.createQuestion),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${value.token}',
          },
          body: bodyAsString,
        );

        if (response.statusCode == 201) {
          setLoading2(false);
          Utils.flushBarErrorMessage(
            "Question Created Successfully",
            context,
          );
          Future.delayed(const Duration(seconds: 1), () {
            context.go(RouteName.homeScreen);
          });
          if (kDebugMode) {
            print(" success ${response.body}");
          }
        } else {
          throw Exception('Failed to upload question');
        }
      } catch (e) {
        setLoading2(false);
        Utils.flushBarErrorMessage(e.toString(), context);
      }
    });
  }

  Future<void> getQuestions() async {
    try {
      final snapshot = await QuizRepository().getQuestionData(token!);
      List<Question> question = [];

      for (var docs in snapshot) {
        Question questions = Question.fromJson(docs.toJson());
        question.add(questions);
      }

      // Convert level strings to integers for correct sorting
      question
          .sort((b, a) => int.parse(b.level!).compareTo(int.parse(a.level!)));

      _question = question;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching quiz data: $e");
      }
    }
  }

  // Inside QuizViewModel class
  List<Question>? getSpecificQuestion(String level, String title) {
    // Add your logic to get the specific question
    return getQuestionsByLevel(level, title);
  }

  List<Question> getQuestionsByLevel(String level, String title) {
    var result = _question
        .where((question) => question.level == level && question.title == title)
        .toList();
    return result;
  }
  // * quiz level

  List<Quiz> get getQuiz => [..._quiz];

  List<Quiz> _quiz = [];

  // checking the level is already exits
  bool quizAlreadyExists({required String title, required String level}) {
    // Assuming _quiz is a list of quizzes fetched previously
    for (Quiz quiz in _quiz) {
      if (quiz.title == title && quiz.level == level) {
        return true;
      }
    }
    return false;
  }

  Future<void> getProducts(BuildContext context, String title) async {
    try {
      final snapshot = await QuizRepository().getQuizData(token!, title);
      List<Quiz> quizs = [];
      for (var docs in snapshot) {
        Quiz quiz = Quiz.fromJson(docs.toJson());
        quizs.add(quiz);
      }
      _quiz = quizs;
      notifyListeners();
    } catch (e) {
      // ignore: use_build_context_synchronously
      showDialog(
          context: context,
          builder: (context) {
            return Center(
                child: AlertDialog(
              title: const Text("Token Expire"),
              content: const Text("You have to login again!"),
              actions: [
                TextButton(
                  onPressed: () {
                    AuthViewModel()
                        .remove()
                        .then((value) => context.go(RouteName.loginScreen));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    child: const Text("Login"),
                  ),
                ),
              ],
            ));
          });
    }
  }

  // upload quiz

  Future<void> uploadQuiz(
    BuildContext context,
    String level,
    String token,
    bool isTrue,
    String title,
  ) async {
    setLoading(true);
    AuthViewModel().getUser().then((value) async {
      try {
        var body = {
          "level": level,
          "isLoacked": isTrue.toString(),
          "title": title
        };
        String bodyAsString = json.encode(body);
        final response = await post(
          Uri.parse(AppUrl.createQuiz),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${value.token}',
          },
          body: bodyAsString,
        );
        if (response.statusCode == 201) {
          setLoading(false);
          Utils.flushBarErrorMessage(
            "Quiz Created Successfully",
            context,
          );
          Future.delayed(const Duration(seconds: 1), () {
            context.go(RouteName.homeScreen);
          });
        } else {
          throw Exception('Failed to upload question');
        }
      } catch (e) {
        setLoading(false);
        Utils.flushBarErrorMessage(e.toString(), context);
      }
    });
  }

  // * unlocked levels

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

  // * skipping the 2 options
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
      if (i != int.tryParse(currentQuestion.answer!)) {
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

  List<Question> findbyLevel(String level, String title) {
    return _question
        .where((e) => e.level == level && e.title == title)
        .toList();
  }

  // * unlocked the first index of quiz level

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

  // * checking question are available for that level

  bool areQuestionsAvailableForLevel(String level, String title) {
    return getQuestion
        .any((question) => question.level == level && question.title == title);
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

  String _level = "";
  String get level => _level;

  void levelClear() {
    _level = "";
    notifyListeners();
  }

  void incrementQuestionNumber() {
    _questionNumber++;
    notifyListeners();
  }

  void resetcorrectAns() {
    _numOfCorrectAns = 0;
    _questiionLength = 1;
    notifyListeners();
  }

  // * update the pagecontroller number
  void updateTheQnNum(int index) {
    _questionNumber = index + 1;
    notifyListeners();
  }

  // * is hidden the option
  bool isHidden(int indexToCheck) {
    return hiddenIncorrectIndices.contains(indexToCheck);
  }

  isHiddenRemove() {
    hiddenIncorrectIndices.clear();
  }

  // * check answwer

  void checkAns(
    Question question,
    int selectedIndex,
    AnimationController animationController,
    PageController pageController,
    BuildContext context,
    List<Question> ques,
    String level,
    String title,
  ) {
    // because once user press any option then it will run

    _level = level;
    _isAnswered = true;
    _correctAns = int.tryParse(question.answer!);
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
        title,
      );
    });
    animationController.forward().whenComplete(() => nextQuestion(
          pageController,
          animationController,
          context,
          ques,
          title,
        ));
  }

  // * next question

  void nextQuestion(
    PageController pageController,
    AnimationController animationController,
    BuildContext context,
    List<Question> ques,
    String? title,
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
            title,
          ));
    } else {
      GoRouter.of(context).push(RouteName.scoreScreen, extra: title);
      hiddenIncorrectIndices = [];
      _questionNumber = 1;
      _isAnswered = false;
    }
    notifyListeners();
  }

  /// ################################################################# ///

  // ! advertising

  bool isAdLoading = false;
  bool get isAddsLoading => isAdLoading;
  RewardedAd? rewardedAd;
  // * load the  reward add

  void createRewardAdd() {
    
    isAdLoading = true;
    notifyListeners();

    RewardedAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/5224354917',
      request:
          const AdRequest(contentUrl: "https://zeecodercraft-a5508.web.app/"),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          rewardedAd = ad;
          isAdLoading = false;
          notifyListeners();
        },
        onAdFailedToLoad: (error) {
           isAdLoading = false;
          rewardedAd = null;

          notifyListeners();
          if (kDebugMode) {
            print("Failed $error");
          }
        },
      ),
    );
  }

  // * show the reward add

  void showRewardAdd(
    List<Question> ques,
    PageController pageController,
    AnimationController animationController,
    BuildContext context,
  ) {
    if (rewardedAd != null) {
      animationController.stop();
      rewardedAd!.fullScreenContentCallback =
          FullScreenContentCallback(onAdDismissedFullScreenContent: (ad) {
        if (kDebugMode) {
          print("succes");
        }
        createRewardAdd();
      }, onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        createRewardAdd();
      });
      rewardedAd!.show(onUserEarnedReward: (ad, reward) {
        rewardButtonPressed(pageController, animationController, context, ques);
        animationController.forward();
        return notifyListeners();
      });
      rewardedAd = null;
    }
  }
}
