import 'package:flutter/material.dart';

import '../data/faskes.dart';
import '../widgets/common.dart';
import '../widgets/sv_theme.dart';
import 'detail_screen.dart';

/// Tampilan "lock screen" dengan notifikasi geofence (layar 6 pada desain).
/// Ini tiruan di dalam aplikasi; notifikasi asli di lock screen digambar oleh
/// sistem Android (lihat NotificationService).
class LockScreenPreview extends StatelessWidget {
  final Faskes? faskes;
  const LockScreenPreview({super.key, this.faskes});

  @override
  Widget build(BuildContext context) {
    final f = faskes ?? daftarFaskes.first;
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.pop(context),
        onVerticalDragEnd: (d) {
          if ((d.primaryVelocity ?? 0) < -300) Navigator.pop(context);
        },
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF2C5FA5),
                Color(0xFF5F8CC6),
                Color(0xFFE9A47C),
                Color(0xFFF0B48A),
              ],
              stops: [0, 0.45, 0.9, 1],
            ),
          ),
          child: SafeArea(
            child: Column(children: [
              const SizedBox(height: 18),
              const Icon(Icons.lock, color: Colors.white, size: 24),
              const SizedBox(height: 8),
              const Text('10:24',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 88,
                      fontWeight: FontWeight.w300,
                      height: 1.05)),
              const Text('Sen, 20 Okt 2025',
                  style: TextStyle(color: Colors.white, fontSize: 17)),
              const SizedBox(height: 44),
              // ---------- kartu notifikasi ----------
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => DetailScreen(faskes: f)),
                ),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 14),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.93),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(children: [
                        AppLogo(size: 14),
                        SizedBox(width: 6),
                        Text('Smart Village',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w700)),
                        Spacer(),
                        Text('Sekarang',
                            style: TextStyle(
                                fontSize: 12, color: Colors.black54)),
                      ]),
                      const SizedBox(height: 8),
                      Text('Anda berada di area ${f.nama}',
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 2),
                      ValueListenableBuilder(
                        valueListenable: userPos,
                        builder: (_, pos, __) => Text(
                          'Jarak Anda: ${jarakMeter(pos, f.pos).round()} meter',
                          style: const TextStyle(
                              fontSize: 13, color: Colors.black87),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(children: [
                        const Icon(Icons.location_on,
                            size: 16, color: svRed),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(f.alamat,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 11, color: Colors.black45)),
                        ),
                      ]),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: SizedBox(
                          height: 120,
                          width: double.infinity,
                          child: Image.asset(
                            'assets/images/banner_home.jpeg',
                            fit: BoxFit.cover,
                            alignment: const Alignment(0.3, 1),
                            errorBuilder: (_, __, ___) =>
                                faskesFoto(f, w: double.infinity, h: 120),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              const Padding(
                padding: EdgeInsets.fromLTRB(28, 0, 28, 28),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _BulatIkon(Icons.flashlight_on),
                    Text('Geser untuk membuka',
                        style: TextStyle(color: Colors.white, fontSize: 13)),
                    _BulatIkon(Icons.photo_camera),
                  ],
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

class _BulatIkon extends StatelessWidget {
  final IconData ikon;
  const _BulatIkon(this.ikon);

  @override
  Widget build(BuildContext context) => Container(
        width: 46,
        height: 46,
        decoration: const BoxDecoration(
            color: Color(0x66000000), shape: BoxShape.circle),
        child: Icon(ikon, color: Colors.white, size: 22),
      );
}