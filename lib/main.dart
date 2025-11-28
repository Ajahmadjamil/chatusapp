import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'features/splash/controller.dart';
import 'features/auth/otp/controller.dart';
import 'features/auth/login/controller.dart';
import 'features/auth/signup/controller.dart';
import 'package:chatus/features/splash/view.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:chatus/core/theme/theme_service.dart';
import 'package:chatus/features/home/controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:chatus/features/profile/controller.dart';
import 'package:chatus/core/constants/app_constants.dart';
import 'package:cloudinary_flutter/cloudinary_context.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  CloudinaryContext.cloudinary = Cloudinary.fromCloudName(
    cloudName: AppConstants.cloudinaryCloudName,
  );

  await Supabase.initialize(
    url: AppConstants.supaBaseUrl,
    anonKey: AppConstants.supaBaseAnonKey,
  );

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeService()),
        ChangeNotifierProvider(create: (context) => HomeController()),
        ChangeNotifierProvider(create: (context) => SplashController()),
        ChangeNotifierProvider(create: (context) => SignUpController()),
        ChangeNotifierProvider(create: (context) => LoginController()),
        ChangeNotifierProvider(create: (context) => ProfileController()),
        ChangeNotifierProvider(create: (context) => OtpController()),
      ],
      child: Consumer<ThemeService>(
        builder: (context, themeService, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Chat Us App',
            themeMode: themeService.themeMode,
            theme: ThemeData(
              primarySwatch: Colors.deepPurple,
              brightness: Brightness.light,
            ),
            darkTheme: ThemeData.dark(),
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
