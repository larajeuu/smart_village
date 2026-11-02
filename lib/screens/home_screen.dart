import 'package:flutter/material.dart';
import 'list_screen.dart';
import 'peta_lokasi_screen.dart';

// Ubah ke false kalau foto home.jpeg SUDAH berisi logo + tulisan
// "Smart Village" di dalam gambarnya (supaya tidak dobel).
const bool pakaiHeaderTeks = true;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _buka(BuildContext context, Widget halaman) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => halaman));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ===== HEADER: TEKS DI ATAS GAMBAR (seperti tugas) =====
            SizedBox(
              height: 420,
              child: Stack(
                children: [
                  // 1) Gambar memenuhi seluruh header
                  Positioned.fill(
                    child: Image.asset(
                      'assets/images/banner_home.jpeg',
                      fit: BoxFit.cover,
                      alignment: Alignment.bottomCenter,
                      errorBuilder: (_, error, __) {
                        debugPrint('BANNER GAGAL: $error');
                        return Container(
                          color: Colors.blue.shade100,
                          alignment: Alignment.center,
                          child: const Text(
                            'assets/images/home.jpeg\ntidak ditemukan',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        );
                      },
                    ),
                  ),

                  // 2) Gradasi biru muda di atas, supaya tulisan jelas terbaca
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: 230,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            const Color(0xFFBFE3FF).withOpacity(0.95),
                            const Color(0xFFBFE3FF).withOpacity(0.0),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // 3) Gradasi putih di bawah, tempat search bar
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: 110,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white.withOpacity(0.0),
                            Colors.white,
                          ],
                        ),
                      ),
                    ),
                  ),

                  // 4) Logo + judul + deskripsi
                  if (pakaiHeaderTeks)
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: SafeArea(
                        bottom: false,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(24, 36, 24, 0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  _logo(),
                                  const SizedBox(width: 14),
                                  const Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Smart Village',
                                        style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.w800,
                                          color: Color(0xFF1B3A8A),
                                          height: 1.1,
                                          letterSpacing: 0.3,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Sehat Bersama, Desa Maju',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 22),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18, vertical: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.75),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.06),
                                      blurRadius: 10,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Text.rich(
                                  TextSpan(
                                    style: const TextStyle(
                                      fontSize: 14,
                                      height: 1.5,
                                      color: Color(0xFF334155),
                                    ),
                                    children: [
                                      const TextSpan(text: 'Cari lokasi '),
                                      TextSpan(
                                        text: 'Klinik',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          color: Colors.deepPurple.shade600,
                                        ),
                                      ),
                                      const TextSpan(text: ', '),
                                      TextSpan(
                                        text: 'Puskesmas',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          color: Colors.green.shade700,
                                        ),
                                      ),
                                      const TextSpan(text: ' dan\n'),
                                      TextSpan(
                                        text: 'Rumah Sakit',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          color: Colors.red.shade600,
                                        ),
                                      ),
                                      const TextSpan(
                                          text: ' terdekat di Kabupaten X'),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                  // 5) Search bar menimpa bagian bawah gambar
                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: 16,
                    child: Material(
                      elevation: 6,
                      borderRadius: BorderRadius.circular(28),
                      child: TextField(
                        readOnly: true,
                        onTap: () => _buka(
                            context, const ListScreen(title: 'Cari Fasilitas')),
                        decoration: InputDecoration(
                          hintText: 'Cari nama fasilitas kesehatan...',
                          prefixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(28),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ===== 4 MENU =====
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 1.25,
                children: [
                  _menu(
                      'Rumah Sakit',
                      Icons.local_hospital,
                      const Color(0xFF1E6FE8),
                      const Color(0xFFDCEBFF),
                      () => _buka(
                          context,
                          const ListScreen(
                              kategori: 'Rumah Sakit', title: 'Rumah Sakit'))),
                  _menu(
                      'Puskesmas',
                      Icons.home_work,
                      Colors.green,
                      const Color(0xFFDDF5E3),
                      () => _buka(
                          context,
                          const ListScreen(
                              kategori: 'Puskesmas', title: 'Puskesmas'))),
                  _menu(
                      'Klinik',
                      Icons.medical_services,
                      Colors.deepPurple,
                      const Color(0xFFEBDDFA),
                      () => _buka(
                          context,
                          const ListScreen(
                              kategori: 'Klinik', title: 'Klinik'))),
                  _menu(
                      'Peta Lokasi',
                      Icons.location_on,
                      const Color(0xFFB8860B),
                      const Color(0xFFFFF0CC),
                      () => _buka(context, const PetaLokasiScreen())),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _logo() => const SmartVillageLogo(width: 64);

  Widget _menu(String label, IconData icon, Color color, Color bg,
      VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        decoration:
            BoxDecoration(color: bg, borderRadius: BorderRadius.circular(18)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 42),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class SmartVillageLogo extends StatelessWidget {
  final double width;
  const SmartVillageLogo({super.key, this.width = 64});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, width * 1.3),
      painter: _LogoPainter(),
    );
  }
}

class _LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final r = w / 2;
    final cx = r;
    final cy = r;

    // ===== Bentuk pin =====
    final pin = Path()
      ..moveTo(cx, h)
      ..cubicTo(cx - r * 0.15, h - r * 0.5, 0, cy + r * 0.9, 0, cy)
      ..arcToPoint(Offset(w, cy), radius: Radius.circular(r), clockwise: true)
      ..cubicTo(w, cy + r * 0.9, cx + r * 0.15, h - r * 0.5, cx, h)
      ..close();

    // Bayangan lembut
    canvas.drawShadow(pin, Colors.black.withOpacity(0.35), 4, true);

    // Isi pin: gradasi biru
    canvas.drawPath(
      pin,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF3B8CF5), Color(0xFF1B4DB8)],
        ).createShader(Rect.fromLTWH(0, 0, w, h)),
    );

    // ===== Lengkungan hijau di bagian bawah (dipotong mengikuti pin) =====
    canvas.save();
    canvas.clipPath(pin);

    final waveLight = Path()
      ..moveTo(0, h * 0.74)
      ..quadraticBezierTo(w * 0.35, h * 0.62, w * 0.7, h * 0.72)
      ..quadraticBezierTo(w * 0.88, h * 0.76, w, h * 0.70)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(waveLight, Paint()..color = const Color(0xFF7BD389));

    final waveDark = Path()
      ..moveTo(0, h * 0.80)
      ..quadraticBezierTo(w * 0.35, h * 0.68, w * 0.7, h * 0.78)
      ..quadraticBezierTo(w * 0.88, h * 0.82, w, h * 0.76)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(waveDark, Paint()..color = const Color(0xFF2FAE5F));

    canvas.restore();

    // ===== Lingkaran putih =====
    final center = Offset(cx, cy);
    canvas.drawCircle(center, r * 0.62, Paint()..color = Colors.white);

    // ===== Tanda plus merah =====
    final merah = Paint()..color = const Color(0xFFE53935);
    final arm = r * 0.27;
    final len = r * 0.92;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: center, width: len, height: arm),
        Radius.circular(arm * 0.3),
      ),
      merah,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: center, width: arm, height: len),
        Radius.circular(arm * 0.3),
      ),
      merah,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}