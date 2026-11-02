import 'package:flutter/material.dart';
import '../data/faskes.dart';
import 'detail_screen.dart';

class ListScreen extends StatefulWidget {
  final String? kategori; // null = semua
  final String title;
  const ListScreen({super.key, this.kategori, required this.title});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  String _query = '';
  String _jenis = 'Semua';

  @override
  Widget build(BuildContext context) {
    final adaChip = widget.kategori == 'Rumah Sakit';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        title: Text(widget.title,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 17)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: userPos,
        builder: (context, pos, _) {
          final items = daftarFaskes.where((f) {
            final okKat =
                widget.kategori == null || f.kategori == widget.kategori;
            final okJenis = _jenis == 'Semua' || f.jenis == _jenis;
            final okQ = f.nama.toLowerCase().contains(_query.toLowerCase());
            return okKat && okJenis && okQ;
          }).toList()
            ..sort((a, b) => jarakKm(a, pos).compareTo(jarakKm(b, pos)));

          return Column(
            children: [
              // ===== KOLOM CARI =====
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
                child: TextField(
                  onChanged: (v) => setState(() => _query = v),
                  decoration: InputDecoration(
                    hintText: widget.kategori == null
                        ? 'Cari fasilitas di Kabupaten X...'
                        : 'Cari ${widget.title.toLowerCase()} di Kabupaten X...',
                    prefixIcon: const Icon(Icons.search),
                    isDense: true,
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFF1668E3)),
                    ),
                  ),
                ),
              ),

              // ===== TOMBOL FILTER: Semua / RS Umum / RS Khusus =====
              if (adaChip)
                SizedBox(
                  height: 44,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    children: ['Semua', 'RS Umum', 'RS Khusus']
                        .map((j) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: ChoiceChip(
                                label: Text(j),
                                selected: _jenis == j,
                                showCheckmark: false,
                                backgroundColor: Colors.white,
                                selectedColor: const Color(0xFF1668E3),
                                shape: StadiumBorder(
                                  side: BorderSide(
                                    color: _jenis == j
                                        ? const Color(0xFF1668E3)
                                        : Colors.grey.shade300,
                                  ),
                                ),
                                labelStyle: TextStyle(
                                  color: _jenis == j
                                      ? Colors.white
                                      : const Color(0xFF475569),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                                onSelected: (_) =>
                                    setState(() => _jenis = j),
                              ),
                            ))
                        .toList(),
                  ),
                ),
              const Divider(height: 1),

              // ===== DAFTAR =====
              Expanded(
                child: items.isEmpty
                    ? const Center(child: Text('Tidak ditemukan'))
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: items.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, i) {
                          final f = items[i];
                          return InkWell(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => DetailScreen(faskes: f)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // FOTO MASING-MASING FASILITAS
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: faskesFoto(f, w: 78, h: 78),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          f.nama,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 15,
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        Row(
                                          children: [
                                            const Icon(Icons.location_on,
                                                size: 14,
                                                color: Color(0xFF1668E3)),
                                            const SizedBox(width: 2),
                                            Text(
                                              '${jarakKm(f, pos).toStringAsFixed(1)} km',
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 5),
                                        // CHIP JENIS (RS Umum hijau, RS Khusus biru)
                                        _chip(f.jenis,
                                            bg: bgJenis(f.jenis),
                                            fg: fgJenis(f.jenis),
                                            tebal: true),
                                        const SizedBox(height: 6),
                                        // CHIP LAYANAN
                                        Wrap(
                                          spacing: 6,
                                          runSpacing: 4,
                                          children: f.layanan
                                              .take(3)
                                              .map((l) => _chip(l,
                                                  bg: const Color(0xFFEAF1FB),
                                                  fg: const Color(0xFF3B5B8C)))
                                              .toList(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(top: 24),
                                    child: Icon(Icons.chevron_right,
                                        color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _chip(String teks,
      {required Color bg, required Color fg, bool tebal = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
      child: Text(
        teks,
        style: TextStyle(
          fontSize: 11,
          color: fg,
          fontWeight: tebal ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }
}