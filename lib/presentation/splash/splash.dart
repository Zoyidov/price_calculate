import 'dart:async';
import 'package:flutter/material.dart';
import 'package:price_calculate/presentation/car_selection/car_selection.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    _startSplashScreen();
  }

  void _startSplashScreen() async {
    // Simulate some loading time
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _opacity = 1.0; // Fade in the logo
    });

    // Navigate to the next screen after the delay
    Timer(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => CarSelectionScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedOpacity(
          opacity: _opacity,
          duration: const Duration(seconds: 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/logo.png', height: 200),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
