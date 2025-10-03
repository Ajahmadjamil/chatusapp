import 'package:chatus/modules/auth/login/controller.dart';
import 'package:chatus/modules/auth/signup/screen.dart';
import 'package:chatus/modules/auth/otp_verification/screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<LoginController>(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: controller.loading
                  ? null
                  : () async {
                      final email = emailController.text.trim();
                      final pass = passwordController.text.trim();
                      final result = await controller.signIn(email, pass, context);

                      if (result['success']) {
                        // Navigate to home screen
                        Get.offAllNamed('/home');
                      } else if (result['needsVerification']) {
                        // Navigate to OTP verification screen
                        Get.to(
                          () => OtpVerificationScreen(
                            email: result['email'],
                            name: 'User', // You might want to get this from user profile
                          ),
                        );
                      }
                    },
              child: controller.loading ? const CircularProgressIndicator() : const Text("Login"),
            ),
            TextButton(
              onPressed: () {
                Get.to(() => SignupScreen());
              },
              child: const Text("Create an account"),
            ),
          ],
        ),
      ),
    );
  }
}
