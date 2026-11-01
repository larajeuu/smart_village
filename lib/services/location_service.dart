import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../models/facility.dart';

class GeofenceEvent {
  final Facility facility;
  final bool entered;
  GeofenceEvent(this.facility, this.entered);
}

/// LBS: posisi pengguna (GPS / simulasi) + Geofencing berbasis jarak (Haversine).
class LocationService {
  LocationService._();
  static final instance = LocationService._();

  final position = ValueNotifier<LatLng>(demoCenter);
  final status = ValueNotifier<String>('Menunggu lokasi...');
  final events = StreamController<GeofenceEvent>.broadcast();
  final Set<String> insideIds = {};
  final _distance = const Distance();
  StreamSubscription<Position>? _sub;
  bool simulated = false;

  Future<void> init() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        status.value = 'GPS nonaktif - memakai lokasi demo';
        _update(demoCenter);
        return;
      }
      var perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.denied ||
          perm == LocationPermission.deniedForever) {
        status.value = 'Izin lokasi ditolak - memakai lokasi demo';
        _update(demoCenter);
        return;
      }
      final p = await Geolocator.getCurrentPosition();
      status.value = 'Lokasi GPS aktif';
      _update(LatLng(p.latitude, p.longitude));
      _sub?.cancel();
      _sub = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high, distanceFilter: 5),
      ).listen((p) {
        if (!simulated) _update(LatLng(p.latitude, p.longitude));
      });
    } catch (e) {
      status.value = 'Gagal membaca lokasi - memakai lokasi demo';
      _update(demoCenter);
    }
  }

  void simulate(LatLng p) {
    simulated = true;
    status.value = 'Mode simulasi lokasi';
    _update(p);
  }

  void useGps() {
    simulated = false;
    init();
  }

  void _update(LatLng p) {
    position.value = p;
    for (final f in facilities) {
      final inside = distanceTo(f) <= f.geofenceRadius;
      if (inside && insideIds.add(f.id)) {
        events.add(GeofenceEvent(f, true));
      } else if (!inside && insideIds.remove(f.id)) {
        events.add(GeofenceEvent(f, false));
      }
    }
  }

  double distanceTo(Facility f) =>
      _distance.as(LengthUnit.Meter, position.value, f.pos);

  static String format(double m) =>
      m < 1000 ? '${m.round()} m' : '${(m / 1000).toStringAsFixed(1)} km';
}
