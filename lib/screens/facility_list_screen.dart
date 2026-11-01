import 'package:flutter/material.dart';
import '../models/facility.dart';
import '../services/location_service.dart';
import '../theme.dart';
import 'detail_screen.dart';

class FacilityListScreen extends StatefulWidget {
  final FacilityType type;
  const FacilityListScreen({super.key, required this.type});
  @override
  State<FacilityListScreen> createState() => _FacilityListScreenState();
}

class _FacilityListScreenState extends State<FacilityListScreen> {
  String _cat = 'Semua';
  String _q = '';
  final svc = LocationService.instance;

  @override
  Widget build(BuildContext context) {
    final base = facilities.where((f) => f.type == widget.type).toList();
    final cats = ['Semua', ...{...base.map((f) => f.category)}];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text(widget.type.label)),
      body: ValueListenableBuilder(
        valueListenable: svc.position,
        builder: (_, __, ___) {
          final list = base
              .where((f) => _cat == 'Semua' || f.category == _cat)
              .where((f) => f.name.toLowerCase().contains(_q.toLowerCase()))
              .toList()
            ..sort((a, b) => svc.distanceTo(a).compareTo(svc.distanceTo(b)));
          return Column(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
              child: TextField(
                onChanged: (v) => setState(() => _q = v),
                decoration: InputDecoration(
                  hintText: 'Cari nama ${widget.type.label.toLowerCase()} di Kabupaten X...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: kBg,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none),
                ),
              ),
            ),
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: cats
                    .map((c) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: ChoiceChip(
                            label: Text(c),
                            selected: _cat == c,
                            selectedColor: kPrimary,
                            labelStyle: TextStyle(color: _cat == c ? Colors.white : Colors.black87),
                            onSelected: (_) => setState(() => _cat = c),
                          ),
                        ))
                    .toList(),
              ),
            ),
            Expanded(
              child: list.isEmpty
                  ? const Center(child: Text('Fasilitas tidak ditemukan'))
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: list.length,
                      separatorBuilder: (_, __) => const Divider(height: 24),
                      itemBuilder: (_, i) => _item(list[i]),
                    ),
            ),
          ]);
        },
      ),
    );
  }

  Widget _item(Facility f) {
    final d = svc.distanceTo(f);
    return InkWell(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (_) => DetailScreen(facility: f))),
      child: Row(children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
              color: f.type.color.withOpacity(.12),
              borderRadius: BorderRadius.circular(12)),
          child: Icon(f.type.icon, color: f.type.color, size: 36),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(f.name, style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 2),
            Row(children: [
              const Icon(Icons.location_on, size: 14, color: Colors.red),
              Text(' ${LocationService.format(d)}', style: const TextStyle(fontSize: 12)),
              if (svc.insideIds.contains(f.id))
                const Padding(
                  padding: EdgeInsets.only(left: 6),
                  child: Text('• di area', style: TextStyle(fontSize: 11, color: Colors.green)),
                ),
            ]),
            const SizedBox(height: 4),
            _chip(f.category, kPrimary.withOpacity(.12), kPrimary),
            const SizedBox(height: 4),
            Wrap(spacing: 4, runSpacing: 2,
                children: f.services.take(3).map((s) => _chip(s, kBg, Colors.black54)).toList()),
          ]),
        ),
        const Icon(Icons.chevron_right, color: Colors.grey),
      ]),
    );
  }

  Widget _chip(String t, Color bg, Color fg) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
        child: Text(t, style: TextStyle(fontSize: 10, color: fg)),
      );
}
