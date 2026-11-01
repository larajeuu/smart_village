import 'package:flutter/material.dart';
import '../models/facility.dart';
import '../services/location_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final svc = LocationService.instance;
    return Scaffold(
      appBar: AppBar(title: const Text('Profil & Status Lokasi')),
      body: ValueListenableBuilder(
        valueListenable: svc.position,
        builder: (_, p, __) => ListView(padding: const EdgeInsets.all(16), children: [
          ListTile(
            leading: const Icon(Icons.gps_fixed),
            title: Text('${p.latitude.toStringAsFixed(5)}, ${p.longitude.toStringAsFixed(5)}'),
            subtitle: Text(svc.status.value),
          ),
          Row(children: [
            Expanded(child: OutlinedButton(onPressed: svc.useGps, child: const Text('Gunakan GPS'))),
            const SizedBox(width: 8),
            Expanded(child: OutlinedButton(onPressed: () => svc.simulate(demoCenter), child: const Text('Lokasi Demo'))),
          ]),
          const Divider(height: 32),
          const Text('Status Geofence', style: TextStyle(fontWeight: FontWeight.bold)),
          for (final f in facilities)
            ListTile(
              dense: true,
              leading: Icon(svc.insideIds.contains(f.id) ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: svc.insideIds.contains(f.id) ? Colors.green : Colors.grey),
              title: Text(f.name),
              subtitle: Text('${LocationService.format(svc.distanceTo(f))} • radius ${f.geofenceRadius.round()} m'),
            ),
        ]),
      ),
    );
  }
}
