import 'package:flutter/material.dart';

/// PLACEHOLDER - diisi pemilik layar bawah.
/// Sumber data: FavoritesService.instance.ids (ValueNotifier<Set<String>>).
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorit')),
      body: const Center(child: Text('TODO: layar Favorit')),
    );
  }
}
