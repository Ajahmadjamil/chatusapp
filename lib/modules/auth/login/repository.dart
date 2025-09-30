import 'package:supabase_flutter/supabase_flutter.dart';

class LoginRepository {
  final _client = Supabase.instance.client;

  Future<AuthResponse> signIn({required String email, required String password}) async {
    return await _client.auth.signInWithPassword(email: email, password: password);
  }
}
