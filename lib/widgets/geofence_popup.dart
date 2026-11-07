import 'package:flutter/material.dart';

import '../data/faskes.dart';
import '../screens/detail_screen.dart';
import 'common.dart';
import 'sv_theme.dart';

/// Popup "Anda Masuk Area Geofencing".
/// Dipanggil dari main.dart saat user masuk radius sebuah fasilitas.
Future<void> showGeofencePopup(BuildContext context, Faskes faskes) {
  return showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      icon: CircleAvatar(
        radius: 28,
        backgroundColor: warnaKategori(faskes.kategori),
        child:
            Icon(ikonKategori(faskes.kategori), color: Colors.white, size: 30),
      ),
      title:
          const Text('Anda Masuk Area Geofencing', textAlign: TextAlign.center),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(faskes.nama,
              textAlign: TextAlign.center,
              style:
                  const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text('${faskes.jenis} • ${jarakStr(faskes)} dari lokasimu',
              textAlign: TextAlign.center,
              style: const TextStyle(color: svSub)),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Tutup'),
        ),
        FilledButton(
          onPressed: () {
            // Ambil navigator dulu, baru tutup dialog, lalu buka Detail.
            final nav = Navigator.of(ctx);
            nav.pop();
            nav.push(MaterialPageRoute(
                builder: (_) => DetailScreen(faskes: faskes)));
          },
          child: const Text('Lihat Detail'),
        ),
      ],
    ),
  );
}
