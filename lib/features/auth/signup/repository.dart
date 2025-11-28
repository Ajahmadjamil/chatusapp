import 'package:supabase_flutter/supabase_flutter.dart';

class SignUpRepository {
  final _client = Supabase.instance.client;

  Future<AuthResponse> signUp({required String email, required String password}) async {
    return await _client.auth.signUp(email: email, password: password);
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }
}
