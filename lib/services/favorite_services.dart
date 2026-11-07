import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Menyimpan id fasilitas favorit. Dipakai bersama oleh Detail dan layar Favorit.
class FavoritesService {
  FavoritesService._();
  static final instance = FavoritesService._();

  static const _key = 'favorite_ids';

  /// Kumpulan id favorit. Layar cukup mendengarkan ValueNotifier ini.
  final ids = ValueNotifier<Set<String>>({});

  /// Dipanggil sekali saat app start: baca favorit yang tersimpan.
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    ids.value = (prefs.getStringList(_key) ?? []).toSet();
  }

  bool isFavorite(String id) => ids.value.contains(id);

  /// Tambah jika belum favorit, hapus jika sudah.
  Future<void> toggle(String id) async {
    final next = {...ids.value}; // salinan baru, bukan mengubah yang lama
    if (!next.remove(id)) next.add(id);
    ids.value = next; // set baru -> listener diberi tahu

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, next.toList());
  }
}
