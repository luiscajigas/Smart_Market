import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math' show cos, sqrt, asin;

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

  // Lista de supermercados (Ejemplos en Bogotá, se pueden añadir más)
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

  Future<void> determinePosition() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _error = 'El servicio de ubicación está desactivado.';
        _isLoading = false;
        notifyListeners();
        return;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _error = 'Permiso de ubicación denegado.';
          _isLoading = false;
          notifyListeners();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _error = 'Permisos denegados permanentemente.';
        _isLoading = false;
        notifyListeners();
        return;
      }

      _currentPosition = await Geolocator.getCurrentPosition();
    } catch (e) {
      _error = 'Error al obtener ubicación: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  // Calcular distancia Haversine
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
