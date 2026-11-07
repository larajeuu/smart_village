import 'package:flutter/material.dart';

import '../models/facility.dart';
import '../services/favorites_service.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorit')),
      body: ValueListenableBuilder<Set<String>>(
        valueListenable: FavoritesService.instance.ids,
        builder: (context, ids, _) {
          final items = facilities.where((f) => ids.contains(f.id)).toList();

          if (items.isEmpty) return const _EmptyState();

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) => _FavoriteTile(facility: items[i]),
          );
        },
      ),
    );
  }
}

class _FavoriteTile extends StatelessWidget {
  const _FavoriteTile({required this.facility});

  final Facility facility;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: facility.type.color,
          child: Icon(facility.type.icon, color: Colors.white),
        ),
        title: Text(facility.name),
        subtitle: Text('${facility.type.label} • ${facility.ratingLabel}'),
        trailing: IconButton(
          icon: const Icon(Icons.favorite, color: Colors.red),
          onPressed: () => FavoritesService.instance.toggle(facility.id),
        ),
        // TODO: onTap -> buka layar Detail (langkah berikutnya)
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
            Icon(Icons.favorite_border, size: 64, color: Colors.grey),
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
