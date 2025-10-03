import 'package:chatus/core/local/shared_pref.dart';
import 'package:chatus/modules/auth/login/repository.dart';
import 'package:chatus/modules/auth/otp_verification/repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginController extends ChangeNotifier {
  final _repo = LoginRepository();
  final _otpRepo = OtpVerificationRepository();

  bool _loading = false;
  bool get loading => _loading;

  Future<Map<String, dynamic>> signIn(String email, String password, BuildContext context) async {
    _loading = true;
    notifyListeners();

    try {
      final response = await _repo.signIn(email: email, password: password);

      // Check if email is verified
      final isVerified = await _otpRepo.isEmailVerified();

      if (!isVerified) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please verify your email first")));

        _loading = false;
        notifyListeners();
        return {'success': false, 'needsVerification': true, 'email': email};
      }

      // Save authentication state locally
      await SharedPref.setUserLoggedIn(true);

      // Save user token and ID if available
      final user = Supabase.instance.client.auth.currentUser;
      final session = Supabase.instance.client.auth.currentSession;
      if (user != null) {
        await SharedPref.saveUserId(user.id);
      }
      if (session != null && session.accessToken.isNotEmpty) {
        await SharedPref.saveUserToken(session.accessToken);
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("signin Successful")));

      _loading = false;
      notifyListeners();
      return {'success': true, 'needsVerification': false};
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));

      _loading = false;
      notifyListeners();
      return {'success': false, 'needsVerification': false};
    }
  }
}
