import 'package:chatus/core/local/shared_pref.dart';
import 'package:chatus/features/auth/login/screen.dart';
import 'package:chatus/features/base/screen.dart';
import 'package:flutter/material.dart';

class SplashController extends ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;

  Future<void> checkAuthAndNavigate(BuildContext context) async {
    _loading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 3));

    try {
      final isLoggedIn = await SharedPref.isUserLoggedIn();

      if (!context.mounted) return;

      if (isLoggedIn) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => BaseScreen()),
          (route) => false,
        );
      } else {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false,
      );
    }

    _loading = false;
    notifyListeners();
  }
}
