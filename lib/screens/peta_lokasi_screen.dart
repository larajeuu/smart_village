import 'package:flutter/material.dart';
import '../data/faskes.dart';
import '../widgets/common.dart';
import '../widgets/lokasi_map.dart';
import '../widgets/sv_theme.dart';

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

  List<Faskes> get _items => daftarFaskes.where((f) {
        final okKat = _sel == 'Semua' ||
            (_sel == 'RS' ? f.kategori == 'Rumah Sakit' : f.kategori == _sel);
        return okKat && f.nama.toLowerCase().contains(_q.toLowerCase());
      }).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backBar(context, 'Peta Lokasi',
          tampilBack: widget.showBack || widget.onBack != null,
          onBack: widget.showBack ? () => Navigator.pop(context) : widget.onBack,
          actions: const [
            Padding(
                padding: EdgeInsets.only(right: 14),
                child: Icon(Icons.layers_outlined, color: svSub))
          ]),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 2, 16, 8),
          child: SearchBox('Cari lokasi...', onChanged: (v) => setState(() => _q = v)),
        ),
        FilterChips(
            items: const ['Semua', 'RS', 'Puskesmas', 'Klinik'],
            selected: _sel,
            onSelect: (v) => setState(() => _sel = v)),
        const SizedBox(height: 8),
        Expanded(
          child: LokasiMap(
            key: ValueKey('$_sel$_q'),
            points: _items,
            focus: widget.focus,
            showGeofence: widget.focus != null,
          ),
        ),
      ]),
    );
  }
}
