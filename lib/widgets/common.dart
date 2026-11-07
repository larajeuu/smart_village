import 'package:flutter/material.dart';
import '../data/faskes.dart';
import '../screens/detail_screen.dart';
import 'sv_theme.dart';

/// ID favorit untuk sebuah faskes. Dicocokkan lewat nama ke data tim (Facility)
/// supaya sama dengan yang dibaca layar Favorit. Kalau tidak ada, pakai nama.
String favId(Faskes f) => f.nama;

String fmtKm(double km) => km < 1
    ? '${(km * 1000).round()} m'
    : '${km.toStringAsFixed(1).replaceAll('.', ',')} km';
String rt(double r) => r.toString().replaceAll('.', ',');
String jarakStr(Faskes f) => fmtKm(jarakKm(f, userPos.value));
String singkat(Faskes f) => f.kategori == 'Rumah Sakit' ? 'RS' : f.kategori;

/// Logo: pin biru (atas) + hijau (bawah) + lingkaran putih + salib merah
class AppLogo extends StatelessWidget {
  final double size;
  const AppLogo({super.key, this.size = 44});
  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: Size(size, size * 1.3), painter: _LogoPainter());
}

class _LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 40, size.height / 52);
    final pin = Path()
      ..moveTo(20, 51)
      ..cubicTo(8, 36, 2, 29, 2, 20)
      ..arcToPoint(const Offset(38, 20),
          radius: const Radius.circular(18), largeArc: true, clockwise: true)
      ..cubicTo(38, 29, 32, 36, 20, 51)
      ..close();
    canvas.drawPath(
        pin,
        Paint()
          ..shader = const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF3B8CF5), svBlue])
              .createShader(const Rect.fromLTWH(0, 0, 40, 52)));
    canvas.save();
    canvas.clipPath(pin);
    final hijau = Path()
      ..moveTo(0, 33)
      ..cubicTo(10, 28, 18, 38, 28, 33)
      ..cubicTo(38, 28, 36, 31, 40, 30)
      ..lineTo(40, 52)
      ..lineTo(0, 52)
      ..close();
    canvas.drawPath(hijau, Paint()..color = const Color(0xFF35B34A));
    canvas.restore();
    canvas.drawCircle(const Offset(20, 20), 11, Paint()..color = Colors.white);
    final c = Paint()
      ..color = svRed
      ..strokeWidth = 4;
    canvas.drawLine(const Offset(20, 14), const Offset(20, 26), c);
    canvas.drawLine(const Offset(14, 20), const Offset(26, 20), c);
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

class BukaBadge extends StatelessWidget {
  final String text;
  const BukaBadge({super.key, this.text = 'Buka'});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
            color: const Color(0xFFD8F5DF),
            borderRadius: BorderRadius.circular(8)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.storefront, size: 13, color: svGreen),
          const SizedBox(width: 3),
          Text(text,
              style: const TextStyle(
                  fontSize: 11, fontWeight: FontWeight.w600, color: svGreen)),
        ]),
      );
}

class MiniChip extends StatelessWidget {
  final String text;
  const MiniChip(this.text, {super.key});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
            color: const Color(0xFFEEF2F8),
            borderRadius: BorderRadius.circular(8)),
        child: Text(text,
            style: const TextStyle(
                fontSize: 11, fontWeight: FontWeight.w500, color: svSub)),
      );
}

/// Kartu lokasi (Beranda & Daftar Lokasi)
class FacilityTile extends StatelessWidget {
  final Faskes f;
  final bool detail; // tampilkan rating + chevron
  final int maxChips;
  final double foto;
  const FacilityTile(this.f,
      {super.key, this.detail = false, this.maxChips = 3, this.foto = 70});
  @override
  Widget build(BuildContext context) {
    final chips = f.layanan.take(maxChips).map((e) => MiniChip(e)).toList();
    if (!detail && f.layanan.length > maxChips)
      chips.add(const MiniChip('...'));
    return InkWell(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (_) => DetailScreen(faskes: f))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: faskesFoto(f, w: foto, h: foto)),
          const SizedBox(width: 12),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(
                    child: Text(f.nama,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w700))),
                const BukaBadge(),
              ]),
              const SizedBox(height: 4),
              Row(children: [
                const Icon(Icons.location_on, size: 14, color: svBlue),
                const SizedBox(width: 2),
                Text(jarakStr(f),
                    style: const TextStyle(fontSize: 11, color: svMut)),
                if (detail) ...[
                  const SizedBox(width: 10),
                  const Icon(Icons.star, size: 14, color: Color(0xFFF5B301)),
                  const SizedBox(width: 2),
                  Text('${rt(f.rating)} (${f.ulasan})',
                      style: const TextStyle(fontSize: 11, color: svMut)),
                ],
              ]),
              const SizedBox(height: 6),
              Wrap(spacing: 6, runSpacing: 4, children: chips),
            ]),
          ),
          if (detail)
            const Padding(
                padding: EdgeInsets.only(top: 20, left: 4),
                child: Icon(Icons.chevron_right, color: Color(0xFF9AA3B2))),
        ]),
      ),
    );
  }
}

class SearchBox extends StatelessWidget {
  final String hint;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final bool autofocus;
  final TextEditingController? controller;
  const SearchBox(this.hint,
      {super.key,
      this.onChanged,
      this.onTap,
      this.autofocus = false,
      this.controller});
  @override
  Widget build(BuildContext context) => TextField(
        controller: controller,
        autofocus: autofocus,
        readOnly: onTap != null,
        onTap: onTap,
        onChanged: onChanged,
        style: const TextStyle(fontSize: 13),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 13, color: svMut),
          prefixIcon: const Icon(Icons.search, size: 20, color: svSub),
          isDense: true,
          filled: true,
          fillColor: const Color(0xFFF4F6FA),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: const BorderSide(color: Color(0xFFE3E8F0))),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: const BorderSide(color: svBlue)),
        ),
      );
}

/// Baris chip filter (Semua / RS / Puskesmas / Klinik)
class FilterChips extends StatelessWidget {
  final List<String> items;
  final String selected;
  final ValueChanged<String> onSelect;
  const FilterChips(
      {super.key,
      required this.items,
      required this.selected,
      required this.onSelect});
  @override
  Widget build(BuildContext context) => SizedBox(
        height: 36,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (_, i) {
            final on = items[i] == selected;
            return GestureDetector(
              onTap: () => onSelect(items[i]),
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                    color: on ? svBlue : Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                        color: on ? svBlue : const Color(0xFFCDD5E0))),
                child: Text(items[i],
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: on ? Colors.white : svSub)),
              ),
            );
          },
        ),
      );
}

/// AppBar rata-kiri: panah kembali + judul
PreferredSizeWidget backBar(BuildContext context, String title,
        {List<Widget>? actions,
        VoidCallback? onBack,
        bool tampilBack = true}) =>
    AppBar(
      automaticallyImplyLeading: false,
      centerTitle: false,
      titleSpacing: tampilBack ? 0 : 16,
      leading: tampilBack
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: onBack ?? () => Navigator.pop(context))
          : null,
      title: Text(title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
      actions: actions,
    );
