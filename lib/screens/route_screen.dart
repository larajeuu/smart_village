import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import '../data/faskes.dart';
import '../widgets/common.dart';
import '../widgets/sv_theme.dart';

/// Layar Rute. Dibuka dengan RouteScreen(faskes: f).
/// Rute jalan diambil dari OSRM (OpenStreetMap). Jika gagal/offline,
/// dipakai garis lurus x faktor jalan.
class RouteScreen extends StatefulWidget {
  final Faskes faskes;
  const RouteScreen({super.key, required this.faskes});

  @override
  State<RouteScreen> createState() => _RouteScreenState();
}

class _Moda {
  final String nama;
  final IconData ikon;
  final double kmPerJam;
  const _Moda(this.nama, this.ikon, this.kmPerJam);
}

// Urutan sama dengan desain: Mobil, Jalan, Motor.
const _modaList = <_Moda>[
  _Moda('Mobil', Icons.directions_car, 25),
  _Moda('Jalan', Icons.directions_walk, 5),
  _Moda('Motor', Icons.two_wheeler, 30),
];

const _faktorJalan = 1.3; // dipakai kalau rute online gagal
const _radiusTiba = 30.0; // meter
const _petaOsm = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';

// Peta OSM dibuat sedikit lebih pucat agar mirip desain (tanpa API key)
const _filterTerang = ColorFilter.matrix(<double>[
  0.606, 0.357, 0.036, 0, 18,
  0.107, 0.857, 0.036, 0, 18,
  0.107, 0.357, 0.536, 0, 18,
  0, 0, 0, 1, 0,
]);

class _RouteScreenState extends State<RouteScreen> {
  final _map = MapController();
  late final Faskes f = widget.faskes;
  int _moda = 0;
  List<LatLng>? _rute;
  double? _kmRute;
  bool _navigasi = false;

  @override
  void initState() {
    super.initState();
    userPos.addListener(_cekTiba);
    _muatRute();
  }

  @override
  void dispose() {
    userPos.removeListener(_cekTiba);
    _map.dispose();
    super.dispose();
  }

  void _pasEkran() {
    final titik = _rute ?? [userPos.value, f.pos];
    try {
      _map.fitCamera(CameraFit.coordinates(
        coordinates: titik,
        padding: const EdgeInsets.fromLTRB(50, 90, 50, 50),
      ));
    } catch (_) {}
  }

  Future<void> _muatRute() async {
    try {
      final a = userPos.value, b = f.pos;
      final url = Uri.parse(
          'https://router.project-osrm.org/route/v1/driving/${a.longitude},${a.latitude};${b.longitude},${b.latitude}?overview=full&geometries=geojson');
      final res = await http.get(url).timeout(const Duration(seconds: 8));
      final r = (jsonDecode(res.body)['routes'] as List).first;
      final pts = (r['geometry']['coordinates'] as List)
          .map((c) => LatLng((c[1] as num).toDouble(), (c[0] as num).toDouble()))
          .toList();
      if (!mounted) return;
      setState(() {
        _rute = pts;
        _kmRute = (r['distance'] as num) / 1000;
      });
      _pasEkran();
    } catch (_) {
      // offline: tetap pakai garis lurus
    }
  }

  void _cekTiba() {
    if (!_navigasi || !mounted) return;
    if (jarakMeter(userPos.value, f.pos) > _radiusTiba) return;
    setState(() => _navigasi = false);
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.check_circle, color: svGreen, size: 48),
        title: const Text('Anda telah tiba'),
        content: Text('Anda sudah sampai di ${f.nama}.',
            textAlign: TextAlign.center),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('OK')),
        ],
      ),
    );
  }

  void _toggleNavigasi() {
    setState(() => _navigasi = !_navigasi);
    if (_navigasi) _cekTiba();
  }

  static String _fmtMenit(double menit) {
    final m = menit.ceil() < 1 ? 1 : menit.ceil();
    if (m < 60) return '$m mnt';
    return '${m ~/ 60} j ${m % 60} mnt';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: backBar(context, 'Rute ke ${f.nama}'),
      body: ValueListenableBuilder<LatLng>(
        valueListenable: userPos,
        builder: (context, user, _) {
          final lurus = jarakKm(f, user);
          final km = _kmRute ?? lurus * _faktorJalan;
          final menit = km / _modaList[_moda].kmPerJam * 60;
          final titik = _rute ?? [user, f.pos];
          final tengah = titik[titik.length ~/ 2];

          return Column(children: [
            Expanded(
              child: Stack(children: [
                FlutterMap(
                  mapController: _map,
                  options: MapOptions(
                    initialCameraFit: CameraFit.coordinates(
                      coordinates: [user, f.pos],
                      padding: const EdgeInsets.fromLTRB(50, 90, 50, 50),
                    ),
                    // tekan lama = pindahkan lokasi simulasi (untuk uji navigasi)
                    onLongPress: (_, p) => setPosisiSimulasi(p),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: _petaOsm,
                      userAgentPackageName: 'com.example.smart_village',
                      tileBuilder: (context, tileWidget, tile) =>
                          ColorFiltered(
                              colorFilter: _filterTerang, child: tileWidget),
                    ),
                    PolylineLayer(polylines: [
                      Polyline(
                        points: titik,
                        strokeWidth: 6,
                        color: svBlue,
                        borderStrokeWidth: 2,
                        borderColor: Colors.white,
                      ),
                    ]),
                    MarkerLayer(markers: [
                      // titik user + cincin
                      Marker(
                        point: user,
                        width: 40,
                        height: 40,
                        child: Container(
                          decoration: BoxDecoration(
                              color:
                                  const Color(0xFF2F6DF6).withOpacity(0.25),
                              shape: BoxShape.circle),
                          alignment: Alignment.center,
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                                color: const Color(0xFF2F6DF6),
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Colors.white, width: 3)),
                          ),
                        ),
                      ),
                      // gelembung estimasi di tengah rute
                      Marker(
                        point: tengah,
                        width: 66,
                        height: 44,
                        child: Container(
                          decoration: BoxDecoration(
                              color: svBlue,
                              borderRadius: BorderRadius.circular(10)),
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(_fmtMenit(menit),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700)),
                              Text(fmtKm(km),
                                  style: const TextStyle(
                                      color: Color(0xFFDBEAFE), fontSize: 10)),
                            ],
                          ),
                        ),
                      ),
                      // pin tujuan + label nama
                      Marker(
                        point: f.pos,
                        width: 160,
                        height: 86,
                        alignment: Alignment.topCenter,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(6),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.black26, blurRadius: 3)
                                  ]),
                              child: Text(f.nama,
                                  style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700)),
                            ),
                            const SizedBox(height: 2),
                            Icon(Icons.location_on,
                                color: warnaKategori(f.kategori), size: 40),
                          ],
                        ),
                      ),
                    ]),
                  ],
                ),
                // tombol putih "›" di sisi kanan peta (pas ke seluruh rute)
                Positioned(
                  right: 8,
                  top: 70,
                  child: Material(
                    color: Colors.white,
                    elevation: 2,
                    borderRadius: BorderRadius.circular(8),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: _pasEkran,
                      child: const SizedBox(
                        width: 30,
                        height: 30,
                        child: Icon(Icons.chevron_right,
                            size: 22, color: svSub),
                      ),
                    ),
                  ),
                ),
              ]),
            ),
            // ---------- PANEL BAWAH ----------
            Container(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
              color: Colors.white,
              child: SafeArea(
                top: false,
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Row(children: [
                    for (var i = 0; i < _modaList.length; i++)
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                              right: i < _modaList.length - 1 ? 10 : 0),
                          child: _KartuModa(
                            moda: _modaList[i],
                            waktu:
                                _fmtMenit(km / _modaList[i].kmPerJam * 60),
                            jarak: fmtKm(km),
                            aktif: i == _moda,
                            onTap: () => setState(() => _moda = i),
                          ),
                        ),
                      ),
                  ]),
                  const SizedBox(height: 8),
                  Text(
                    _navigasi
                        ? 'Navigasi aktif · sisa jarak ${fmtKm(lurus)}'
                        : (_rute == null
                            ? 'Estimasi berdasarkan jarak garis lurus'
                            : 'Rute jalan dari OpenStreetMap'),
                    style: const TextStyle(fontSize: 11, color: svMut),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: _navigasi ? svRed : svBlue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: _toggleNavigasi,
                      child: Text(
                          _navigasi ? 'Hentikan Navigasi' : 'Mulai Navigasi',
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ]),
              ),
            ),
          ]);
        },
      ),
    );
  }
}

class _KartuModa extends StatelessWidget {
  final _Moda moda;
  final String waktu;
  final String jarak;
  final bool aktif;
  final VoidCallback onTap;

  const _KartuModa({
    required this.moda,
    required this.waktu,
    required this.jarak,
    required this.aktif,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: aktif ? svBlueSoft : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: aktif ? svBlue : const Color(0xFFE3E8F0), width: 1.5),
        ),
        child: Column(children: [
          // moda terpilih: kotak biru berisi ikon putih (sesuai desain)
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
                color: aktif ? svBlue : Colors.transparent,
                borderRadius: BorderRadius.circular(10)),
            child: Icon(moda.ikon,
                color: aktif ? Colors.white : svSub, size: 22),
          ),
          const SizedBox(height: 4),
          Text(waktu,
              style:
                  const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
          Text(jarak, style: const TextStyle(fontSize: 11, color: svMut)),
        ]),
      ),
    );
  }
}