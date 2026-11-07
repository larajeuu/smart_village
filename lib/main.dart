import 'dart:async';

import 'package:flutter/material.dart';

import 'screens/splash_screen.dart';
import 'services/favorites_service.dart';
import 'services/notification_service.dart';
import 'services/notifikasi_service.dart';
import 'theme.dart';
import 'widgets/geofence_popup.dart';

final messengerKey = GlobalKey<ScaffoldMessengerState>();
final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Dimuat sebelum UI tampil supaya favorit sudah siap dibaca layar.
  await FavoritesService.instance.init();
  await NotificationService.instance.init();
  runApp(const SmartVillageApp());
}

class SmartVillageApp extends StatefulWidget {
  const SmartVillageApp({super.key});
  @override
  State<SmartVillageApp> createState() => _SmartVillageAppState();
}

class _SmartVillageAppState extends State<SmartVillageApp> {
  StreamSubscription<Notifikasi>? _sub;

  @override
  void initState() {
    super.initState();
    // Satu-satunya pintu event geofence: NotifikasiService.
    // Snackbar masuk/keluar sudah ditangani di sana.
    _sub = NotifikasiService.instance.kejadian.listen((n) {
      if (n.jenis != JenisNotif.masuk) return;
      NotificationService.instance.showGeofenceEnter(n.faskes);
      final ctx = navigatorKey.currentContext;
      if (ctx != null) showGeofencePopup(ctx, n.faskes);
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Smart Village',
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        scaffoldMessengerKey: messengerKey,
        theme: buildTheme(),
        home: const SplashScreen(),
      );
}
