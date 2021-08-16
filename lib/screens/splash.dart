import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant/router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // screen will move after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      Get.offAllNamed(AppRouter.homepage);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/logo.png',
          width: Get.width * 0.4,
        ),
      ),
    );
  }
}
