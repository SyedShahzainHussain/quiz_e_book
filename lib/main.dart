import 'dart:ui';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quiz_e_book/data/services/splash_services.dart/splash_services.dart';

// ! file
import 'package:quiz_e_book/resources/color/app_color.dart';
import 'package:quiz_e_book/resources/routes/routes.dart';
import 'package:quiz_e_book/viewModel/auth_view_model/auth_view_model.dart';
import 'package:quiz_e_book/viewModel/delete_user_view_model/delete_user_view_model.dart';
import 'package:quiz_e_book/viewModel/dynamic_link_view_model/dynamic_link_view_model.dart';
import 'package:quiz_e_book/viewModel/forgot_password_view_model/forgot_password_view_model.dart';
import 'package:quiz_e_book/viewModel/getAllUsers/get_all_users.dart';
import 'package:quiz_e_book/viewModel/get_single_user_view_model/get_single_user_view_model.dart';
import 'package:quiz_e_book/viewModel/login_view_model/login_view_model.dart';
import 'package:quiz_e_book/viewModel/quiz_view_model/quiz_view_model.dart';
import 'package:quiz_e_book/viewModel/registered_view_model.dar/registered_view_model.dart';

// ! package
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:quiz_e_book/viewModel/reset_view_model/reset_view_model.dart';
import 'package:quiz_e_book/viewModel/save_pdf_view_model/save_pdf_view_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:quiz_e_book/viewModel/score_view_model/score_view_model.dart';
import 'package:quiz_e_book/viewModel/update_level_view_model/update_level_view_model.dart';
import 'package:quiz_e_book/viewModel/uploadfle_view_model/upload_file_viewModel.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await Firebase.initializeApp();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: AppColors.white));

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseDynamicLink firebaseDynamicLink = FirebaseDynamicLink();
  @override
  void initState() {
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => RegisteredViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => LoginViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => ForgotPasswordViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => ResetViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => SavePDFViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => GetAllUsers(),
        ),
        ChangeNotifierProvider(
          create: (context) => UploadFileViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => SplashService(),
        ),
        ChangeNotifierProvider(
          create: (context) => QuizViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => ScoreViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => GetSingleUserViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => UpdateLevelViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => DeleteUserViewModel(),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: AppRoute.router,
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.bgColor),
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.bgColor,
            titleTextStyle: TextStyle(color: AppColors.white),
            iconTheme: IconThemeData(color: AppColors.white),
          ),
          useMaterial3: true,
          textTheme: GoogleFonts.poppinsTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
      ),
    );
  }
}
