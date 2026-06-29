// lib/services/location_service.dart
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/foundation.dart';

class LocationService {
  /// Mengambil koordinat dan menerjemahkannya ke nama kota
  static Future<Map<String, dynamic>?> getLocationData() async {
    bool serviceEnabled;
    LocationPermission permission;

    try {
      // 1. Cek & Minta Izin GPS
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return null;

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return null;
      }
      if (permission == LocationPermission.deniedForever) return null;

      // 2. Ambil Koordinat
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // 3. Reverse Geocoding (Ubah Koordinat jadi Nama Kota)
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      String cityName = 'Unknown City';
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        // Mengambil nama kota atau kabupaten
        cityName = place.locality ?? place.subAdministrativeArea ?? place.administrativeArea ?? 'Unknown City';
      }

      // 4. Kembalikan data lengkapnya
      return {
        'latitude': position.latitude,
        'longitude': position.longitude,
        'city': cityName,
      };
    } catch (e) {
      debugPrint('Error mengambil lokasi/kota: $e');
      return null;
    }
  }
}