import 'package:flutter/material.dart';
import '../data/faskes.dart';
import '../widgets/smart_map.dart';

class PetaLokasiScreen extends StatefulWidget {
  final Faskes? focus;
  const PetaLokasiScreen({super.key, this.focus});

  @override
  State<PetaLokasiScreen> createState() => _PetaLokasiScreenState();
}

class _PetaLokasiScreenState extends State<PetaLokasiScreen> {
  String? _filter; // null = semua
  bool _geofence = true;
  String _query = '';

  List<Faskes> get _items => daftarFaskes.where((f) {
        final okKat = _filter == null || f.kategori == _filter;
        final okQ = f.nama.toLowerCase().contains(_query.toLowerCase());
        return okKat && okQ;
      }).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        centerTitle: true,
        // ===== TOMBOL KELUAR KIRI ATAS =====
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Peta Lokasi',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: TextField(
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: 'Cari lokasi...',
                prefixIcon: const Icon(Icons.search),
                isDense: true,
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: SmartMap(
              // key supaya peta ikut terbarui saat filter berubah
              key: ValueKey('$_filter$_query$_geofence'),
              points: _items,
              showGeofence: _geofence,
              focus: widget.focus,
            ),
          ),
          // ===== BAR KATEGORI DI BAWAH =====
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8)
              ],
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _item('Rumah Sakit', Icons.local_hospital, Colors.red,
                        _filter == 'Rumah Sakit', () => _toggle('Rumah Sakit')),
                    _item('Puskesmas', Icons.home_work, Colors.green,
                        _filter == 'Puskesmas', () => _toggle('Puskesmas')),
                    _item('Klinik', Icons.medical_services, Colors.purple,
                        _filter == 'Klinik', () => _toggle('Klinik')),
                    _item('Area Geofencing', Icons.radio_button_checked,
                        Colors.blue, _geofence,
                        () => setState(() => _geofence = !_geofence)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _toggle(String f) => setState(() => _filter = _filter == f ? null : f);

  Widget _item(String label, IconData icon, Color color, bool active,
      VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: active ? color.withOpacity(0.18) : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color),
            ),
            Text(label,
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: active ? FontWeight.bold : FontWeight.normal)),
          ],
        ),
      ),
    );
  }
}