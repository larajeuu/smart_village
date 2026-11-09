import 'package:flutter/material.dart';

import '../data/faskes.dart';
import '../screens/peta_lokasi_screen.dart';
import 'lokasi_map.dart';
import 'sv_theme.dart';

/// Layar "Anda Masuk Area Geofencing" (peta + lingkaran radius + kartu).
/// Dipanggil dari main.dart saat user masuk radius sebuah fasilitas.
Future<void> showGeofencePopup(BuildContext context, Faskes faskes) {
  return Navigator.of(context).push(
    MaterialPageRoute<void>(builder: (_) => GeofenceScreen(faskes: faskes)),
  );
}

class GeofenceScreen extends StatelessWidget {
  final Faskes faskes;
  const GeofenceScreen({super.key, required this.faskes});

  @override
  Widget build(BuildContext context) {
    final f = faskes;
    return Scaffold(
      body: Stack(children: [
        Positioned.fill(
          child: LokasiMap(
            points: [f],
            focus: f,
            showGeofence: true,
            showLabels: false,
            showFabs: false,
          ),
        ),
        // peta sedikit diredupkan seperti desain
        Positioned.fill(
          child: IgnorePointer(
            child: Container(color: const Color(0xFF4B5563).withOpacity(0.25)),
          ),
        ),
        // pill radius
        SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Material(
                color: Colors.white,
                elevation: 3,
                borderRadius: BorderRadius.circular(18),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  child: Text('Radius ${f.radius.round()} m',
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w600)),
                ),
              ),
            ),
          ),
        ),
        // kartu bawah
        Align(
          alignment: Alignment.bottomCenter,
          child: SafeArea(
            child: Container(
              margin: const EdgeInsets.all(14),
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24)),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close, size: 22, color: svMut),
                  ),
                ),
                Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(
                      color: Color(0xFFDDF5E3), shape: BoxShape.circle),
                  child:
                      const Icon(Icons.where_to_vote, size: 36, color: svGreen),
                ),
                const SizedBox(height: 10),
                const Text('Anda Masuk Area Geofencing',
                    style:
                        TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Text(
                  'Selamat! Anda telah memasuki area ${f.nama} (radius ${f.radius.round()} m).',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 13, height: 1.5, color: svSub),
                ),
                const SizedBox(height: 16),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: svBlue,
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            PetaLokasiScreen(focus: f, showBack: true)),
                  ),
                  child: const Text('Lihat Lokasi',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: svText,
                    minimumSize: const Size.fromHeight(50),
                    side: const BorderSide(color: Color(0xFFCDD5E0)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Tutup',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                ),
              ]),
            ),
          ),
        ),
      ]),
    );
  }
}