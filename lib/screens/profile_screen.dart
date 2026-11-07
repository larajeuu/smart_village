import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'help_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // Data dummy karena login masih simulasi. Nanti diganti data user asli.
  static const _name = 'Andi Pratama';
  static const _phone = '0812 3456 7890';

  void _soon(BuildContext context, String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$label belum tersedia')),
    );
  }

  Future<void> _logout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Keluar'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => _logout(context),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );

    if (confirmed == true || !context.mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const SplashScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => _soon(context, 'Pengaturan'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _UserCard(name: _name, phone: _phone),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                _MenuTile(
                  icon: Icons.location_on_outlined,
                  title: 'Lokasi Saya',
                  onTap: () => _soon(context, 'Lokasi Saya'),
                ),
                const Divider(height: 1),
                _MenuTile(
                  icon: Icons.notifications_none,
                  title: 'Notifikasi',
                  onTap: () => _soon(context, 'Notifikasi'),
                ),
                const Divider(height: 1),
                _MenuTile(
                  icon: Icons.language,
                  title: 'Bahasa',
                  value: 'Indonesia',
                  onTap: () => _soon(context, 'Bahasa'),
                ),
                const Divider(height: 1),
                _MenuTile(
                    icon: Icons.help_outline,
                    title: 'Bantuan',
                    onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const HelpScreen()),
                        )),
                const Divider(height: 1),
                _MenuTile(
                    icon: Icons.info_outline,
                    title: 'Tentang Aplikasi',
                    onTap: () => showAboutDialog(
                          context: context,
                          applicationName: 'Smart Village',
                          applicationVersion: '1.0.0',
                          applicationLegalese: 'UTS Pemrograman Mobile CIE511',
                        )),
              ],
            ),
          ),
          const SizedBox(height: 24),
          OutlinedButton(
            onPressed: () => _logout(context),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
            ),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }
}

class _UserCard extends StatelessWidget {
  const _UserCard({required this.name, required this.phone});

  final String name;
  final String phone;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Row(
      children: [
        CircleAvatar(
          radius: 32,
          backgroundColor: color.withOpacity(0.12),
          child: Icon(Icons.person, size: 36, color: color),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 2),
            Text(phone, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ],
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.value,
  });

  final IconData icon;
  final String title;
  final String? value; // teks di kanan, contoh: "Indonesia"
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (value != null)
            Text(value!, style: const TextStyle(color: Colors.grey)),
          const Icon(Icons.chevron_right),
        ],
      ),
      onTap: onTap,
    );
  }
}
