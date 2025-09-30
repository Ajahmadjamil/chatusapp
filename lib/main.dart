import 'package:chatus/modules/auth/signup/screen.dart';
import 'package:chatus/modules/auth/login/screen.dart';
import 'package:chatus/modules/home/screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'modules/auth/login/provider.dart';
import 'modules/auth/signup/provider.dart';
import 'modules/auth/otp_verification/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://pbnhfpfzhkdwshazfjpl.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBibmhmcGZ6aGtkd3NoYXpmanBsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTkxNDg0NDcsImV4cCI6MjA3NDcyNDQ0N30.ojchhC4shWrFhSgzWAvtwTaSxuSd3q8-qU5bVgkatWo',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SignUpController()),
        ChangeNotifierProvider(create: (context) => LoginController()),
        ChangeNotifierProvider(create: (context) => OtpVerificationController()),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chat Us App',
        theme: ThemeData(primarySwatch: Colors.deepPurple),
        home: SignupScreen(),
        getPages: [
          GetPage(name: '/signup', page: () => SignupScreen()),
          GetPage(name: '/login', page: () => LoginScreen()),
          GetPage(name: '/home', page: () => const HomeScreen()),
        ],
      ),
    );
  }
}
