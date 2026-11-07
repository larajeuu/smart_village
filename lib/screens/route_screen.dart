import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../data/faskes.dart';

/// Layar Rute: garis lurus dari posisi user ke fasilitas + estimasi per moda.
/// Kontrak: dibuka dengan RouteScreen(faskes: f).
class RouteScreen extends StatefulWidget {
  final Faskes faskes;
  const RouteScreen({super.key, required this.faskes});

  @override
  State<RouteScreen> createState() => _RouteScreenState();
}

class _Moda {
  final String nama;
  final IconData ikon;
  final double kmPerJam; // kecepatan rata-rata
  const _Moda(this.nama, this.ikon, this.kmPerJam);
}

const _modaList = <_Moda>[
  _Moda('Jalan', Icons.directions_walk, 5),
  _Moda('Motor', Icons.two_wheeler, 30),
  _Moda('Mobil', Icons.directions_car, 25),
];

/// Garis lurus selalu lebih pendek dari jalan sebenarnya.
/// Ubah ke 1.0 kalau mau memakai jarak garis lurus apa adanya.
const _faktorJalan = 1.3;

class _RouteScreenState extends State<RouteScreen> {
  int _moda = 1; // indeks moda terpilih (default: Motor)

  static String _fmtJarak(double km) => km < 1
      ? '${(km * 1000).round()} m'
      : '${km.toStringAsFixed(1).replaceAll('.', ',')} km';

  static String _fmtMenit(double menit) {
    final m = menit.ceil() < 1 ? 1 : menit.ceil();
    if (m < 60) return '$m mnt';
    return '${m ~/ 60} j ${m % 60} mnt';
  }

  static double _zoomUntuk(double km) {
    if (km < 0.5) return 16;
    if (km < 1) return 15;
    if (km < 2.5) return 14;
    if (km < 5) return 13;
    if (km < 10) return 12;
    return 11;
  }

  void _mulai() {
    final f = widget.faskes;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content:
            Text('Navigasi ke ${f.nama} (${_modaList[_moda].nama}) - simulasi'),
      ));
  }

  @override
  Widget build(BuildContext context) {
    final f = widget.faskes;
    final warna = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(title: Text('Rute ke ${f.nama}')),
      body: ValueListenableBuilder<LatLng>(
        valueListenable: userPos,
        builder: (context, user, _) {
          final lurus = jarakKm(f, user);
          final km = lurus * _faktorJalan;
          final tengah = LatLng(
            (user.latitude + f.pos.latitude) / 2,
            (user.longitude + f.pos.longitude) / 2,
          );
          final menitTerpilih = km / _modaList[_moda].kmPerJam * 60;

          return Column(
            children: [
              // ---------- PETA ----------
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    FlutterMap(
                      options: MapOptions(
                        initialCenter: tengah,
                        initialZoom: _zoomUntuk(lurus),
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.example.smart_village',
                        ),
                        PolylineLayer(polylines: [
                          Polyline(
                            points: [user, f.pos],
                            strokeWidth: 5,
                            color: warna,
                          ),
                        ]),
                        MarkerLayer(markers: [
                          Marker(
                            point: user,
                            width: 22,
                            height: 22,
                            child: const _TitikUser(),
                          ),
                          Marker(
                            point: f.pos,
                            width: 40,
                            height: 40,
                            alignment: Alignment.topCenter,
                            child: Icon(Icons.location_on,
                                color: warnaKategori(f.kategori), size: 40),
                          ),
                        ]),
                      ],
                    ),
                    // label estimasi di atas peta
                    Positioned(
                      top: 12,
                      left: 12,
                      right: 12,
                      child: Center(
                        child: Material(
                          elevation: 3,
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            child: Text(
                              '${_fmtMenit(menitTerpilih)} · ${_fmtJarak(km)}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ---------- PANEL BAWAH ----------
              Container(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 12),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          for (var i = 0; i < _modaList.length; i++)
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    right: i < _modaList.length - 1 ? 10 : 0),
                                child: _KartuModa(
                                  moda: _modaList[i],
                                  waktu: _fmtMenit(
                                      km / _modaList[i].kmPerJam * 60),
                                  jarak: _fmtJarak(km),
                                  aktif: i == _moda,
                                  warna: warna,
                                  onTap: () => setState(() => _moda = i),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Estimasi berdasarkan jarak garis lurus',
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: FilledButton(
                          onPressed: _mulai,
                          child: const Text('Mulai Navigasi'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
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
  final Color warna;
  final VoidCallback onTap;

  const _KartuModa({
    required this.moda,
    required this.waktu,
    required this.jarak,
    required this.aktif,
    required this.warna,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: aktif ? warna.withAlpha(25) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: aktif ? warna : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Icon(moda.ikon, color: aktif ? warna : Colors.grey[700]),
            const SizedBox(height: 4),
            Text(waktu,
                style:
                    const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
            Text(jarak,
                style: const TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

class _TitikUser extends StatelessWidget {
  const _TitikUser();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
      ),
    );
  }
}
