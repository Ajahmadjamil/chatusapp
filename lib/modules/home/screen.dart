import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            onPressed: () async {
              await Supabase.instance.client.auth.signOut();
              Get.offAllNamed('/signup');
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Welcome to Chat App!", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Text("Email: ${user?.email ?? 'Unknown'}", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text(
              "Email Verified: ${user?.emailConfirmedAt != null ? 'Yes' : 'No'}",
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
