import 'package:chatus/modules/auth/otp_verification/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class OtpVerificationScreen extends StatelessWidget {
  final String email;
  final String name;

  OtpVerificationScreen({super.key, required this.email, required this.name});

  final List<TextEditingController> otpControllers = List.generate(6, (index) => TextEditingController());

  final List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<OtpVerificationController>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Email Verification")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            Text(
              "Enter the 6-digit OTP sent to:",
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              email,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                6,
                (index) => SizedBox(
                  width: 60,
                  child: TextField(
                    controller: otpControllers[index],
                    focusNode: focusNodes[index],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      counterText: '',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    style: Theme.of(context).textTheme.headlineSmall,
                    onChanged: (value) {
                      if (value.isNotEmpty && index < 3) {
                        focusNodes[index + 1].requestFocus();
                      } else if (value.isEmpty && index > 0) {
                        focusNodes[index - 1].requestFocus();
                      }
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: controller.loading
                  ? null
                  : () async {
                      final otp = otpControllers.map((controller) => controller.text).join();

                      if (otp.length != 6) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(const SnackBar(content: Text("Please enter a 6-digit OTP")));
                        return;
                      }

                      final success = await controller.verifyOtp(email: email, otp: otp, name: name, context: context);

                      if (success) {
                        // Navigate to home or login screen
                        Get.offAllNamed('/home'); // Assuming you have a home route
                      }
                    },
              child: controller.loading ? const CircularProgressIndicator() : const Text("Verify OTP"),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: controller.resendLoading
                  ? null
                  : () {
                      controller.sendOtp(email, context);
                    },
              child: controller.resendLoading ? const CircularProgressIndicator() : const Text("Resend OTP"),
            ),
          ],
        ),
      ),
    );
  }
}
