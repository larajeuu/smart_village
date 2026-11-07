import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../data/faskes.dart';

/// Notifikasi sistem (muncul di status bar dan lock screen).
class NotificationService {
  NotificationService._();
  static final instance = NotificationService._();

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _siap = false;
  int _nextId = 0;

  static const _detailAndroid = AndroidNotificationDetails(
    'geofence_channel',
    'Area Fasilitas Kesehatan',
    channelDescription:
        'Pemberitahuan saat Anda memasuki area fasilitas kesehatan',
    importance: Importance.high,
    priority: Priority.high,
    visibility:
        NotificationVisibility.public, // isi tampil penuh di lock screen
  );

  /// Dipanggil sekali saat app start.
  Future<void> init() async {
    try {
      const android = AndroidInitializationSettings('@mipmap/ic_launcher');
      await _plugin.initialize(
        settings: const InitializationSettings(android: android),
      );
      // Android 13+: izin notifikasi harus diminta saat runtime.
      await _plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
      _siap = true;
    } catch (_) {
      // Gagal init tidak boleh membuat app crash saat start.
      _siap = false;
    }
  }

  /// Dipanggil saat user masuk area geofence.
  Future<void> showGeofenceEnter(Faskes faskes) async {
    if (!_siap) return;
    await _plugin.show(
      id: _nextId++,
      title: 'Anda masuk area ${faskes.nama}',
      body: '${faskes.jenis} • radius ${faskes.radius.round()} m',
      notificationDetails: const NotificationDetails(android: _detailAndroid),
    );
  }
}
