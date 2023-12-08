import 'package:flutter/material.dart';
import 'package:quiz_e_book/data/services/splash_services.dart/splash_services.dart';
import 'package:quiz_e_book/resources/routes/route_name/route_name.dart';
import 'package:quiz_e_book/utils/utils.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with WidgetsBindingObserver {
  SplashService splashService = SplashService();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Listen to the onTokenExpired stream
    splashService.onTokenExpired.listen((isTokenExpired) {
      if (isTokenExpired) {
        // Redirect to login screen
        Navigator.pushReplacementNamed(context, RouteName.loginScreen);
      }
    });

    // Check authentication
    splashService.checkAuthentication(context);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Check for token expiration when the app is resumed
      print("login");
      splashService.checkAuthentication(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Spacer(flex: 2),
      Text(
        "Quiz & E Book",
        style: Theme.of(context).textTheme.headlineLarge!.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
      const Spacer(),
      Utils.showLoadingSpinner(),
      const Spacer(),
    ]));
  }
}
