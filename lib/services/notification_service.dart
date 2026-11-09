import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../data/faskes.dart';
import '../main.dart' show navigatorKey;
import '../screens/detail_screen.dart';

/// Notifikasi sistem (muncul di status bar dan lock screen).
class NotificationService {
  NotificationService._();
  static final instance = NotificationService._();

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _siap = false;
  int _nextId = 0;

  /// Dipanggil sekali saat app start.
  Future<void> init() async {
    try {
      const android = AndroidInitializationSettings('@mipmap/ic_launcher');
      await _plugin.initialize(
        settings: const InitializationSettings(android: android),
        onDidReceiveNotificationResponse: _saatDiketuk,
      );
      // Android 13+: izin notifikasi harus diminta saat runtime.
      await _plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
      _siap = true;
    } catch (_) {
      _siap = false; // gagal init tidak boleh membuat app crash
    }
  }

  /// Notifikasi diketuk -> buka Detail faskes terkait (payload = nama faskes).
  void _saatDiketuk(NotificationResponse r) {
    final nama = r.payload;
    if (nama == null) return;
    for (final f in daftarFaskes) {
      if (f.nama == nama) {
        navigatorKey.currentState?.push(
          MaterialPageRoute(builder: (_) => DetailScreen(faskes: f)),
        );
        return;
      }
    }
  }

  /// Dipanggil saat user masuk area geofence.
  Future<void> showGeofenceEnter(Faskes faskes) async {
    if (!_siap) return;

    final jarak = jarakMeter(userPos.value, faskes.pos).round();
    final judul = 'Anda berada di area ${faskes.nama}';
    final isi = 'Jarak Anda: $jarak meter';

    // Foto fasilitas sebagai gambar besar; jika gagal, tampil tanpa gambar.
    StyleInformation? gaya;
    try {
      final data = await rootBundle.load(faskes.foto);
      gaya = BigPictureStyleInformation(
        ByteArrayAndroidBitmap(data.buffer.asUint8List()),
        contentTitle: judul,
        summaryText: isi,
      );
    } catch (_) {}

    await _plugin.show(
      id: _nextId++,
      title: judul,
      body: isi,
      payload: faskes.nama,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          'geofence_channel',
          'Area Fasilitas Kesehatan',
          channelDescription:
              'Pemberitahuan saat Anda memasuki area fasilitas kesehatan',
          importance: Importance.high,
          priority: Priority.high,
          visibility: NotificationVisibility.public,
          styleInformation: gaya,
        ),
      ),
    );
  }
}