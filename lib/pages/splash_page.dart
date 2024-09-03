import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:taskly/pages/home_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 8), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const HomePage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 150.0, bottom: 50.0),
            child: Center(
              child: Lottie.asset('assets/animations/start.json',
                  height: 210, reverse: true, repeat: true, fit: BoxFit.cover),
            ),
          ),
          SizedBox(
            height: 100,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: AnimatedTextKit(
              repeatForever: true,
              animatedTexts: [
                TypewriterAnimatedText(
                  'Organize Today, Achieve Tomorrow🚀, Welcome to Taskly!',
                  textAlign: TextAlign.center,
                  textStyle: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(255, 116, 159, 159),
                  ),
                  speed: const Duration(milliseconds: 100),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
