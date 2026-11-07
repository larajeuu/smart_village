import 'package:flutter/material.dart';
import '../data/faskes.dart';
import '../widgets/common.dart';
import '../widgets/sv_theme.dart';
import 'list_screen.dart';

class HomeScreen extends StatelessWidget {
  /// Diisi oleh Shell (tab Peta). Opsional supaya layar tetap bisa dipakai sendiri.
  final VoidCallback? onOpenMap;
  const HomeScreen({super.key, this.onOpenMap});

  @override
  Widget build(BuildContext context) {
    const tiles = [
      ['Rumah Sakit', KategoriJenis.rumahSakit, Color(0xFFF2455F)],
      ['Puskesmas', KategoriJenis.puskesmas, Color(0xFF4C9F50)],
      ['Klinik', KategoriJenis.klinik, Color(0xFF1888D8)],
      ['Semua', KategoriJenis.semua, Color(0xFFFB9B16)],
    ];
    final dekat = daftarFaskes
        .where((f) => const [
              'RSUD Kabupaten X',
              'Puskesmas Sukamaju',
              'Klinik Sehat Mandiri'
            ].contains(f.nama))
        .toList();
    return SafeArea(
      child: ListView(padding: EdgeInsets.zero, children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
          child: Row(children: [
            const Icon(Icons.location_on, color: svBlue, size: 30),
            const SizedBox(width: 6),
            const Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Smart Village',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                Row(children: [
                  Icon(Icons.location_on, size: 11, color: svGreen),
                  Text('Kabupaten X',
                      style: TextStyle(fontSize: 11, color: svMut)),
                ]),
              ]),
            ),
            const Icon(Icons.notifications_none, color: svSub),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
          child: SearchBox('Cari rumah sakit, puskesmas, klinik...',
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const ListScreen(title: 'Daftar Lokasi', cari: true)))),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 6),
          child: Row(
            children: [
              for (var i = 0; i < tiles.length; i++) ...[
                if (i > 0) const SizedBox(width: 10),
                Expanded(
                  child: _KategoriCard(
                    nama: tiles[i][0] as String,
                    jenis: tiles[i][1] as KategoriJenis,
                    warna: tiles[i][2] as Color,
                    onTap: () {
                      final nama = tiles[i][0] as String;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ListScreen(
                                  kategori: nama == 'Semua' ? null : nama,
                                  title: nama == 'Semua'
                                      ? 'Daftar Lokasi'
                                      : nama)));
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('Layanan Kesehatan Terdekat',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
            GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const ListScreen(title: 'Daftar Lokasi'))),
              child: const Text('Lihat Semua',
                  style: TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w600, color: svBlue)),
            ),
          ]),
        ),
        ValueListenableBuilder(
          valueListenable: userPos,
          builder: (_, __, ___) => Column(
              children: dekat.map((f) => FacilityTile(f, foto: 76)).toList()),
        ),
      ]),
    );
  }
}

// ===================== IKON KATEGORI (sesuai desain) =====================

enum KategoriJenis { rumahSakit, puskesmas, klinik, semua }

/// Kartu putih kecil: kotak ikon berwarna + label di bawahnya.
class _KategoriCard extends StatelessWidget {
  final String nama;
  final KategoriJenis jenis;
  final Color warna;
  final VoidCallback onTap;
  const _KategoriCard(
      {required this.nama,
      required this.jenis,
      required this.warna,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
                color: Color(0x14000000), blurRadius: 10, offset: Offset(0, 2))
          ],
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          KategoriIkon(jenis: jenis, warna: warna, size: 56),
          const SizedBox(height: 8),
          Text(nama,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontSize: 11, fontWeight: FontWeight.w600, color: svText)),
        ]),
      ),
    );
  }
}

/// Kotak membulat berwarna + ikon putih (digambar sendiri, tanpa file gambar).
class KategoriIkon extends StatelessWidget {
  final KategoriJenis jenis;
  final Color warna;
  final double size;
  const KategoriIkon(
      {super.key, required this.jenis, required this.warna, this.size = 56});

  @override
  Widget build(BuildContext context) => CustomPaint(
      size: Size(size, size), painter: _IkonPainter(jenis, warna));
}

class _IkonPainter extends CustomPainter {
  final KategoriJenis jenis;
  final Color warna;
  _IkonPainter(this.jenis, this.warna);

  @override
  void paint(Canvas canvas, Size size) {
    // semua koordinat dihitung pada kanvas 100 x 100, lalu diskalakan
    canvas.scale(size.width / 100, size.height / 100);

    final isi = Paint()..color = warna;
    final putih = Paint()..color = Colors.white;
    final garis = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    RRect kotak(double x0, double y0, double x1, double y1, double r) =>
        RRect.fromLTRBR(x0, y0, x1, y1, Radius.circular(r));

    // kotak berwarna
    canvas.drawRRect(kotak(0, 0, 100, 100, 29), isi);

    switch (jenis) {
      case KategoriJenis.rumahSakit:
        // gedung: blok atas + badan, lalu tanda tambah berwarna di tengah
        canvas.drawRRect(kotak(38, 22, 62, 44, 4), putih);
        canvas.drawRRect(kotak(22, 36, 78, 78, 5), putih);
        canvas.drawRRect(kotak(43.5, 46, 56.5, 70, 2.5), isi);
        canvas.drawRRect(kotak(38, 52.5, 62, 63.5, 2.5), isi);
        break;

      case KategoriJenis.puskesmas:
        // tanda tambah tebal
        canvas.drawRRect(kotak(40, 22, 60, 78, 5), putih);
        canvas.drawRRect(kotak(22, 40, 78, 60, 5), putih);
        break;

      case KategoriJenis.klinik:
        // stetoskop: dua selang + selang ke bawah + kepala stetoskop
        final selang = Path()
          ..moveTo(34, 22)
          ..lineTo(34, 40)
          ..cubicTo(34, 56, 52, 56, 52, 40)
          ..lineTo(52, 22);
        canvas.drawPath(selang, garis);
        final kebawah = Path()
          ..moveTo(43, 53)
          ..cubicTo(43, 76, 68, 76, 68, 62);
        canvas.drawPath(kebawah, garis);
        canvas.drawCircle(
            const Offset(68, 56), 6.5, garis..strokeWidth = 4.5);
        break;

      case KategoriJenis.semua:
        // grid 2 x 2
        for (final x in const [26.0, 54.0]) {
          for (final y in const [26.0, 54.0]) {
            canvas.drawRRect(kotak(x, y, x + 20, y + 20, 5), putih);
          }
        }
        break;
    }
  }

  @override
  bool shouldRepaint(covariant _IkonPainter old) =>
      old.jenis != jenis || old.warna != warna;
}