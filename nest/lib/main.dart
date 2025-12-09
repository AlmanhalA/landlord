import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/landlord_provider.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => LandlordProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LandlordProvider>(context);

    return MaterialApp(
      title: 'Landlord App',
      debugShowCheckedModeBanner: false,
      themeMode: provider.themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.cyan,
          primary: Colors.cyan,
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.blue[50],
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.dark(
          primary: Colors.cyan,
          surface: Color(0xFF1F2937),
          // 'background' is deprecated, removed.
        ),
        scaffoldBackgroundColor: const Color(0xFF111827),
        cardColor: const Color(0xFF1F2937),
      ),
      home: provider.isLoggedIn ? const DashboardScreen() : const LoginScreen(),
    );
  }
}