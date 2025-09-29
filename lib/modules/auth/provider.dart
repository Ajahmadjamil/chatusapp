import 'package:chatus/modules/auth/repository.dart';
import 'package:flutter/material.dart';

class AuthController extends ChangeNotifier {
  final _repo = AuthRepository();

  bool _loading = false;
  bool get loading => _loading;

  Future<void> signUp(String email, String password, BuildContext context) async {
    _loading = true;
    notifyListeners();

    try {
      await _repo.signUp(email: email, password: password);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Signup successful")));
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> signIn(String email, String password, BuildContext context) async {
    _loading = true;
    notifyListeners();

    try {
      await _repo.signIn(email: email, password: password);
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }

    _loading = false;
    notifyListeners();
  }
}
