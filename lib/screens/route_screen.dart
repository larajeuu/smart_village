import 'package:flutter/material.dart';
import '../models/facility.dart';

/// PLACEHOLDER - diisi pemilik layar bawah.
/// Kontrak: dibuka dari Detail dengan RouteScreen(facility: f).
class RouteScreen extends StatelessWidget {
  final Facility facility;
  const RouteScreen({super.key, required this.facility});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Rute ke ${facility.name}')),
      body: Center(child: Text('TODO: rute ke ${facility.name}')),
    );
  }
}
