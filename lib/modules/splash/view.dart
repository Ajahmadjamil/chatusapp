import 'package:chatus/generated/assets.dart';
import 'package:chatus/modules/splash/controller.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Check authentication status and navigate accordingly
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SplashController>(context, listen: false).checkAuthAndNavigate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(Assets.lottieSplash),
            const SizedBox(height: 20),
            Consumer<SplashController>(
              builder: (context, controller, child) {
                if (controller.loading) {
                  return const CircularProgressIndicator();
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
