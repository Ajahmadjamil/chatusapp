import 'package:chatus/core/local/shared_pref.dart';
import 'package:chatus/modules/home/screen.dart';
import 'package:chatus/modules/auth/login/screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../base/view.dart';

class SplashController extends ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;

  // Check authentication status and navigate accordingly
  Future<void> checkAuthAndNavigate() async {
    _loading = true;
    notifyListeners();

    // Add a delay for splash screen effect
    await Future.delayed(const Duration(seconds: 3));

    try {
      final isLoggedIn = await SharedPref.isUserLoggedIn();

      if (isLoggedIn) {
        // User is logged in, navigate to home screen
        Get.offAll(() => const BaseScreen());
      } else {
        // User is not logged in, navigate to login screen
        Get.offAll(() => LoginScreen());
      }
    } catch (e) {
      // If there's an error, default to login screen
      Get.offAll(() => LoginScreen());
    }

    _loading = false;
    notifyListeners();
  }
}
