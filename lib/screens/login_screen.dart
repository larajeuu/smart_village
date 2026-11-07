import 'package:flutter/material.dart';
import 'shell.dart';

/// PLACEHOLDER - login simulasi (tanpa backend).
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Masuk')),
      body: Center(
        child: FilledButton(
          // pushAndRemoveUntil: hapus riwayat halaman supaya tombol back
          // tidak kembali ke Splash/Login setelah masuk.
          onPressed: () => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const Shell()),
            (_) => false,
          ),
          child: const Text('Masuk (simulasi)'),
        ),
      ),
    );
  }
}
