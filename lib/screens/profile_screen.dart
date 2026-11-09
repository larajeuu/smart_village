import 'package:flutter/material.dart';

import '../data/faskes.dart';
import '../services/favorites_service.dart';
import '../services/notifikasi_service.dart';
import '../widgets/common.dart';
import '../widgets/sv_theme.dart';
import 'help_screen.dart';
import 'notifikasi_screen.dart';
import 'splash_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // Data dummy karena login masih simulasi.
  static const _name = 'Andi Pratama';
  static const _phone = '0812 3456 7890';

  void _snack(BuildContext context, String teks) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(teks)));
  }

  // ---------- KELUAR ----------
  Future<void> _logout(BuildContext context) async {
    final yakin = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Keluar'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Batal')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Keluar')),
        ],
      ),
    );
    if (yakin != true || !context.mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const SplashScreen()),
      (_) => false,
    );
  }

  // ---------- LOKASI SAYA ----------
  void _lokasiSaya(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => ValueListenableBuilder(
        valueListenable: userPos,
        builder: (_, pos, __) {
          final urut = [...daftarFaskes]
            ..sort((a, b) => jarakKm(a, pos).compareTo(jarakKm(b, pos)));
          final dekat = urut.first;
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.my_location, color: svBlue, size: 36),
              const SizedBox(height: 8),
              const Text('Lokasi Saya',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              Text(
                  '${pos.latitude.toStringAsFixed(5)}, ${pos.longitude.toStringAsFixed(5)}',
                  style: const TextStyle(fontSize: 14)),
              const SizedBox(height: 4),
              Text(modeSimulasi ? 'Sumber: lokasi simulasi' : 'Sumber: GPS',
                  style: const TextStyle(fontSize: 12, color: svMut)),
              const SizedBox(height: 10),
              Text('Terdekat: ${dekat.nama} (${fmtKm(jarakKm(dekat, pos))})',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 13, color: svSub)),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                      backgroundColor: svBlue,
                      minimumSize: const Size.fromHeight(46),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14))),
                  onPressed: () async {
                    await kembaliKeGps();
                    if (ctx.mounted) Navigator.pop(ctx);
                    if (context.mounted) {
                      _snack(context, 'Lokasi diperbarui dari GPS');
                    }
                  },
                  child: const Text('Perbarui dari GPS'),
                ),
              ),
            ]),
          );
        },
      ),
    );
  }

  // ---------- BAHASA ----------
  void _bahasa(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Column(mainAxisSize: MainAxisSize.min, children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text('Bahasa',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        ),
        ListTile(
          title: const Text('Indonesia'),
          trailing: const Icon(Icons.check_circle, color: svBlue),
          onTap: () => Navigator.pop(ctx),
        ),
        const ListTile(
          enabled: false,
          title: Text('English'),
          subtitle: Text('Segera hadir'),
        ),
        const SizedBox(height: 12),
      ]),
    );
  }

  // ---------- PENGATURAN (ikon gear) ----------
  void _pengaturan(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Column(mainAxisSize: MainAxisSize.min, children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text('Pengaturan',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        ),
        ListTile(
          leading: const Icon(Icons.gps_fixed),
          title: const Text('Gunakan lokasi GPS'),
          onTap: () async {
            Navigator.pop(ctx);
            await kembaliKeGps();
            if (context.mounted) _snack(context, 'Kembali memakai lokasi GPS');
          },
        ),
        ListTile(
          leading: const Icon(Icons.notifications_off_outlined),
          title: const Text('Hapus semua notifikasi'),
          onTap: () {
            Navigator.pop(ctx);
            NotifikasiService.instance.hapusSemua();
            _snack(context, 'Semua notifikasi dihapus');
          },
        ),
        ListTile(
          leading: const Icon(Icons.heart_broken_outlined),
          title: const Text('Hapus semua favorit'),
          onTap: () {
            Navigator.pop(ctx);
            for (final id in {...FavoritesService.instance.ids.value}) {
              FavoritesService.instance.toggle(id);
            }
            _snack(context, 'Semua favorit dihapus');
          },
        ),
        const SizedBox(height: 12),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Profil',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: svSub),
            onPressed: () => _pengaturan(context),
          ),
        ],
      ),
      body: ListView(children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: _UserCard(name: _name, phone: _phone),
        ),
        _MenuTile(
            icon: Icons.location_on_outlined,
            title: 'Lokasi Saya',
            onTap: () => _lokasiSaya(context)),
        _MenuTile(
            icon: Icons.notifications_none,
            title: 'Notifikasi',
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const NotifikasiScreen()))),
        _MenuTile(
            icon: Icons.language,
            title: 'Bahasa',
            value: 'Indonesia',
            onTap: () => _bahasa(context)),
        _MenuTile(
            icon: Icons.help_outline,
            title: 'Bantuan',
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const HelpScreen()))),
        _MenuTile(
            icon: Icons.info_outline,
            title: 'Tentang Aplikasi',
            onTap: () => showAboutDialog(
                  context: context,
                  applicationName: 'Smart Village',
                  applicationVersion: '1.0.0',
                  applicationLegalese: 'UTS Pemrograman Mobile CIE511',
                )),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 28, 16, 24),
          child: OutlinedButton(
            onPressed: () => _logout(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: svText,
              minimumSize: const Size.fromHeight(48),
              side: const BorderSide(color: Color(0xFFCDD5E0)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
            child: const Text('Keluar',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          ),
        ),
      ]),
    );
  }
}

class _UserCard extends StatelessWidget {
  const _UserCard({required this.name, required this.phone});
  final String name;
  final String phone;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
        width: 62,
        height: 62,
        decoration: const BoxDecoration(
            color: Color(0xFFDCEBFF), shape: BoxShape.circle),
        child: const Icon(Icons.person, size: 38, color: svBlue),
      ),
      const SizedBox(width: 14),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(name,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
        const SizedBox(height: 2),
        Text(phone, style: const TextStyle(fontSize: 13, color: svMut)),
      ]),
    ]);
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile(
      {required this.icon,
      required this.title,
      required this.onTap,
      this.value});
  final IconData icon;
  final String title;
  final String? value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: svLine))),
        child: Row(children: [
          Icon(icon, size: 22, color: svSub),
          const SizedBox(width: 14),
          Expanded(child: Text(title, style: const TextStyle(fontSize: 14))),
          if (value != null)
            Text(value!, style: const TextStyle(fontSize: 12, color: svMut)),
          const Icon(Icons.chevron_right, color: Color(0xFF9AA3B2)),
        ]),
      ),
    );
  }
}