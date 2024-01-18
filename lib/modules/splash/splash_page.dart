import 'package:ev_cpms/main.dart';
import 'package:ev_cpms/route/router.gr.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    await Future.delayed(const Duration(seconds: 1));
    if (FirebaseAuth.instance.currentUser != null) {
      appRouter.pushAndPopUntil(const HomePageRoute(), predicate: (_) => false);
    } else {
      appRouter.pushAndPopUntil(const LoginPageRoute(),
          predicate: (_) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Lottie.asset(
                  "assets/lottie/63588-files-transfer-lottie-animation.json"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: const [
                LinearProgressIndicator(),
                SizedBox(height: 20),
                Text("Fetching nearby EV stations"),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
