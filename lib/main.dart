import 'package:flutter/material.dart';
import 'screens/shell.dart';
import 'services/location_service.dart';
import 'theme.dart';

final messengerKey = GlobalKey<ScaffoldMessengerState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SmartVillageApp());
}

class SmartVillageApp extends StatefulWidget {
  const SmartVillageApp({super.key});
  @override
  State<SmartVillageApp> createState() => _SmartVillageAppState();
}

class _SmartVillageAppState extends State<SmartVillageApp> {
  @override
  void initState() {
    super.initState();
    final svc = LocationService.instance;
    svc.init();
    // Notifikasi geofence (masuk / keluar area fasilitas)
    svc.events.stream.listen((e) {
      messengerKey.currentState
        ?..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          backgroundColor: e.entered ? Colors.green[700] : Colors.orange[800],
          content: Text(e.entered
              ? 'Anda memasuki area ${e.facility.name}'
              : 'Anda meninggalkan area ${e.facility.name}'),
        ));
    });
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Smart Village',
        debugShowCheckedModeBanner: false,
        scaffoldMessengerKey: messengerKey,
        theme: buildTheme(),
        home: const Shell(),
      );
}
