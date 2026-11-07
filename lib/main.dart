import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'services/favorites_service.dart';
import 'services/location_service.dart';
import 'services/notification_service.dart';
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
  @override
  void initState() {
    super.initState();
    final svc = LocationService.instance;
    svc.init();
    // Notifikasi geofence (masuk / keluar area fasilitas)
    svc.events.stream.listen((e) {
      if (e.entered) {
        NotificationService.instance.showGeofenceEnter(e.facility);
        final ctx = navigatorKey.currentContext;
        if (ctx != null) showGeofencePopup(ctx, e);
      } else {
        messengerKey.currentState
          ?..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(
            backgroundColor: Colors.orange[800],
            content: Text('Anda meninggalkan area ${e.facility.name}'),
          ));
      }
    });
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
