import 'package:flutter/material.dart';
import '../models/facility.dart';
import '../services/location_service.dart';
import '../theme.dart';
import 'map_screen.dart';

class DetailScreen extends StatelessWidget {
  final Facility facility;
  const DetailScreen({super.key, required this.facility});

  @override
  Widget build(BuildContext context) {
    final f = facility;
    final svc = LocationService.instance;
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Fasilitas')),
      body: ListView(children: [
        Container(
          height: 180,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(colors: [f.type.color.withOpacity(.25), kBg]),
          ),
          child: Icon(f.type.icon, size: 90, color: f.type.color),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(f.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(color: Colors.green.withOpacity(.15), borderRadius: BorderRadius.circular(6)),
              child: Text(f.category, style: const TextStyle(fontSize: 11, color: Colors.green)),
            ),
            const SizedBox(height: 8),
            Row(children: [
              const Icon(Icons.star, color: Colors.amber, size: 18),
              Text(' ${f.rating}', style: const TextStyle(fontSize: 12)),
            ]),
            const Divider(height: 28),
            ValueListenableBuilder(
              valueListenable: svc.position,
              builder: (_, __, ___) => Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(child: _info(Icons.location_on, Colors.red, LocationService.format(svc.distanceTo(f)), f.address)),
                Expanded(child: _info(Icons.phone, kPrimary, f.phone, 'Telepon')),
              ]),
            ),
            const SizedBox(height: 20),
            const Text('Jenis Pelayanan', style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: f.services
                  .map((s) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(color: kPrimary.withOpacity(.1), borderRadius: BorderRadius.circular(8)),
                        child: Text(s, style: const TextStyle(fontSize: 12, color: kPrimary)),
                      ))
                  .toList(),
            ),
          ]),
        ),
      ]),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: FilledButton.icon(
          style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(50)),
          icon: const Icon(Icons.navigation),
          label: const Text('Lihat di Peta'),
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => MapScreen(focus: f))),
        ),
      ),
    );
  }

  Widget _info(IconData i, Color c, String t, String s) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(i, color: c, size: 18),
          const SizedBox(width: 6),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(t, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
              Text(s, style: const TextStyle(fontSize: 10, color: Colors.black54)),
            ]),
          ),
        ],
      );
}
