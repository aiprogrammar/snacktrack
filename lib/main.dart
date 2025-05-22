import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'src/theme/app_theme.dart';
import 'src/services/auth_service.dart';
import 'src/services/product_service.dart';
import 'src/services/api_service.dart';
import 'src/screens/login_screen.dart';
import 'src/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;

  const MyApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => AuthService(prefs)),
        Provider(create: (_) => ProductService()),
        Provider(
          create: (_) => ApiService(
            baseUrl:
                'https://script.google.com/macros/s/YOUR_DEPLOYMENT_ID/exec',
          ),
        ),
      ],
      child: MaterialApp(
        title: 'SnackTrack',
        theme: AppTheme.lightTheme,
        home: Consumer<AuthService>(
          builder: (context, authService, _) {
            return authService.isLoggedIn()
                ? const HomeScreen()
                : const LoginScreen();
          },
        ),
      ),
    );
  }
}
