import 'package:flutter/material.dart';
import '../data/faskes.dart';
import '../widgets/common.dart';
import '../widgets/lokasi_map.dart';
import '../widgets/sv_theme.dart';

const _urlSatelit =
    'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}';

/// Layar "Peta Lokasi": dipakai sebagai tab Peta dan sebagai halaman dari Detail.
/// - dari Detail: showBack = true (panah kembali = Navigator.pop)
/// - sebagai tab : panah hanya muncul kalau onBack diisi (mis. pindah ke Beranda)
class PetaLokasiScreen extends StatefulWidget {
  final Faskes? focus;
  final bool showBack;
  final VoidCallback? onBack;
  const PetaLokasiScreen(
      {super.key, this.focus, this.showBack = false, this.onBack});
  @override
  State<PetaLokasiScreen> createState() => _PetaLokasiScreenState();
}

class _PetaLokasiScreenState extends State<PetaLokasiScreen> {
  String _sel = 'Semua';
  String _q = '';
  bool _satelit = false;
  bool _label = true;
  // lingkaran geofence: otomatis nyala kalau dibuka dari Detail
  late bool _geofence = widget.focus != null;

  List<Faskes> get _items {
    final q = _q.toLowerCase();
    return daftarFaskes.where((f) {
      final okKat = _sel == 'Semua' ||
          (_sel == 'RS' ? f.kategori == 'Rumah Sakit' : f.kategori == _sel);
      final okCari = f.nama.toLowerCase().contains(q) ||
          f.layanan.any((l) => l.toLowerCase().contains(q));
      return okKat && okCari;
    }).toList();
  }

  /// Ikon "lapisan" di kanan atas: ganti jenis peta + atur tampilan.
  void _bukaLapisan() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
      builder: (_) => StatefulBuilder(builder: (ctx, setSheet) {
        // ubah state layar + gambar ulang isi sheet
        void ubah(VoidCallback fn) {
          setState(fn);
          setSheet(() {});
        }

        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Tampilan Peta',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                const SizedBox(height: 14),
                Row(children: [
                  _PilihPeta('Standar', Icons.map_outlined, !_satelit,
                      () => ubah(() => _satelit = false)),
                  const SizedBox(width: 12),
                  _PilihPeta('Satelit', Icons.satellite_alt_outlined, _satelit,
                      () => ubah(() => _satelit = true)),
                ]),
                const SizedBox(height: 8),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: _geofence,
                  onChanged: (v) => ubah(() => _geofence = v),
                  title: const Text('Area geofence',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  subtitle: const Text(
                      'Lingkaran radius notifikasi tiap fasilitas',
                      style: TextStyle(fontSize: 12, color: svMut)),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: _label,
                  onChanged: (v) => ubah(() => _label = v),
                  title: const Text('Label nama lokasi',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                ),
              ]),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = _items;
    // 1 hasil -> pusatkan ke hasil itu; >=2 hasil -> zoom supaya semuanya terlihat
    final fokus = widget.focus ?? (items.length == 1 ? items.first : null);
    final fit = (widget.focus == null && items.length >= 2)
        ? [...items.map((f) => f.pos), userPos.value]
        : null;

    return Scaffold(
      appBar: backBar(context, 'Peta Lokasi',
          tampilBack: widget.showBack || widget.onBack != null,
          onBack: widget.showBack ? () => Navigator.pop(context) : widget.onBack,
          actions: [
            IconButton(
              tooltip: 'Tampilan peta',
              onPressed: _bukaLapisan,
              icon: const Icon(Icons.layers_outlined, color: svSub),
            ),
            const SizedBox(width: 4),
          ]),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 2, 16, 8),
          child: SearchBox('Cari lokasi...',
              onChanged: (v) => setState(() => _q = v)),
        ),
        FilterChips(
            items: const ['Semua', 'RS', 'Puskesmas', 'Klinik'],
            selected: _sel,
            onSelect: (v) => setState(() => _sel = v)),
        const SizedBox(height: 8),
        Expanded(
          child: Stack(fit: StackFit.expand, children: [
            LokasiMap(
              key: ValueKey('$_sel$_q'),
              points: items,
              focus: fokus,
              fit: fit,
              showGeofence: _geofence,
              showLabels: _label,
              tileUrl: _satelit ? _urlSatelit : null,
            ),
            if (items.isEmpty)
              Positioned(
                top: 12,
                left: 16,
                right: 16,
                child: Material(
                  elevation: 3,
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  child: const Padding(
                    padding: EdgeInsets.all(12),
                    child: Text('Lokasi tidak ditemukan',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13, color: svSub)),
                  ),
                ),
              ),
          ]),
        ),
      ]),
    );
  }
}

class _PilihPeta extends StatelessWidget {
  final String label;
  final IconData ikon;
  final bool aktif;
  final VoidCallback onTap;
  const _PilihPeta(this.label, this.ikon, this.aktif, this.onTap);

  @override
  Widget build(BuildContext context) => Expanded(
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
                color: aktif ? svBlueSoft : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: aktif ? svBlue : const Color(0xFFCDD5E0),
                    width: aktif ? 1.6 : 1)),
            child: Column(children: [
              Icon(ikon, color: aktif ? svBlue : svSub),
              const SizedBox(height: 4),
              Text(label,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: aktif ? svBlue : svSub)),
            ]),
          ),
        ),
      );
}