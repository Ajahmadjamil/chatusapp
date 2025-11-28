import 'package:flutter/material.dart';
import 'package:chatus/core/local/shared_pref.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:chatus/features/auth/login/screen.dart';
import 'package:chatus/core/widgets/custom_alert_dialog.dart';

class ProfileController extends ChangeNotifier {
  String _selectedButton = "Daily";
  String get selectedButton => _selectedButton;

  void setSelectedButton(String text) {
    _selectedButton = text;
    notifyListeners();
  }

  void onAccountInfoTap(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Navigate to Account Info")));
  }

  Future<void> confirmLogout(BuildContext context) async {
    showDialog(
      context: context,
      builder: (dialogContext) => CustomConfirmationDialog(
        message: "Are you sure you want to log out?",
        onConfirm: () async {
          Navigator.of(dialogContext).pop();

          try {
            await SharedPref.clearUserData();
            await Supabase.instance.client.auth.signOut();

            if (context.mounted) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (route) => false,
              );
            }
          } catch (e) {
            print("Logout error: $e");
            if (context.mounted) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (route) => false,
              );
            }
          }
        },
        onCancel: () {
          Navigator.of(dialogContext).pop();
        },
      ),
    );
  }
}
