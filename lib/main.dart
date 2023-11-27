import 'dart:ui';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

// ! file
import 'package:quiz_e_book/resources/color/app_color.dart';
import 'package:quiz_e_book/resources/routes/route_name/route_name.dart';
import 'package:quiz_e_book/resources/routes/routes.dart';
import 'package:quiz_e_book/viewModel/auth_view_model/auth_view_model.dart';
import 'package:quiz_e_book/viewModel/dynamic_link_view_model/dynamic_link_view_model.dart';
import 'package:quiz_e_book/viewModel/forgot_password_view_model/forgot_password_view_model.dart';
import 'package:quiz_e_book/viewModel/getAllUsers/get_all_users.dart';
import 'package:quiz_e_book/viewModel/login_view_model/login_view_model.dart';
import 'package:quiz_e_book/viewModel/registered_view_model.dar/registered_view_model.dart';

// ! package
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:quiz_e_book/viewModel/reset_view_model/reset_view_model.dart';
import 'package:quiz_e_book/viewModel/save_pdf_view_model/save_pdf_view_model.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_analytics/firebase_analytics.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
    // firebaseDynamicLink.initDynamicLinks((openLink) {
    //   // final pathSegment = openLink.link.queryParameters;
    //   if (openLink.link.path == "/pdf_view_screen") {
    //     String customParamValue = openLink.link.queryParameters['id'] as String;
    //     print("Custom Parameter Value: $customParamValue");
    //     return GoRouter.of(context)
    //         .go(RouteName.pdfviewScreen, extra: "1");
    //   }
    // });
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
