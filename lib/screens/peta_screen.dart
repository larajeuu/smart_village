import 'package:flutter/material.dart';
import '../data/faskes.dart';
import '../widgets/smart_map.dart';

class PetaScreen extends StatelessWidget {
  const PetaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SmartMap(points: daftarFaskes);
  }
}