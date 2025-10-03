import 'package:chatus/modules/auth/otp_verification/repository.dart';
import 'package:chatus/modules/home/screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OtpVerificationController extends ChangeNotifier {
  final _repo = OtpVerificationRepository();

  bool _loading = false;

  bool get loading => _loading;

  bool _resendLoading = false;

  bool get resendLoading => _resendLoading;

  Future<void> sendOtp(String email, BuildContext context) async {
    _resendLoading = true;
    notifyListeners();

    try {
      await _repo.sendOtp(email: email);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("OTP sent to your email")));
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }

    _resendLoading = false;
    notifyListeners();
  }

  Future<bool> verifyOtp({
    required String email,
    required String otp,
    required String name,
    required BuildContext context,
  }) async {
    _loading = true;
    notifyListeners();

    try {
      final response = await _repo.verifyOtp(email: email, otp: otp);

      if (response.user != null) {
        // Create user profile in Supabase
        await _repo.createUserProfile(userId: response.user!.id, name: name, email: email);
        Get.to(() => HomeScreen());

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Email verified successfully")));

        _loading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }

    _loading = false;
    notifyListeners();
    return false;
  }

  Future<bool> checkEmailVerification() async {
    return await _repo.isEmailVerified();
  }
}
