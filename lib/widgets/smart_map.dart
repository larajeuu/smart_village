import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import '../data/faskes.dart';
import '../screens/detail_screen.dart';

class SmartMap extends StatefulWidget {
  final List<Faskes> points;
  final bool showGeofence;
  final Faskes? focus;

  const SmartMap({
    super.key,
    required this.points,
    this.showGeofence = true,
    this.focus,
  });

  @override
  State<SmartMap> createState() => _SmartMapState();
}

class _SmartMapState extends State<SmartMap> {
  final MapController _controller = MapController();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: userPos,
      builder: (context, pos, _) {
        return Stack(
          children: [
            FlutterMap(
              mapController: _controller,
              options: MapOptions(
                initialCenter: widget.focus?.pos ?? pos,
                initialZoom: 14,
                // tekan lama di peta = pindahkan lokasi simulasi (untuk emulator)
                onLongPress: (_, latLng) => userPos.value = latLng,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.smart_village',
                ),
                if (widget.showGeofence)
                  CircleLayer(
                    circles: widget.points
                        .map((f) => CircleMarker(
                              point: f.pos,
                              radius: f.radius,
                              useRadiusInMeter: true,
                              color: warnaKategori(f.kategori).withOpacity(0.15),
                              borderColor: warnaKategori(f.kategori),
                              borderStrokeWidth: 2,
                            ))
                        .toList(),
                  ),
                MarkerLayer(
                  markers: [
                    ...widget.points.map((f) => Marker(
                          point: f.pos,
                          width: 44,
                          height: 44,
                          child: GestureDetector(
                            onTap: () => showFaskesSheet(context, f),
                            child: Icon(ikonKategori(f.kategori),
                                color: warnaKategori(f.kategori), size: 36),
                          ),
                        )),
                    Marker(
                      point: pos,
                      width: 24,
                      height: 24,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Positioned(
              right: 16,
              bottom: 16,
              child: FloatingActionButton.small(
                heroTag: null,
                backgroundColor: Colors.white,
                onPressed: () => _controller.move(pos, 15),
                child: const Icon(Icons.my_location, color: Colors.blue),
              ),
            ),
          ],
        );
      },
    );
  }
}

void showFaskesSheet(BuildContext context, Faskes f) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: faskesFoto(f, w: 72, h: 72),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(f.nama,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    Text(f.jenis),
                    Text('${jarakKm(f, userPos.value).toStringAsFixed(1)} km dari lokasimu',
                        style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => DetailScreen(faskes: f)));
              },
              child: const Text('Lihat Detail'),
            ),
          ),
        ],
      ),
    ),
  );
}