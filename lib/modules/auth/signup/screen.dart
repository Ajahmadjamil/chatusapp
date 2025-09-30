import 'package:chatus/modules/auth/signup/provider.dart';
import 'package:chatus/modules/auth/otp_verification/screen.dart';
import 'package:chatus/modules/auth/otp_verification/provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../login/screen.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<SignUpController>(context);
    final otpController = Provider.of<OtpVerificationController>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Full Name"),
            ),
            const SizedBox(height: 12),
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
                      final name = nameController.text.trim();
                      final email = emailController.text.trim();
                      final pass = passwordController.text.trim();

                      if (name.isEmpty) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(const SnackBar(content: Text("Please enter your name")));
                        return;
                      }

                      final success = await controller.signUp(email, pass, context);
                      if (success) {
                        // After signup, send OTP for verification
                        await otpController.sendOtp(email, context);

                        Get.to(() => OtpVerificationScreen(email: email, name: name));
                      }
                    },
              child: controller.loading ? const CircularProgressIndicator() : const Text("Sign Up"),
            ),
            TextButton(
              onPressed: () {
                Get.to(() => LoginScreen());
              },
              child: const Text("Already have an account? Login"),
            ),
          ],
        ),
      ),
    );
  }
}
