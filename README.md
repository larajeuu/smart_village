# Smart Village - LBS & Geofencing (Flutter)

## Cara menjalankan
1. `flutter create --project-name smart_village .`  (jalankan di dalam folder ini, membuat folder android/ios; file lib/ dan pubspec.yaml tidak ditimpa)
2. `flutter pub get`
3. Tambahkan izin lokasi (lihat di bawah), lalu `flutter run`

## Izin Android (android/app/src/main/AndroidManifest.xml, di dalam <manifest>)
```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
```

## Izin iOS (ios/Runner/Info.plist)
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Aplikasi membutuhkan lokasi untuk mencari fasilitas kesehatan terdekat.</string>
```

## Fitur
- LBS: posisi GPS real-time (geolocator), jarak ke fasilitas (Haversine), daftar diurutkan terdekat.
- Geofencing: tiap fasilitas punya radius (200-300 m). Notifikasi saat masuk/keluar area.
- Peta OpenStreetMap (flutter_map, tanpa API key), lingkaran geofence, filter kategori.
- Uji di emulator: tekan lama di peta untuk memindahkan lokasi simulasi.
