import 'package:flutter/material.dart';

import '../data/faskes.dart';

/// PLACEHOLDER - diisi pemilik layar bawah.
/// Kontrak: dibuka dengan RouteScreen(faskes: f).
class RouteScreen extends StatelessWidget {
  final Faskes faskes;
  const RouteScreen({super.key, required this.faskes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Rute ke ${faskes.nama}')),
      body: Center(child: Text('TODO: rute ke ${faskes.nama}')),
    );
  }
}
