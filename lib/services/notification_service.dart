import '../models/facility.dart';

/// STUB - kerangka kosong. Isi aslinya (flutter_local_notifications)
/// dikerjakan di branch fitur notifikasi.
class NotificationService {
  NotificationService._();
  static final instance = NotificationService._();

  /// Dipanggil sekali saat app start.
  Future<void> init() async {
    // TODO: inisialisasi plugin notifikasi
  }

  /// Dipanggil saat user masuk area geofence.
  Future<void> showGeofenceEnter(Facility facility) async {
    // TODO: tampilkan notifikasi sistem
  }
}
