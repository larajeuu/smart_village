import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../data/faskes.dart';
import '../main.dart' show messengerKey;
import '../widgets/sv_theme.dart';

enum JenisNotif { masuk, keluar }

class Notifikasi {
  final String id;
  final JenisNotif jenis;
  final Faskes faskes;
  final DateTime waktu;
  final bool dibaca;

  const Notifikasi({
    required this.id,
    required this.jenis,
    required this.faskes,
    required this.waktu,
    this.dibaca = false,
  });

  Notifikasi sudahDibaca() => Notifikasi(
      id: id, jenis: jenis, faskes: faskes, waktu: waktu, dibaca: true);

  String get judul => jenis == JenisNotif.masuk
      ? 'Anda masuk area ${faskes.nama}'
      : 'Anda meninggalkan area ${faskes.nama}';

  String get isi => jenis == JenisNotif.masuk
      ? 'Anda berada dalam radius ${faskes.radius.round()} m dari ${faskes.nama}. Ketuk untuk melihat detail fasilitas.'
      : 'Anda sudah keluar dari radius ${faskes.radius.round()} m ${faskes.nama}.';
}

String waktuRelatif(DateTime t) {
  final s = DateTime.now().difference(t);
  if (s.inMinutes < 1) return 'Baru saja';
  if (s.inMinutes < 60) return '${s.inMinutes} menit lalu';
  if (s.inHours < 24) return '${s.inHours} jam lalu';
  final h = t.hour.toString().padLeft(2, '0');
  final m = t.minute.toString().padLeft(2, '0');
  return '${t.day}/${t.month} $h:$m';
}

/// Geofencing di sisi aplikasi: memantau [userPos] terhadap radius tiap
/// fasilitas (rumus Haversine). Saat masuk / keluar radius, dibuat notifikasi
/// yang tampil di layar Notifikasi (lonceng di Beranda).
class NotifikasiService {
  NotifikasiService._();
  static final instance = NotifikasiService._();

  final items = ValueNotifier<List<Notifikasi>>([]);
  final Set<String> _didalam = {};
  bool _jalan = false;

  /// Aman dipanggil berkali-kali; hanya aktif sekali.
  void mulai() {
    if (_jalan) return;
    _jalan = true;
    _cek(userPos.value);
    userPos.addListener(() => _cek(userPos.value));
  }

  void _cek(LatLng p) {
    for (final f in daftarFaskes) {
      final dalam = dalamGeofence(f, p);
      if (dalam && _didalam.add(f.nama)) {
        _tambah(JenisNotif.masuk, f);
      } else if (!dalam && _didalam.remove(f.nama)) {
        _tambah(JenisNotif.keluar, f);
      }
    }
  }

  void _tambah(JenisNotif jenis, Faskes f) {
    final now = DateTime.now();
    final n = Notifikasi(
        id: '${now.microsecondsSinceEpoch}-${f.nama}',
        jenis: jenis,
        faskes: f,
        waktu: now);
    items.value = [n, ...items.value];

    messengerKey.currentState
      ?..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: jenis == JenisNotif.masuk ? svBlue : Colors.orange[800],
        content: Text(n.judul),
      ));
  }

  void tandaiDibaca(String id) {
    items.value =
        items.value.map((n) => n.id == id ? n.sudahDibaca() : n).toList();
  }

  void tandaiSemua() {
    items.value = items.value.map((n) => n.sudahDibaca()).toList();
  }

  void hapus(String id) {
    items.value = items.value.where((n) => n.id != id).toList();
  }

  void hapusSemua() => items.value = [];
}