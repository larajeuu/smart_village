import 'package:flutter/material.dart';
import '../data/faskes.dart';
import 'peta_lokasi_screen.dart';

class DetailScreen extends StatelessWidget {
  final Faskes faskes;
  const DetailScreen({super.key, required this.faskes});

  @override
  Widget build(BuildContext context) {
    final f = faskes;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        title: const Text('Detail Fasilitas',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.share), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // FOTO BESAR
            faskesFoto(f, w: double.infinity, h: 200),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(f.nama,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 8),

                  // CHIP JENIS (warna sesuai tugas)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: bgJenis(f.jenis),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      f.jenis,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: fgJenis(f.jenis),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 4),
                      Text('${f.rating}',
                          style:
                              const TextStyle(fontWeight: FontWeight.w600)),
                      Text(' (${f.ulasan} ulasan)',
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 13)),
                    ],
                  ),
                  const Divider(height: 32),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ValueListenableBuilder(
                          valueListenable: userPos,
                          builder: (_, pos, __) => _info(
                            Icons.location_on,
                            '${jarakKm(f, pos).toStringAsFixed(1)} km',
                            f.alamat,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: _info(Icons.phone, f.telepon, 'Telepon')),
                    ],
                  ),
                  const Divider(height: 32),
                  const Text('Jenis Pelayanan',
                      style: TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 16)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: f.layanan
                        .map((l) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 7),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEAF1FB),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Text(l,
                                  style: const TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF3B5B8C))),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // TOMBOL "LIHAT DI PETA" (biru solid seperti tugas)
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 14),
          child: SizedBox(
            height: 52,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1668E3),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: const Icon(Icons.navigation, size: 20),
              label: const Text(
                'Lihat di Peta',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => PetaLokasiScreen(focus: f)),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _info(IconData icon, String judul, String sub) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: const Color(0xFF1668E3)),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(judul, style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 2),
              Text(sub,
                  style: const TextStyle(fontSize: 11, color: Colors.grey)),
            ],
          ),
        ),
      ],
    );
  }
}