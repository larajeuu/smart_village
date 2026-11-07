import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/faskes.dart';
import '../widgets/sv_theme.dart';
import 'list_screen.dart';

const _navy = Color(0xFF1B2B4B);
const _teal = Color(0xFF14998E);

/// Tampilan tombol "Lainnya" di halaman Detail:
/// layanan tambahan + seluruh layanan + informasi kontak fasilitas.
class LayananLainnyaScreen extends StatelessWidget {
  final Faskes faskes;
  const LayananLainnyaScreen({super.key, required this.faskes});

  void _salin(BuildContext context, String teks, String label) {
    Clipboard.setData(ClipboardData(text: teks));
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('$label disalin')));
  }

  @override
  Widget build(BuildContext context) {
    final f = faskes;
    final tambahan =
        f.layanan.where((l) => !layananUtama.contains(l)).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Layanan Lainnya',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
      ),
      body: ListView(padding: const EdgeInsets.fromLTRB(20, 8, 20, 28), children: [
        // ---- kepala: foto + nama + jenis ----
        Row(children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: faskesFoto(f, w: 60, h: 60)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(f.nama,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w800, color: _navy)),
              const SizedBox(height: 6),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                    color: bgJenis(f.jenis),
                    borderRadius: BorderRadius.circular(10)),
                child: Text(f.jenis,
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: fgJenis(f.jenis))),
              ),
            ]),
          ),
        ]),
        const SizedBox(height: 22),

        // ---- layanan tambahan ----
        const Text('Layanan Tambahan',
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.w700, color: _navy)),
        const SizedBox(height: 10),
        if (tambahan.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text('Tidak ada layanan tambahan di fasilitas ini.',
                style: TextStyle(fontSize: 12.5, color: svMut)),
          )
        else
          ...tambahan.map((l) => _KartuLayanan(faskes: f, nama: l)),
        const SizedBox(height: 22),

        // ---- semua layanan ----
        const Text('Semua Layanan',
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.w700, color: _navy)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: f.layanan
              .map((l) => ActionChip(
                    label: Text(l, style: const TextStyle(fontSize: 12)),
                    backgroundColor: const Color(0xFFEEF2F8),
                    side: BorderSide.none,
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ListScreen(
                                title: 'Daftar Lokasi',
                                cari: true,
                                cariAwal: l))),
                  ))
              .toList(),
        ),
        const SizedBox(height: 6),
        const Text('Ketuk layanan untuk mencari fasilitas lain yang menyediakannya.',
            style: TextStyle(fontSize: 11, color: svMut)),
        const SizedBox(height: 22),

        // ---- kontak ----
        const Text('Informasi Kontak',
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.w700, color: _navy)),
        const SizedBox(height: 8),
        _BarisKontak(
            ikon: Icons.phone_outlined,
            teks: f.telepon,
            onSalin: () => _salin(context, f.telepon, 'Nomor telepon')),
        _BarisKontak(
            ikon: Icons.location_on_outlined,
            teks: f.alamat,
            onSalin: () => _salin(context, f.alamat, 'Alamat')),
        _BarisKontak(
            ikon: Icons.radar,
            teks:
                'Radius geofence ${f.radius.round()} m · notifikasi muncul saat Anda masuk area ini'),
      ]),
    );
  }
}

class _KartuLayanan extends StatelessWidget {
  final Faskes faskes;
  final String nama;
  const _KartuLayanan({required this.faskes, required this.nama});

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
            color: const Color(0xFFF7FAFE),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: svLine)),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
                color: const Color(0xFFEFF5FD),
                borderRadius: BorderRadius.circular(14)),
            child: Icon(ikonLayananLain(nama), color: svBlue, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(nama,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w700, color: _navy)),
              const SizedBox(height: 3),
              Text(deskripsiDari(nama, faskes),
                  style: const TextStyle(
                      fontSize: 12, height: 1.45, color: svSub)),
            ]),
          ),
        ]),
      );
}

class _BarisKontak extends StatelessWidget {
  final IconData ikon;
  final String teks;
  final VoidCallback? onSalin;
  const _BarisKontak({required this.ikon, required this.teks, this.onSalin});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(ikon, size: 20, color: _teal),
          const SizedBox(width: 12),
          Expanded(
              child: Text(teks,
                  style: const TextStyle(
                      fontSize: 12.5, height: 1.5, color: svSub))),
          if (onSalin != null)
            InkWell(
              onTap: onSalin,
              borderRadius: BorderRadius.circular(8),
              child: const Padding(
                  padding: EdgeInsets.all(2),
                  child: Icon(Icons.copy, size: 18, color: svMut)),
            ),
        ]),
      );
}