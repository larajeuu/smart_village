import 'package:flutter/material.dart';
import '../data/faskes.dart';
import '../services/favorites_service.dart';
import '../widgets/common.dart';
import '../widgets/sv_theme.dart';
import 'layanan_lainnya_screen.dart';
import 'list_screen.dart';
import 'peta_lokasi_screen.dart';

const _navy = Color(0xFF1B2B4B);
const _teal = Color(0xFF14998E);
const _biruSoft = Color(0xFFEFF5FD);
const _pinkSoft = Color(0xFFFDECEF);
const _abuSoft = Color(0xFFF1F3F7);

class _Layanan {
  final String nama;
  final Widget ikon;
  final Color bg;
  const _Layanan(this.nama, this.ikon, this.bg);
  String get deskripsi => deskripsiLayanan[nama] ?? '';
}

// 7 layanan utama (urutan sama dengan desain). Tombol ke-8 "Lainnya"
// dibuat terpisah di bawah.
final List<_Layanan> _layanan = [
  _Layanan('Poliklinik',
      const Icon(Icons.local_hospital, color: svBlue, size: 26), _biruSoft),
  _Layanan(
      'IGD',
      const Stack(alignment: Alignment.center, children: [
        Icon(Icons.favorite, color: svRed, size: 28),
        Icon(Icons.add, color: Colors.white, size: 13),
      ]),
      _pinkSoft),
  _Layanan('Rawat Inap', const Icon(Icons.bed, color: svBlue, size: 26),
      _biruSoft),
  _Layanan('Laboratorium',
      const Icon(Icons.science_outlined, color: svBlue, size: 26), _biruSoft),
  _Layanan(
      'Radiologi',
      Container(
        width: 24,
        height: 24,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: svBlue, borderRadius: BorderRadius.circular(6)),
        child: Container(
          width: 11,
          height: 11,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2)),
        ),
      ),
      _biruSoft),
  _Layanan('Farmasi', const Icon(Icons.medication, color: _teal, size: 28),
      _biruSoft),
  _Layanan('Rehabilitasi',
      const Icon(Icons.volunteer_activism, color: svBlue, size: 26), _biruSoft),
];

class DetailScreen extends StatelessWidget {
  final Faskes faskes;
  const DetailScreen({super.key, required this.faskes});

  Widget _kotak(IconData ikon, Color warna, VoidCallback onTap) => Material(
        color: Colors.white,
        elevation: 2,
        shadowColor: Colors.black26,
        borderRadius: BorderRadius.circular(11),
        child: InkWell(
          borderRadius: BorderRadius.circular(11),
          onTap: onTap,
          child: SizedBox(
              width: 36, height: 36, child: Icon(ikon, size: 22, color: warna)),
        ),
      );

  /// Satu ikon layanan. Layanan yang tidak dimiliki fasilitas ini dipudarkan.
  Widget _itemLayanan(BuildContext context, _Layanan s, double lebar) {
    final ada = faskes.layanan.contains(s.nama);
    return _KotakLayanan(
      lebar: lebar,
      nama: s.nama,
      redup: !ada,
      bg: s.bg,
      ikon: s.ikon,
      onTap: () => _infoLayanan(context, s, ada),
    );
  }

  /// Tombol "Lainnya" -> layar layanan tambahan + kontak.
  Widget _itemLainnya(BuildContext context, double lebar) => _KotakLayanan(
        lebar: lebar,
        nama: 'Lainnya',
        redup: false,
        bg: _abuSoft,
        ikon: const Icon(Icons.more_horiz, color: svSub, size: 26),
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => LayananLainnyaScreen(faskes: faskes))),
      );

  /// Bottom sheet penjelasan layanan + tombol cari fasilitas lain.
  void _infoLayanan(BuildContext context, _Layanan s, bool ada) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
      builder: (sheetCtx) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Container(
                  width: 52,
                  height: 52,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: s.bg, borderRadius: BorderRadius.circular(18)),
                  child: s.ikon,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(s.nama,
                            style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                color: _navy)),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                              color: ada
                                  ? const Color(0xFFDDF6E4)
                                  : const Color(0xFFEEF2F8),
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                              ada
                                  ? 'Tersedia di ${faskes.nama}'
                                  : 'Belum tersedia di ${faskes.nama}',
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: ada ? svGreen : svSub)),
                        ),
                      ]),
                ),
              ]),
              const SizedBox(height: 14),
              Text(s.deskripsi,
                  style:
                      const TextStyle(fontSize: 13, height: 1.5, color: svSub)),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                      backgroundColor: svBlue,
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24))),
                  onPressed: () {
                    Navigator.pop(sheetCtx);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ListScreen(
                                title: 'Daftar Lokasi',
                                cari: true,
                                cariAwal: s.nama)));
                  },
                  child: Text('Cari fasilitas dengan layanan ${s.nama}',
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w600)),
                ),
              ),
            ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final f = faskes;
    // IGD = layanan gawat darurat, selalu buka 24 jam
    final jamBuka = f.layanan.contains('IGD') ? 'Buka · 24 jam' : 'Buka';

    return Scaffold(
      backgroundColor: Colors.white,

      // ===== tombol bawah =====
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
              color: Color(0x14000000), blurRadius: 12, offset: Offset(0, -4))
        ]),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: FilledButton(
              style: FilledButton.styleFrom(
                  backgroundColor: svBlue,
                  minimumSize: const Size.fromHeight(54),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28))),
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) =>
                          PetaLokasiScreen(focus: f, showBack: true))),
              child: const Text('Lihat di Peta',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
            ),
          ),
        ),
      ),

      body: Stack(fit: StackFit.expand, children: [
        // ===== foto di belakang =====
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 270,
          child: faskesFoto(f, w: double.infinity, h: 270),
        ),

        // ===== isi (scroll, menimpa foto) =====
        Positioned.fill(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(top: 240, bottom: 24),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 24),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(22))),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(f.nama,
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: _navy)),
                    const SizedBox(height: 8),
                    Row(children: [
                      const Icon(Icons.star,
                          size: 17, color: Color(0xFFF5B301)),
                      const SizedBox(width: 4),
                      Text(rt(f.rating),
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: svSub)),
                      Text('  (${f.ulasan} ulasan)',
                          style:
                              const TextStyle(fontSize: 12, color: svMut)),
                      const Spacer(),
                      const Icon(Icons.location_on, size: 16, color: _teal),
                      const SizedBox(width: 2),
                      ValueListenableBuilder(
                          valueListenable: userPos,
                          builder: (_, __, ___) => Text(jarakStr(f),
                              style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: _navy))),
                    ]),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          color: const Color(0xFFDDF6E4),
                          borderRadius: BorderRadius.circular(12)),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        const Icon(Icons.access_time,
                            size: 14, color: svGreen),
                        const SizedBox(width: 5),
                        Text(jamBuka,
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: svGreen)),
                      ]),
                    ),
                    const SizedBox(height: 16),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.location_on,
                              size: 20, color: _teal),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(f.alamat,
                                style: const TextStyle(
                                    fontSize: 12.5,
                                    height: 1.5,
                                    color: svSub)),
                          ),
                        ]),
                    const Divider(height: 32, color: svLine),
                    const Text('Jenis Pelayanan',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: _navy)),
                    const SizedBox(height: 16),
                    LayoutBuilder(builder: (_, c) {
                      const jarak = 8.0;
                      final lebar = (c.maxWidth - jarak * 3) / 4;
                      return Wrap(
                        spacing: jarak,
                        runSpacing: 18,
                        children: [
                          ..._layanan.map((s) => _itemLayanan(context, s, lebar)),
                          _itemLainnya(context, lebar),
                        ],
                      );
                    }),
                  ]),
            ),
          ),
        ),

        // ===== tombol atas: kembali & favorit =====
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _kotak(Icons.chevron_left, _navy,
                        () => Navigator.pop(context)),
                    ValueListenableBuilder<Set<String>>(
                      valueListenable: FavoritesService.instance.ids,
                      builder: (_, s, __) {
                        final fav = s.contains(favId(f));
                        return _kotak(
                            fav ? Icons.favorite : Icons.favorite_border,
                            fav ? svRed : _navy, () {
                          FavoritesService.instance.toggle(favId(f));
                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(SnackBar(
                                duration: const Duration(seconds: 1),
                                content: Text(fav
                                    ? 'Dihapus dari favorit'
                                    : 'Ditambahkan ke favorit')));
                        });
                      },
                    ),
                  ]),
            ),
          ),
        ),
      ]),
    );
  }
}

/// Kotak ikon layanan + label, bisa diketuk.
class _KotakLayanan extends StatelessWidget {
  final double lebar;
  final String nama;
  final bool redup;
  final Color bg;
  final Widget ikon;
  final VoidCallback onTap;
  const _KotakLayanan(
      {required this.lebar,
      required this.nama,
      required this.redup,
      required this.bg,
      required this.ikon,
      required this.onTap});

  @override
  Widget build(BuildContext context) => SizedBox(
        width: lebar,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Opacity(
            opacity: redup ? 0.4 : 1,
            child: Column(children: [
              Container(
                width: 52,
                height: 52,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: bg, borderRadius: BorderRadius.circular(18)),
                child: ikon,
              ),
              const SizedBox(height: 6),
              Text(nama,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w500,
                      color: svText)),
            ]),
          ),
        ),
      );
}