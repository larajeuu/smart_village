import 'package:flutter/material.dart';
import '../data/faskes.dart';
import '../services/notifikasi_service.dart';
import '../widgets/common.dart';
import '../widgets/sv_theme.dart';
import 'login_screen.dart';
import 'shell.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    initLocation(); // minta izin + baca GPS + pantau terus
    NotifikasiService.instance.mulai(); // geofencing -> notifikasi
  }
  // "Mulai" -> langsung ke Shell (tamu), "Masuk" -> LoginScreen
  void _mulai(BuildContext c) => Navigator.pushReplacement(
      c, MaterialPageRoute(builder: (_) => const Shell()));

  void _masuk(BuildContext c) => Navigator.push(
      c, MaterialPageRoute(builder: (_) => const LoginScreen()));

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(children: [
        // gambar di belakang teks
        Positioned(
          left: 0,
          right: 0,
          top: h * 0.12,
          height: h * 0.66,
          child: Stack(fit: StackFit.expand, children: [
            Image.asset(
              'assets/images/banner_home.jpeg',
              fit: BoxFit.cover,
              alignment: const Alignment(0.25, 1),
              errorBuilder: (_, __, ___) => Container(color: svBlueSoft),
            ),
            const DecoratedBox(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment(0, -0.8),
                        colors: [Colors.white, Color(0x00FFFFFF)]))),
            const DecoratedBox(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment(0, 0.7),
                        end: Alignment.bottomCenter,
                        colors: [Color(0x00FFFFFF), Colors.white]))),
          ]),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(children: [
              SizedBox(height: h * 0.07),
              const AppLogo(size: 64),
              const SizedBox(height: 16),
              const Text('Sehat Bersama\nSmart Village',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 28,
                      height: 1.15,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1B3A6B))),
              const SizedBox(height: 12),
              const Text(
                  'Temukan lokasi Klinik, Puskesmas\ndan Rumah Sakit terdekat\ndengan mudah.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, height: 1.55, color: svSub)),
              const Spacer(),
              FilledButton(
                style: FilledButton.styleFrom(
                    backgroundColor: svBlue,
                    minimumSize: const Size.fromHeight(52),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16))),
                onPressed: () => _mulai(context),
                child: const Text('Mulai',
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
              ),
              TextButton(
                onPressed: () => _masuk(context),
                child: const Text('Masuk',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: svBlue)),
              ),
              const SizedBox(height: 8),
            ]),
          ),
        ),
      ]),
    );
  }
}