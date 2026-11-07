import 'package:flutter/material.dart';

import '../data/faskes.dart';
import '../services/favorites_service.dart';
import '../widgets/common.dart';
import '../widgets/sv_theme.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: backBar(context, 'Favorit', tampilBack: false),
      body: ValueListenableBuilder<Set<String>>(
        valueListenable: FavoritesService.instance.ids,
        builder: (context, ids, _) {
          final items =
              daftarFaskes.where((f) => ids.contains(favId(f))).toList();
          if (items.isEmpty) return const _EmptyState();

          // userPos didengarkan supaya jarak ikut berubah saat lokasi digeser.
          return ValueListenableBuilder(
            valueListenable: userPos,
            builder: (_, __, ___) => ListView.separated(
              itemCount: items.length,
              separatorBuilder: (_, __) =>
                  const Divider(height: 1, color: svLine),
              itemBuilder: (_, i) =>
                  FacilityTile(items[i], detail: true, maxChips: 4, foto: 76),
            ),
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
