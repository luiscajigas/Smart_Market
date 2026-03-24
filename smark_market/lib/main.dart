import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/auth_repository.dart';
import 'presentation/screens/welcome/welcome_screen.dart';
import 'presentation/screens/home/main_shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://ivrlgruvmmwhbzqrevdr.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Iml2cmxncnV2bW13aGJ6cXJldmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzM4ODI5MTAsImV4cCI6MjA4OTQ1ODkxMH0.eq9hN9MtkTL6B1_0sNqxVHJ-jJkq4NvQQKFqwZiZq_I',
  );

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  final isLoggedIn = Supabase.instance.client.auth.currentSession != null;
  runApp(SmartMarketApp(isLoggedIn: isLoggedIn));
}

class SmartMarketApp extends StatelessWidget {
  final bool isLoggedIn;
  const SmartMarketApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Market',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: isLoggedIn ? const MainShell() : const WelcomeScreen(),
    );
  }
}
