import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  // Pertanyaan dipisah dari tampilan, jadi gampang ditambah atau diubah.
  static const _faqs = <(String, String)>[
    (
      'Bagaimana cara mencari fasilitas kesehatan?',
      'Buka tab Peta atau Beranda, lalu pilih jenis fasilitas yang dicari.'
    ),
    (
      'Bagaimana cara menyimpan fasilitas favorit?',
      'Buka halaman Detail fasilitas, lalu tekan ikon hati.'
    ),
    (
      'Kenapa lokasi saya tidak muncul?',
      'Pastikan GPS aktif dan izin lokasi sudah diberikan ke aplikasi.'
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bantuan')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          for (final (q, a) in _faqs)
            Card(
              child: ExpansionTile(
                title: Text(q),
                childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                children: [Text(a)],
              ),
            ),
        ],
      ),
    );
  }
}
