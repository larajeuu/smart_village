import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class Faskes {
  final String nama;
  final String kategori; // 'Rumah Sakit' / 'Puskesmas' / 'Klinik'
  final String jenis; // 'RS Umum' / 'RS Khusus' / 'Puskesmas' / 'Klinik'
  final String foto;
  final String alamat;
  final String telepon;
  final double rating;
  final LatLng pos;
  final double radius; // meter (geofence)
  final List<String> layanan;
  final int ulasan;

  const Faskes({
    required this.nama,
    required this.kategori,
    required this.jenis,
    required this.foto,
    required this.alamat,
    required this.telepon,
    required this.rating,
    required this.pos,
    required this.radius,
    required this.layanan,
    this.ulasan = 120,
  });
}

// ======== DATA FASILITAS (edit di sini) ========
// Koordinat contoh ada di sekitar Jakarta. Ganti sesuai desa/kabupatenmu.
const List<Faskes> daftarFaskes = [
  Faskes(
    nama: 'RSUD Kabupaten X',
    kategori: 'Rumah Sakit',
    jenis: 'RS Umum',
    foto: 'assets/images/rsud_kabupaten_x.jpeg',
    alamat: 'Jl. Raya Kabupaten X No.10, Desa Sukamaju',
    telepon: '(021) 1234 5678',
    rating: 4.5,
    pos: LatLng(-6.2000, 106.8400),
    radius: 300,
    layanan: [
      'IGD',
      'Poliklinik',
      'Rawat Inap',
      'Laboratorium',
      'Radiologi',
      'Farmasi',
      'Rehabilitasi',
    ],
  ),
  Faskes(
    nama: 'RS Harapan Bunda',
    kategori: 'Rumah Sakit',
    jenis: 'RS Umum',
    foto: 'assets/images/rs_harapan_bunda.jpeg',
    alamat: 'Jl. Harapan No. 5, Desa Sukamaju',
    telepon: '(021) 2345 6789',
    rating: 4.3,
    pos: LatLng(-6.2150, 106.8500),
    radius: 250,
    layanan: ['IGD', 'Poliklinik', 'Rawat Inap'],
  ),
  Faskes(
    nama: 'RS Sumber Sehat',
    kategori: 'Rumah Sakit',
    jenis: 'RS Khusus',
    foto: 'assets/images/rs_sumber_sehat.jpeg',
    alamat: 'Jl. Sehat No. 8, Desa Sukamaju',
    telepon: '(021) 3456 7890',
    rating: 4.2,
    pos: LatLng(-6.2250, 106.8300),
    radius: 250,
    layanan: ['Mata', 'Bedah', 'Rawat Inap'],
  ),
  Faskes(
    nama: 'RS Mitra Keluarga',
    kategori: 'Rumah Sakit',
    jenis: 'RS Umum',
    foto: 'assets/images/rs_mitra_keluarga.jpeg',
    alamat: 'Jl. Mitra No. 12, Desa Sukamaju',
    telepon: '(021) 4567 8901',
    rating: 4.4,
    pos: LatLng(-6.1900, 106.8600),
    radius: 300,
    layanan: ['IGD', 'Poliklinik', 'Laboratorium'],
  ),
  Faskes(
    nama: 'Puskesmas Sukamaju',
    kategori: 'Puskesmas',
    jenis: 'Puskesmas',
    foto: 'assets/images/puskesmas_sukamaju.jpeg',
    alamat: 'Jl. Desa No. 2, Desa Sukamaju',
    telepon: '(021) 5678 9012',
    rating: 4.0,
    pos: LatLng(-6.2100, 106.8350),
    radius: 200,
    layanan: ['Poliklinik', 'KIA', 'Imunisasi'],
  ),
  Faskes(
    nama: 'Klinik Sehat Mandiri',
    kategori: 'Klinik',
    jenis: 'Klinik',
    foto: 'assets/images/klinik_sehat_mandiri.jpeg',
    alamat: 'Jl. Mandiri No. 3, Desa Sukamaju',
    telepon: '(021) 6789 0123',
    rating: 4.1,
    pos: LatLng(-6.2050, 106.8550),
    radius: 200,
    layanan: ['Poliklinik', 'Laboratorium'],
  ),
];

// ======== JENIS PELAYANAN ========
/// 7 layanan utama yang tampil sebagai ikon di halaman Detail.
/// Layanan lain (KIA, Gigi, Mata, dst.) dibuka lewat tombol "Lainnya".
const List<String> layananUtama = [
  'Poliklinik',
  'IGD',
  'Rawat Inap',
  'Laboratorium',
  'Radiologi',
  'Farmasi',
  'Rehabilitasi',
];

const Map<String, String> deskripsiLayanan = {
  'Poliklinik':
      'Pemeriksaan dan konsultasi dengan dokter umum maupun spesialis tanpa perlu menginap (rawat jalan).',
  'IGD':
      'Instalasi Gawat Darurat. Menangani kondisi darurat yang membutuhkan pertolongan segera, buka 24 jam.',
  'Rawat Inap':
      'Perawatan pasien yang perlu menginap, lengkap dengan kamar, perawat, dan pemantauan dokter.',
  'Laboratorium':
      'Pemeriksaan sampel darah, urin, dan lainnya untuk membantu dokter menegakkan diagnosis.',
  'Radiologi':
      'Pemeriksaan penunjang berbasis pencitraan seperti rontgen, USG, dan CT scan.',
  'Farmasi':
      'Penyediaan dan konsultasi obat sesuai resep dokter oleh apoteker.',
  'Rehabilitasi':
      'Terapi pemulihan fungsi tubuh, misalnya fisioterapi setelah cedera atau operasi.',
  'Umum': 'Pemeriksaan kesehatan umum oleh dokter umum.',
  'KIA':
      'Kesehatan Ibu dan Anak: pemeriksaan kehamilan, persalinan, serta tumbuh kembang anak.',
  'Imunisasi': 'Pemberian vaksin dasar dan lanjutan untuk bayi, anak, dan dewasa.',
  'Gigi': 'Pemeriksaan dan perawatan kesehatan gigi dan mulut.',
  'Mata': 'Pemeriksaan dan penanganan penyakit mata oleh dokter spesialis.',
  'Bedah': 'Tindakan operasi umum maupun spesialis oleh tim bedah.',
};

String deskripsiDari(String layanan, Faskes f) =>
    deskripsiLayanan[layanan] ?? 'Layanan $layanan tersedia di ${f.nama}.';

IconData ikonLayananLain(String nama) {
  switch (nama) {
    case 'KIA':
      return Icons.child_care;
    case 'Imunisasi':
      return Icons.vaccines;
    case 'Mata':
      return Icons.visibility_outlined;
    case 'Bedah':
      return Icons.healing;
    case 'Umum':
      return Icons.person_outline;
    default:
      return Icons.local_hospital_outlined;
  }
}

// ======== POSISI PENGGUNA (LBS) ========
// Titik awal demo. Dipakai kalau GPS mati / izin ditolak / belum dapat sinyal.
// Dipilih supaya 3 fasilitas terdekat = RSUD, Puskesmas, Klinik (sama dgn desain).
const LatLng posisiAwal = LatLng(-6.1930, 106.8310);
final ValueNotifier<LatLng> userPos = ValueNotifier<LatLng>(posisiAwal);

/// true = lokasi digeser manual (tekan lama di peta), update GPS diabaikan.
bool modeSimulasi = false;
StreamSubscription<Position>? _gpsSub;

/// Minta izin, ambil posisi GPS, lalu pantau terus selama aplikasi berjalan.
Future<void> initLocation() async {
  try {
    final enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) return;
    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }
    if (perm == LocationPermission.denied ||
        perm == LocationPermission.deniedForever) {
      return;
    }

    // pantau perubahan posisi (update tiap bergerak >= 10 meter)
    await _gpsSub?.cancel();
    _gpsSub = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high, distanceFilter: 10),
    ).listen((p) {
      if (!modeSimulasi) userPos.value = LatLng(p.latitude, p.longitude);
    });

    final p = await Geolocator.getCurrentPosition();
    if (!modeSimulasi) userPos.value = LatLng(p.latitude, p.longitude);
  } catch (_) {
    // gagal ambil GPS: tetap pakai posisi terakhir / posisiAwal
  }
}

/// Dipakai tekan-lama di peta (untuk emulator / demo).
void setPosisiSimulasi(LatLng p) {
  modeSimulasi = true;
  userPos.value = p;
}

/// Matikan simulasi, kembali membaca GPS.
Future<void> kembaliKeGps() async {
  modeSimulasi = false;
  userPos.value = posisiAwal;
  await initLocation();
}

/// Jarak dua titik (meter) dengan rumus Haversine.
double jarakMeter(LatLng a, LatLng b) {
  const r = 6371000.0; // jari-jari bumi (meter)
  double rad(double d) => d * math.pi / 180;
  final dLat = rad(b.latitude - a.latitude);
  final dLon = rad(b.longitude - a.longitude);
  final s1 = math.sin(dLat / 2);
  final s2 = math.sin(dLon / 2);
  final h = s1 * s1 +
      math.cos(rad(a.latitude)) * math.cos(rad(b.latitude)) * s2 * s2;
  return 2 * r * math.asin(math.sqrt(h.clamp(0.0, 1.0)));
}

double jarakKm(Faskes f, LatLng dari) => jarakMeter(dari, f.pos) / 1000;

/// Geofencing: true bila titik [p] berada di dalam radius fasilitas.
bool dalamGeofence(Faskes f, LatLng p) => jarakMeter(p, f.pos) <= f.radius;

// ======== WARNA, IKON, FOTO ========
Color warnaKategori(String kategori) {
  switch (kategori) {
    case 'Puskesmas':
      return Colors.green;
    case 'Klinik':
      return Colors.purple;
    default:
      return Colors.red;
  }
}

IconData ikonKategori(String kategori) {
  switch (kategori) {
    case 'Puskesmas':
      return Icons.home_work;
    case 'Klinik':
      return Icons.medical_services;
    default:
      return Icons.local_hospital;
  }
}

Widget faskesFoto(Faskes f, {double? w, double? h}) {
  return Image.asset(
    f.foto,
    width: w,
    height: h,
    fit: BoxFit.cover,
    errorBuilder: (_, __, ___) => Container(
      width: w,
      height: h,
      color: Colors.grey.shade200,
      child: Icon(ikonKategori(f.kategori), color: Colors.grey, size: 36),
    ),
  );
}

// Warna chip jenis (sesuai tugas)
Color bgJenis(String jenis) {
  switch (jenis) {
    case 'RS Khusus':
      return const Color(0xFFDCEBFF); // biru muda
    case 'Klinik':
      return const Color(0xFFEBDDFA); // ungu muda
    default:
      return const Color(0xFFD8F5DF); // hijau muda (RS Umum, Puskesmas)
  }
}

Color fgJenis(String jenis) {
  switch (jenis) {
    case 'RS Khusus':
      return const Color(0xFF1668E3); // biru
    case 'Klinik':
      return const Color(0xFF7B3FC4); // ungu
    default:
      return const Color(0xFF1E9E4A); // hijau
  }
}