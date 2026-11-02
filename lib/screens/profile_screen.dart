import 'package:flutter/material.dart';
import '../data/faskes.dart';

// ===== EDIT NAMA DI SINI =====
const String _nama = 'Nana';

const Color _biru = Color(0xFF1668E3);
const Color _biruMuda = Color(0xFFEAF1FB);
const Color _hijau = Color(0xFF1E9E4A);

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  String _format(double meter) => meter < 1000
      ? '${meter.round()} m'
      : '${(meter / 1000).toStringAsFixed(1)} km';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text('Profil',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17)),
      ),
      body: ValueListenableBuilder(
        valueListenable: userPos,
        builder: (context, pos, _) {
          // urutkan dari yang terdekat
          final urut = [...daftarFaskes]
            ..sort((a, b) => jarakKm(a, pos).compareTo(jarakKm(b, pos)));

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: Column(
              children: [
                // ===== AVATAR + NAMA =====
                CircleAvatar(
                  radius: 34,
                  backgroundColor: _biruMuda,
                  child: Text(
                    _nama.isNotEmpty ? _nama[0].toUpperCase() : '?',
                    style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: _biru),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(_nama,
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                const SizedBox(height: 18),

                // ===== LOKASI SAYA =====
                _kartu(
                  judul: 'Lokasi Saya',
                  ikon: Icons.my_location,
                  anak: Column(
                    children: [
                      _info('Latitude', pos.latitude.toStringAsFixed(5)),
                      _info('Longitude', pos.longitude.toStringAsFixed(5)),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // ===== STATUS GEOFENCE =====
                _kartu(
                  judul: 'Status Geofence',
                  ikon: Icons.radio_button_checked,
                  anak: Column(
                    children: urut.map((f) {
                      final meter = jarakKm(f, pos) * 1000;
                      final dalam = meter <= f.radius;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 7),
                        child: Row(
                          children: [
                            Icon(
                              dalam
                                  ? Icons.check_circle
                                  : Icons.radio_button_unchecked,
                              color: dalam ? _hijau : Colors.grey.shade400,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(f.nama,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14)),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${_format(meter)}  |  radius ${f.radius.round()} m',
                                    style: const TextStyle(
                                        fontSize: 11, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: dalam
                                    ? const Color(0xFFD8F5DF)
                                    : const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                dalam ? 'Di dalam' : 'Di luar',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: dalam ? _hijau : Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _kartu(
      {required String judul, required IconData ikon, required Widget anak}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(ikon, size: 20, color: _biru),
              const SizedBox(width: 8),
              Text(judul,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 16)),
            ],
          ),
          const Divider(height: 24),
          anak,
        ],
      ),
    );
  }

  Widget _info(String label, String nilai) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: _biruMuda,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.location_on, size: 20, color: _biru),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(fontSize: 11, color: Colors.grey)),
                const SizedBox(height: 2),
                Text(nilai,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}