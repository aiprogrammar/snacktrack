import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _pinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 48),
              Center(
                child: Image.network(
                  'https://cdn.iconscout.com/icon/free/png-256/free-qr-code-scan-1851050-1569154.png',
                  height: 120,
                  width: 120,
                ),
              ),
              const SizedBox(height: 48),
              Text(
                'Welcome Back!',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Sign in to continue scanning',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  hintText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _pinController,
                decoration: const InputDecoration(
                  hintText: '4-Digit PIN',
                  prefixIcon: Icon(Icons.lock_outline),
                  counterText: '',
                ),
                keyboardType: TextInputType.number,
                maxLength: 4,
                obscureText: true,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () async {
                  if (_emailController.text.isNotEmpty &&
                      _pinController.text.length == 4) {
                    final success = await context.read<AuthService>().login(
                          _emailController.text,
                          _pinController.text,
                        );
                    if (success && mounted) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => const HomeScreen()),
                      );
                    }
                  }
                },
                child: const Text('Sign In'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _pinController.dispose();
    super.dispose();
  }
}