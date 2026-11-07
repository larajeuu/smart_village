import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

enum FacilityType { hospital, puskesmas, clinic }

extension FacilityTypeX on FacilityType {
  String get label => switch (this) {
        FacilityType.hospital => 'Rumah Sakit',
        FacilityType.puskesmas => 'Puskesmas',
        FacilityType.clinic => 'Klinik',
      };
  IconData get icon => switch (this) {
        FacilityType.hospital => Icons.apartment,
        FacilityType.puskesmas => Icons.home_work,
        FacilityType.clinic => Icons.medical_services,
      };
  Color get color => switch (this) {
        FacilityType.hospital => const Color(0xFFE53935),
        FacilityType.puskesmas => const Color(0xFF2E9E5B),
        FacilityType.clinic => const Color(0xFF7E57C2),
      };
}

class Facility {
  final String id, name, category, address, phone;
  final FacilityType type;
  final LatLng pos;
  final List<String> services;
  final double rating; // angka, supaya bisa diurutkan
  final int reviewCount;
  final bool is24Hours;
  final String? image; // path asset foto, null = belum ada
  final double geofenceRadius; // meter

  const Facility({
    required this.id,
    required this.name,
    required this.category,
    required this.type,
    required this.pos,
    required this.address,
    required this.phone,
    required this.rating,
    required this.reviewCount,
    required this.services,
    this.is24Hours = false,
    this.image,
    this.geofenceRadius = 300,
  });

  /// Teks siap tampil, contoh: "4.5 (120 ulasan)"
  String get ratingLabel =>
      '${rating.toStringAsFixed(1)} ($reviewCount ulasan)';
}

/// Pusat area demo (Jakarta). Gunakan tekan lama di peta untuk simulasi lokasi.
const demoCenter = LatLng(-6.2000, 106.8166);

const facilities = <Facility>[
  Facility(
    id: 'rs1',
    name: 'RSUD Kabupaten X',
    category: 'RS Umum',
    type: FacilityType.hospital,
    pos: LatLng(-6.1985, 106.8180),
    address: 'Jl. Kepala Sukamaju No.10, Desa Sukamaju',
    phone: '(021) 1234 5678',
    rating: 4.5,
    reviewCount: 120,
    is24Hours: true,
    services: ['IGD', 'Poliklinik', 'Rawat Inap', 'Laboratorium', 'Radiologi'],
  ),
  Facility(
    id: 'rs2',
    name: 'RS Harapan Bunda',
    category: 'RS Umum',
    type: FacilityType.hospital,
    pos: LatLng(-6.2050, 106.8130),
    address: 'Jl. Harapan Bunda No.5',
    phone: '(021) 2222 3333',
    rating: 4.3,
    reviewCount: 88,
    is24Hours: true,
    services: ['IGD', 'Poliklinik', 'Laboratorium'],
  ),
  Facility(
    id: 'rs3',
    name: 'RS Sumber Sehat',
    category: 'RS Khusus',
    type: FacilityType.hospital,
    pos: LatLng(-6.1940, 106.8230),
    address: 'Jl. Sumber Sehat No.21',
    phone: '(021) 4444 5555',
    rating: 4.1,
    reviewCount: 64,
    services: ['Mata', 'Bedah', 'Rawat Inap'],
  ),
  Facility(
    id: 'rs4',
    name: 'RS Mitra Keluarga',
    category: 'RS Umum',
    type: FacilityType.hospital,
    pos: LatLng(-6.2120, 106.8260),
    address: 'Jl. Mitra Keluarga No.8',
    phone: '(021) 6666 7777',
    rating: 4.6,
    reviewCount: 210,
    is24Hours: true,
    services: ['IGD', 'Poliklinik', 'Laboratorium'],
  ),
  Facility(
    id: 'pk1',
    name: 'Puskesmas Sukamaju',
    category: 'Puskesmas',
    type: FacilityType.puskesmas,
    pos: LatLng(-6.2010, 106.8150),
    address: 'Jl. Sukamaju No.2',
    phone: '(021) 8888 1111',
    rating: 4.2,
    reviewCount: 45,
    services: ['Umum', 'KIA', 'Imunisasi', 'Gigi'],
    geofenceRadius: 250,
  ),
  Facility(
    id: 'pk2',
    name: 'Puskesmas Mekar Jaya',
    category: 'Puskesmas',
    type: FacilityType.puskesmas,
    pos: LatLng(-6.1960, 106.8100),
    address: 'Jl. Mekar Jaya No.14',
    phone: '(021) 8888 2222',
    rating: 4.0,
    reviewCount: 30,
    services: ['Umum', 'KIA', 'Gigi'],
    geofenceRadius: 250,
  ),
  Facility(
    id: 'kl1',
    name: 'Klinik Sehat Mandiri',
    category: 'Klinik',
    type: FacilityType.clinic,
    pos: LatLng(-6.2020, 106.8205),
    address: 'Jl. Mandiri No.3',
    phone: '(021) 9999 1212',
    rating: 4.4,
    reviewCount: 52,
    services: ['Umum', 'Gigi', 'Laboratorium'],
    geofenceRadius: 200,
  ),
  Facility(
    id: 'kl2',
    name: 'Klinik Pratama Asri',
    category: 'Klinik',
    type: FacilityType.clinic,
    pos: LatLng(-6.1975, 106.8120),
    address: 'Jl. Asri No.7',
    phone: '(021) 9999 3434',
    rating: 4.2,
    reviewCount: 27,
    services: ['Umum', 'KIA'],
    geofenceRadius: 200,
  ),
];
