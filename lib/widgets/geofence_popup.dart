import 'package:flutter/material.dart';
import '../services/location_service.dart';

/// PLACEHOLDER - popup "Anda Masuk Area Geofencing".
/// Kontrak: dipanggil dari main.dart saat event masuk area terjadi.
Future<void> showGeofencePopup(BuildContext context, GeofenceEvent event) {
  return showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Anda Masuk Area Geofencing'),
      content: Text('TODO: tampilan sesuai desain\n${event.facility.name}'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Tutup'),
        ),
      ],
    ),
  );
}
