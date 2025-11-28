import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:chatus/generated/assets.dart';

class StatusScreen extends StatelessWidget {
  const StatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Lottie.asset(Assets.lottie404)));
  }
}
