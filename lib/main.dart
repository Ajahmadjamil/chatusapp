import 'package:chatus/core/constants/app_constants.dart';
import 'package:chatus/modules/auth/login/screen.dart';
import 'package:chatus/modules/auth/signup/screen.dart';
import 'package:chatus/modules/home/screen.dart';
import 'package:chatus/modules/splash/view.dart';
import 'package:cloudinary_flutter/cloudinary_context.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'modules/auth/login/controller.dart';
import 'modules/auth/otp_verification/controller.dart';
import 'modules/auth/signup/controller.dart';
import 'modules/splash/controller.dart';

void main() async {
  CloudinaryContext.cloudinary = Cloudinary.fromCloudName(cloudName: AppConstants.cloudinaryCloudName);
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(url: AppConstants.supaBaseUrl, anonKey: AppConstants.supaBaseAnonKey);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SplashController()),
        ChangeNotifierProvider(create: (context) => SignUpController()),
        ChangeNotifierProvider(create: (context) => LoginController()),
        ChangeNotifierProvider(create: (context) => OtpVerificationController()),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chat Us App',
        theme: ThemeData(primarySwatch: Colors.deepPurple),
        home: SplashScreen(),
        getPages: [
          GetPage(name: '/signup', page: () => SignupScreen()),
          GetPage(name: '/login', page: () => LoginScreen()),
          GetPage(name: '/home', page: () => const HomeScreen()),
        ],
      ),
    );
  }
}
