import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chatus/features/auth/otp/screen.dart';
import 'package:chatus/features/auth/login/screen.dart';
import 'package:chatus/features/auth/otp/controller.dart';
import 'package:chatus/features/auth/signup/controller.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<SignUpController>(context);
    final otpController = Provider.of<OtpController>(context);

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
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please enter your name"),
                          ),
                        );
                        return;
                      }

                      final success = await controller.signUp(
                        email,
                        pass,
                        context,
                      );
                      if (success) {
                        await otpController.sendOtp(email, context);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                OtpVerificationScreen(email: email, name: name),
                          ),
                        );
                      }
                    },
              child: controller.loading
                  ? const CircularProgressIndicator()
                  : const Text("Sign Up"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              child: const Text("Already have an account? Login"),
            ),
          ],
        ),
      ),
    );
  }
}
