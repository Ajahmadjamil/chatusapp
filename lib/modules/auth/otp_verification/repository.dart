import 'package:supabase_flutter/supabase_flutter.dart';

class OtpVerificationRepository {
  final _client = Supabase.instance.client;

  Future<void> sendOtp({required String email}) async {
    await _client.auth.resend(type: OtpType.signup, email: email);
  }

  Future<AuthResponse> verifyOtp({required String email, required String otp}) async {
    return await _client.auth.verifyOTP(email: email, token: otp, type: OtpType.signup);
  }

  Future<bool> isEmailVerified() async {
    final user = _client.auth.currentUser;
    return user?.emailConfirmedAt != null;
  }

  Future<void> createUserProfile({required String userId, required String name, required String email}) async {
    await _client.from('profiles').insert({
      // If you've set id default to auth.uid() in DB, remove this line:
      'id': userId,

      'name': name,
      'email': email,
      'about': 'Hey there! I am using ChatUs app.',
      'is_online': true,
      'created_at': DateTime.now().toIso8601String(),
      'last_active': DateTime.now().toIso8601String(),
    });
  }
}
