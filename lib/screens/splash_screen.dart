import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'shell.dart';

/// PLACEHOLDER - diisi pemilik layar atas.
/// Kontrak navigasi: "Mulai" -> Shell (tamu), "Masuk" -> LoginScreen.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('TODO: Splash'),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const Shell()),
                ),
                child: const Text('Mulai'),
              ),
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                ),
                child: const Text('Masuk'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
