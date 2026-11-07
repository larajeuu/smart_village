import 'package:flutter/material.dart';
import '../data/faskes.dart';
import '../services/favorites_service.dart';
import '../widgets/common.dart';
import '../widgets/sv_theme.dart';
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
}

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
  _Layanan('Farmasi',
      const Icon(Icons.medication, color: _teal, size: 28), _biruSoft),
  _Layanan('Rehabilitasi',
      const Icon(Icons.volunteer_activism, color: svBlue, size: 26), _biruSoft),
  _Layanan('Lainnya', const Icon(Icons.more_horiz, color: svSub, size: 26),
      _abuSoft),
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

  Widget _itemLayanan(_Layanan s, double lebar) => SizedBox(
        width: lebar,
        child: Column(children: [
          Container(
            width: 52,
            height: 52,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: s.bg, borderRadius: BorderRadius.circular(18)),
            child: s.ikon,
          ),
          const SizedBox(height: 6),
          Text(s.nama,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 10.5, fontWeight: FontWeight.w500, color: svText)),
        ]),
      );

  @override
  Widget build(BuildContext context) {
    final f = faskes;

    return Scaffold(
      backgroundColor: Colors.white,

      // ===== tombol bawah (dipindah ke sini supaya posisinya pasti) =====
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
                      child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.access_time,
                                size: 14, color: svGreen),
                            SizedBox(width: 5),
                            Text('Buka · 24 jam',
                                style: TextStyle(
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
                        children: _layanan
                            .map((s) => _itemLayanan(s, lebar))
                            .toList(),
                      );
                    }),
                  ]),
            ),
          ),
        ),

        // ===== tombol atas: kembali & favorit (sekarang Positioned) =====
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
                            fav ? svRed : _navy,
                            () => FavoritesService.instance.toggle(favId(f)));
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