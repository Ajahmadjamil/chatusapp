import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chatus/features/base/screen.dart';
import 'package:chatus/features/auth/otp/screen.dart';
import 'package:chatus/features/auth/signup/screen.dart';
import 'package:chatus/features/auth/login/controller.dart';

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
                      final result = await controller.signIn(
                        email,
                        pass,
                        context,
                      );

                      if (result['success']) {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => BaseScreen()),
                          (route) => false,
                        );
                      } else if (result['needsVerification']) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => OtpVerificationScreen(
                              email: result['email'],
                              name: 'User',
                            ),
                          ),
                        );
                      }
                    },
              child: controller.loading
                  ? const CircularProgressIndicator()
                  : const Text("Login"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (context) => SignupScreen()));
              },
              child: const Text("Create an account"),
            ),
          ],
        ),
      ),
    );
  }
}
