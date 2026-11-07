import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../data/faskes.dart';
import '../screens/detail_screen.dart';
import 'sv_theme.dart';
import 'common.dart';

Color pinColor(Faskes f) {
  if (f.nama == 'RS Sumber Sehat' || f.nama == 'RS Mitra Keluarga') {
    return const Color(0xFFF59E0B);
  }
  return warnaKategori(f.kategori);
}

class LokasiMap extends StatefulWidget {
  final List<Faskes> points;
  final bool showGeofence, showLabels, showFabs;
  final Faskes? focus;
  final List<LatLng>? route;
  final List<LatLng>? fit;

  /// URL tile peta. null = OpenStreetMap standar.
  final String? tileUrl;
  const LokasiMap({
    super.key,
    required this.points,
    this.showGeofence = false,
    this.showLabels = true,
    this.showFabs = true,
    this.focus,
    this.route,
    this.fit,
    this.tileUrl,
  });
  @override
  State<LokasiMap> createState() => _LokasiMapState();
}

class _LokasiMapState extends State<LokasiMap> {
  final MapController _c = MapController();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<LatLng>(
      valueListenable: userPos,
      builder: (context, pos, _) => Stack(children: [
        FlutterMap(
          mapController: _c,
          options: MapOptions(
            initialCenter: widget.focus?.pos ?? pos,
            initialZoom: 14.5,
            initialCameraFit: widget.fit == null
                ? null
                : CameraFit.coordinates(
                    coordinates: widget.fit!,
                    padding: const EdgeInsets.all(70)),
            // tekan lama = geser lokasi simulasi (untuk emulator)
            onLongPress: (_, p) {
              setPosisiSimulasi(p);
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(const SnackBar(
                    content: Text(
                        'Lokasi simulasi dipindahkan. Ketuk tombol lokasi untuk kembali ke GPS.')));
            },
          ),
          children: [
            TileLayer(
              key: ValueKey(widget.tileUrl),
              urlTemplate: widget.tileUrl ??
                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.smart_village',
            ),
            if (widget.showGeofence)
              CircleLayer(
                circles: widget.points
                    .map((f) => CircleMarker(
                          point: f.pos,
                          radius: f.radius,
                          useRadiusInMeter: true,
                          color: svBlue.withOpacity(0.15),
                          borderColor: svBlue,
                          borderStrokeWidth: 1.5,
                        ))
                    .toList(),
              ),
            if (widget.route != null)
              PolylineLayer(polylines: [
                Polyline(points: widget.route!, strokeWidth: 5, color: svBlue)
              ]),
            MarkerLayer(markers: [
              if (widget.showLabels)
                ...widget.points.map((f) => Marker(
                      point: f.pos,
                      width: 130,
                      height: 20,
                      alignment: Alignment.bottomCenter,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 1),
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.92),
                              borderRadius: BorderRadius.circular(4)),
                          child: Text(f.nama,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.w500)),
                        ),
                      ),
                    )),
              ...widget.points.map((f) => Marker(
                    point: f.pos,
                    width: 40,
                    height: 40,
                    alignment: Alignment.topCenter,
                    child: GestureDetector(
                      onTap: () => showFaskesSheet(context, f),
                      child:
                          Icon(Icons.location_on, color: pinColor(f), size: 38),
                    ),
                  )),
              Marker(
                point: pos,
                width: 44,
                height: 44,
                child: Container(
                  decoration: BoxDecoration(
                      color: const Color(0xFF2F6DF6).withOpacity(0.25),
                      shape: BoxShape.circle),
                  alignment: Alignment.center,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                        color: const Color(0xFF2F6DF6),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3)),
                  ),
                ),
              ),
            ]),
          ],
        ),
        if (widget.showFabs)
          Positioned(
            right: 12,
            bottom: 14,
            child: Column(children: [
              _Fab(Icons.navigation, svBlue, () {
                final f = widget.focus ??
                    (widget.points.isEmpty ? null : widget.points.first);
                if (f != null) _c.move(f.pos, 15.5);
              }),
              const SizedBox(height: 10),
              _Fab(Icons.my_location, svSub, () async {
                // kalau sedang simulasi, kembali membaca GPS dulu
                if (modeSimulasi) await kembaliKeGps();
                if (!mounted) return;
                _c.move(userPos.value, 15.5);
              }),
            ]),
          ),
      ]),
    );
  }
}

class _Fab extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _Fab(this.icon, this.color, this.onTap);
  @override
  Widget build(BuildContext context) => Material(
        color: Colors.white,
        elevation: 3,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox(
              width: 42, height: 42, child: Icon(icon, color: color, size: 20)),
        ),
      );
}

void showFaskesSheet(BuildContext context, Faskes f) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (_) => Padding(
      padding: const EdgeInsets.all(18),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Row(children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: faskesFoto(f, w: 72, h: 72)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(f.nama,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Row(children: [
                const Icon(Icons.location_on, size: 14, color: svBlue),
                Text(jarakStr(f),
                    style: const TextStyle(fontSize: 12, color: svMut)),
                const SizedBox(width: 10),
                const Icon(Icons.star, size: 14, color: Color(0xFFF5B301)),
                Text(rt(f.rating),
                    style: const TextStyle(fontSize: 12, color: svMut)),
              ]),
            ]),
          ),
        ]),
        const SizedBox(height: 14),
        Row(children: [
          Expanded(
            child: FilledButton(
              style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(46),
                  backgroundColor: svBlue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14))),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => DetailScreen(faskes: f)));
              },
              child: const Text('Lihat Detail'),
            ),
          ),
        ]),
      ]),
    ),
  );
}