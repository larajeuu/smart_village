import 'package:flutter/material.dart';

import '../data/faskes.dart';
import '../services/favorites_service.dart';
import '../widgets/common.dart';
import '../widgets/sv_theme.dart';
import 'detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  void _hapus(BuildContext context, Faskes f) {
    FavoritesService.instance.toggle(favId(f));
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text('${f.nama} dihapus dari favorit'),
        action: SnackBarAction(
          label: 'Batal',
          onPressed: () => FavoritesService.instance.toggle(favId(f)),
        ),
      ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Favorit',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
      ),
      body: ValueListenableBuilder<Set<String>>(
        valueListenable: FavoritesService.instance.ids,
        builder: (context, ids, _) {
          return ValueListenableBuilder(
            valueListenable: userPos, // jarak ikut berubah saat lokasi berubah
            builder: (_, pos, __) {
              final items = daftarFaskes
                  .where((f) => ids.contains(favId(f)))
                  .toList()
                ..sort((a, b) => jarakKm(a, pos).compareTo(jarakKm(b, pos)));
              if (items.isEmpty) return const _EmptyState();

              return ListView.separated(
                itemCount: items.length,
                separatorBuilder: (_, __) =>
                    const Divider(height: 1, color: svLine),
                itemBuilder: (_, i) {
                  final f = items[i];
                  return InkWell(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => DetailScreen(faskes: f))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Row(children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: faskesFoto(f, w: 64, h: 64),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(f.nama,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700)),
                              const SizedBox(height: 4),
                              Text('${jarakStr(f)} · ${singkat(f)}',
                                  style: const TextStyle(
                                      fontSize: 12, color: svMut)),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => _hapus(context, f),
                          icon: const Icon(Icons.favorite, color: svRed),
                        ),
                      ]),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.favorite_border, size: 64, color: svMut),
            SizedBox(height: 12),
            Text('Belum ada favorit',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            SizedBox(height: 4),
            Text('Tandai fasilitas dengan ikon hati supaya muncul di sini.',
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}