import 'package:flutter/material.dart';
import '../data/faskes.dart';
import '../widgets/common.dart';

class ListScreen extends StatefulWidget {
  final String? kategori; // null = semua
  final String title;
  final bool cari;

  /// Kata pencarian awal (mis. dari ketukan "Poliklinik" di halaman Detail).
  final String cariAwal;
  const ListScreen(
      {super.key,
      this.kategori,
      required this.title,
      this.cari = false,
      this.cariAwal = ''});
  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  late String _sel = widget.kategori ?? 'Semua';
  late String _q = widget.cariAwal;
  late final TextEditingController _ctrl =
      TextEditingController(text: widget.cariAwal);

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backBar(context, 'Daftar Lokasi'),
      body: Column(children: [
        if (widget.cari)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 2, 16, 8),
            child: SearchBox('Cari rumah sakit, puskesmas, klinik...',
                controller: _ctrl,
                autofocus: widget.cariAwal.isEmpty,
                onChanged: (v) => setState(() => _q = v)),
          ),
        const SizedBox(height: 4),
        FilterChips(
            items: const ['Semua', 'Rumah Sakit', 'Puskesmas', 'Klinik'],
            selected: _sel,
            onSelect: (v) => setState(() => _sel = v)),
        const SizedBox(height: 6),
        Expanded(
          child: ValueListenableBuilder(
            valueListenable: userPos,
            builder: (_, pos, __) {
              final q = _q.toLowerCase();
              final items = daftarFaskes
                  .where((f) =>
                      (_sel == 'Semua' || f.kategori == _sel) &&
                      (f.nama.toLowerCase().contains(q) ||
                          f.layanan.any((l) => l.toLowerCase().contains(q))))
                  .toList()
                ..sort((a, b) => jarakKm(a, pos).compareTo(jarakKm(b, pos)));
              if (items.isEmpty) {
                return const Center(
                    child: Text('Lokasi tidak ditemukan',
                        style: TextStyle(color: Colors.grey)));
              }
              return ListView(
                  children: items
                      .map((f) =>
                          FacilityTile(f, detail: true, maxChips: 4, foto: 76))
                      .toList());
            },
          ),
        ),
      ]),
    );
  }
}