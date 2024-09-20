// ignore_for_file: use_build_context_synchronously

import 'package:calen_do/utils/constants.dart';
import 'package:calen_do/view/calender_screen/screen_calender.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    gotoHomePage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: size.height * 0.2,
          child: LottieBuilder.asset(splash),
        ),
      ),
    );
  }

  Future gotoHomePage() async {
    await Future.delayed(const Duration(seconds: 3));
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => const  CalendarScreen()));
  }
}