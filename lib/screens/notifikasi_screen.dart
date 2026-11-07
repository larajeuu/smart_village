import 'package:flutter/material.dart';
import '../services/notifikasi_service.dart';
import '../widgets/common.dart';
import '../widgets/sv_theme.dart';
import 'detail_screen.dart';

const _biruMuda = Color(0xFFF3F8FF);
const _oranye = Color(0xFFF59E0B);

class NotifikasiScreen extends StatelessWidget {
  const NotifikasiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final svc = NotifikasiService.instance;
    return Scaffold(
      appBar: backBar(context, 'Notifikasi', actions: [
        PopupMenuButton<String>(
          onSelected: (v) {
            if (v == 'baca') {
              svc.tandaiSemua();
            } else {
              svc.hapusSemua();
            }
          },
          itemBuilder: (_) => const [
            PopupMenuItem(value: 'baca', child: Text('Tandai semua dibaca')),
            PopupMenuItem(value: 'hapus', child: Text('Hapus semua')),
          ],
        ),
      ]),
      body: ValueListenableBuilder<List<Notifikasi>>(
        valueListenable: svc.items,
        builder: (context, list, _) {
          if (list.isEmpty) return const _Kosong();
          return ListView.separated(
            itemCount: list.length,
            separatorBuilder: (_, __) =>
                const Divider(height: 1, color: svLine),
            itemBuilder: (_, i) => _ItemNotif(list[i]),
          );
        },
      ),
    );
  }
}

class _ItemNotif extends StatelessWidget {
  final Notifikasi n;
  const _ItemNotif(this.n);

  @override
  Widget build(BuildContext context) {
    final masuk = n.jenis == JenisNotif.masuk;
    final warna = masuk ? svBlue : _oranye;
    return Dismissible(
      key: ValueKey(n.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: svRed,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      onDismissed: (_) => NotifikasiService.instance.hapus(n.id),
      child: InkWell(
        onTap: () {
          NotifikasiService.instance.tandaiDibaca(n.id);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => DetailScreen(faskes: n.faskes)));
        },
        child: Container(
          color: n.dibaca ? Colors.white : _biruMuda,
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                  color: warna.withOpacity(0.14), shape: BoxShape.circle),
              child: Icon(masuk ? Icons.location_on : Icons.exit_to_app,
                  color: warna, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Expanded(
                    child: Text(n.judul,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight:
                                n.dibaca ? FontWeight.w600 : FontWeight.w800,
                            color: svText)),
                  ),
                  if (!n.dibaca)
                    Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.only(left: 8),
                        decoration: const BoxDecoration(
                            color: svBlue, shape: BoxShape.circle)),
                ]),
                const SizedBox(height: 4),
                Text(n.isi,
                    style: const TextStyle(
                        fontSize: 12.5, height: 1.45, color: svSub)),
                const SizedBox(height: 6),
                Text(waktuRelatif(n.waktu),
                    style: const TextStyle(fontSize: 11, color: svMut)),
              ]),
            ),
          ]),
        ),
      ),
    );
  }
}

class _Kosong extends StatelessWidget {
  const _Kosong();

  @override
  Widget build(BuildContext context) => const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.notifications_none, size: 72, color: Color(0xFFB8C2D1)),
            SizedBox(height: 14),
            Text('Belum ada notifikasi',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            SizedBox(height: 6),
            Text(
                'Notifikasi muncul saat Anda masuk atau keluar area fasilitas kesehatan (geofencing).\n\nUntuk mencoba di emulator: buka tab Peta, lalu tekan lama di dekat pin fasilitas.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12.5, height: 1.5, color: svSub)),
          ]),
        ),
      );
}