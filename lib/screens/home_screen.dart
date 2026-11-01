import 'package:flutter/material.dart';
import '../models/facility.dart';
import '../theme.dart';
import 'facility_list_screen.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onOpenMap;
  const HomeScreen({super.key, required this.onOpenMap});

  void _open(BuildContext c, FacilityType t) => Navigator.push(
      c, MaterialPageRoute(builder: (_) => FacilityListScreen(type: t)));

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 28, 20, 36),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xFFBFE3FF), Color(0xFFE9F6FF)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter),
            ),
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  child: const Icon(Icons.add_circle, color: Colors.red, size: 30),
                ),
                const SizedBox(width: 10),
                const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Smart Village',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: kPrimary)),
                  Text('Sehat Bersama, Desa Maju', style: TextStyle(fontSize: 11)),
                ]),
              ]),
              const SizedBox(height: 18),
              const Text(
                'Cari lokasi Klinik, Puskesmas dan\nRumah Sakit terdekat di Kabupaten X',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Transform.translate(
              offset: const Offset(0, -34),
              child: Column(children: [
                TextField(
                  readOnly: true,
                  onTap: () => _open(context, FacilityType.hospital),
                  decoration: InputDecoration(
                    hintText: 'Cari nama fasilitas kesehatan...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 16),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 1.15,
                  children: [
                    _tile('Rumah Sakit', Icons.apartment, const Color(0xFFDCE9FF), kPrimary,
                        () => _open(context, FacilityType.hospital)),
                    _tile('Puskesmas', Icons.home_work, const Color(0xFFD9F5E3), const Color(0xFF2E9E5B),
                        () => _open(context, FacilityType.puskesmas)),
                    _tile('Klinik', Icons.medical_services, const Color(0xFFE9E1FA), const Color(0xFF7E57C2),
                        () => _open(context, FacilityType.clinic)),
                    _tile('Peta Lokasi', Icons.location_on, const Color(0xFFFFF0D2), const Color(0xFFF5A623),
                        onOpenMap),
                  ],
                ),
              ]),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _tile(String t, IconData i, Color bg, Color fg, VoidCallback onTap) =>
      InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(18)),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(i, size: 44, color: fg),
            const SizedBox(height: 8),
            Text(t, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          ]),
        ),
      );
}
