import 'package:flutter/material.dart';
import 'peta_lokasi_screen.dart';

/// Tab "Peta" pada Shell. Isinya layar Peta Lokasi.
class PetaScreen extends StatelessWidget {
  /// Opsional: kalau Shell mengisinya, panah kembali muncul di tab ini.
  final VoidCallback? onBack;
  const PetaScreen({super.key, this.onBack});

  @override
  Widget build(BuildContext context) => PetaLokasiScreen(onBack: onBack);
}
