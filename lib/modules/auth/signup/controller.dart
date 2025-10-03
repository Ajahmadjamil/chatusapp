import 'package:chatus/modules/auth/signup/repository.dart';
import 'package:flutter/material.dart';

class SignUpController extends ChangeNotifier {
  final _repo = SignUpRepository();

  bool _loading = false;
  bool get loading => _loading;

  Future<bool> signUp(String email, String password, BuildContext context) async {
    _loading = true;
    notifyListeners();

    try {
      await _repo.signUp(email: email, password: password);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Signup successful")));
      // Navigator.pushReplacementNamed(context, '/login');
      _loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      _loading = false;
      notifyListeners();
      return false;
    }
  }
}
