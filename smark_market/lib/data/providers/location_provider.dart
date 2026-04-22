import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math' show cos, sqrt, asin;
import '../../../core/constants/app_messages.dart';

class SupermarketLocation {
  final String name;
  final String source; // 'alkosto', 'exito', 'jumbo'
  final double latitude;
  final double longitude;
  final String address;

  SupermarketLocation({
    required this.name,
    required this.source,
    required this.latitude,
    required this.longitude,
    required this.address,
  });
}

class LocationProvider extends ChangeNotifier {
  Position? _currentPosition;
  bool _isLoading = false;
  String? _error;

  Position? get currentPosition => _currentPosition;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // List of supermarkets (Examples in Bogotá, more can be added)
  final List<SupermarketLocation> _supermarkets = [
    SupermarketLocation(
      name: 'Alkosto 68',
      source: 'alkosto',
      latitude: 4.6644,
      longitude: -74.0865,
      address: 'Av. Cra 68 # 72-43',
    ),
    SupermarketLocation(
      name: 'Éxito Calle 80',
      source: 'exito',
      latitude: 4.6897,
      longitude: -74.0825,
      address: 'Calle 80 # 69Q-50',
    ),
    SupermarketLocation(
      name: 'Jumbo Calle 80',
      source: 'jumbo',
      latitude: 4.7001,
      longitude: -74.0850,
      address: 'Calle 80 # 116B-05',
    ),
  ];

  /// Determine the current position of the device
  Future<void> determinePosition() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _error = AppMessages.locationDisabled;
        _isLoading = false;
        notifyListeners();
        return;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _error = AppMessages.locationDenied;
          _isLoading = false;
          notifyListeners();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _error = AppMessages.locationPermanentlyDenied;
        _isLoading = false;
        notifyListeners();
        return;
      }

      _currentPosition = await Geolocator.getCurrentPosition();
    } catch (e) {
      _error = '${AppMessages.locationError}$e';
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Calculate Haversine distance
  double _calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  List<Map<String, dynamic>> getNearbySupermarkets() {
    if (_currentPosition == null) return [];

    List<Map<String, dynamic>> nearby = [];
    for (var shop in _supermarkets) {
      double distance = _calculateDistance(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        shop.latitude,
        shop.longitude,
      );
      nearby.add({
        'supermarket': shop,
        'distance': distance,
      });
    }

    nearby.sort((a, b) => a['distance'].compareTo(b['distance']));
    return nearby;
  }
}
