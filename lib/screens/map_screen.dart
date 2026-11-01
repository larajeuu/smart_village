import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/facility.dart';
import '../services/location_service.dart';
import '../theme.dart';
import 'detail_screen.dart';

class MapScreen extends StatefulWidget {
  final Facility? focus;
  const MapScreen({super.key, this.focus});
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final _ctrl = MapController();
  final svc = LocationService.instance;
  final Set<FacilityType> _active = {...FacilityType.values};
  bool _geofence = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Peta Lokasi'),
        actions: [
          IconButton(
            tooltip: 'Pusatkan ke posisi saya',
            icon: const Icon(Icons.my_location),
            onPressed: () => _ctrl.move(svc.position.value, 15),
          ),
        ],
      ),
      body: ValueListenableBuilder<LatLng>(
        valueListenable: svc.position,
        builder: (_, me, __) {
          final shown = facilities.where((f) => _active.contains(f.type)).toList();
          return Stack(children: [
            FlutterMap(
              mapController: _ctrl,
              options: MapOptions(
                initialCenter: widget.focus?.pos ?? me,
                initialZoom: 15,
                // Tekan lama = simulasi pindah lokasi (untuk uji geofence)
                onLongPress: (_, p) => svc.simulate(p),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.smart_village',
                ),
                if (_geofence)
                  CircleLayer(circles: [
                    for (final f in shown)
                      CircleMarker(
                        point: f.pos,
                        radius: f.geofenceRadius,
                        useRadiusInMeter: true,
                        color: (svc.insideIds.contains(f.id) ? Colors.green : f.type.color).withOpacity(.15),
                        borderColor: svc.insideIds.contains(f.id) ? Colors.green : f.type.color,
                        borderStrokeWidth: 1.5,
                      ),
                  ]),
                MarkerLayer(markers: [
                  for (final f in shown)
                    Marker(
                      point: f.pos,
                      width: 90,
                      height: 64,
                      child: GestureDetector(
                        onTap: () => _sheet(f),
                        child: Column(children: [
                          Icon(Icons.location_on, color: f.type.color, size: 34),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            color: Colors.white70,
                            child: Text(f.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600)),
                          ),
                        ]),
                      ),
                    ),
                  Marker(
                    point: me,
                    width: 28,
                    height: 28,
                    child: Container(
                      decoration: BoxDecoration(
                        color: kPrimary,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: const [BoxShadow(blurRadius: 6, color: Colors.black38)],
                      ),
                    ),
                  ),
                ]),
              ],
            ),
            Positioned(
              top: 8, left: 12, right: 12,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Text(
                    '${svc.status.value}\nTekan lama peta untuk simulasi lokasi',
                    style: const TextStyle(fontSize: 11),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0, right: 0, bottom: 12,
              child: SizedBox(
                height: 44,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  children: [
                    for (final t in FacilityType.values)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          avatar: Icon(t.icon, size: 16, color: t.color),
                          label: Text(t.label),
                          backgroundColor: Colors.white,
                          selected: _active.contains(t),
                          onSelected: (v) => setState(() => v ? _active.add(t) : _active.remove(t)),
                        ),
                      ),
                    FilterChip(
                      avatar: const Icon(Icons.radar, size: 16, color: kPrimary),
                      label: const Text('Area Geofencing'),
                      backgroundColor: Colors.white,
                      selected: _geofence,
                      onSelected: (v) => setState(() => _geofence = v),
                    ),
                  ],
                ),
              ),
            ),
          ]);
        },
      ),
    );
  }

  void _sheet(Facility f) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(f.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text('${f.category} • ${LocationService.format(svc.distanceTo(f))} dari Anda'),
          Text(svc.insideIds.contains(f.id)
              ? 'Status geofence: DI DALAM area'
              : 'Status geofence: di luar area (radius ${f.geofenceRadius.round()} m)'),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => DetailScreen(facility: f)));
              },
              child: const Text('Lihat Detail'),
            ),
          ),
        ]),
      ),
    );
  }
}
