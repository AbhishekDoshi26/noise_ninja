import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:noise_ninja/constants/constants.dart';
import 'package:noise_ninja/splash_screen/view/splash_screen_page.dart';

void main() {
  final mySystemTheme = SystemUiOverlayStyle.light
      .copyWith(systemNavigationBarColor: ColorConstants.splashScreenColor);
  SystemChrome.setSystemUIOverlayStyle(mySystemTheme);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Noise Ninja',
      theme: ThemeData.dark()
          .copyWith(scaffoldBackgroundColor: ColorConstants.splashScreenColor),
      home: const SplashScreenPage(),
    );
  }
}
