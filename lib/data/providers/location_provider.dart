import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math' show cos, sqrt, asin;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/constants/app_messages.dart';
import '../models/product_model.dart';

class LocationProvider extends ChangeNotifier {
  final SupabaseClient _client = Supabase.instance.client;

  Position? _currentPosition;
  StreamSubscription<Position>? _positionSubscription;
  bool _isTracking = false;
  bool _isLoading = false;
  String? _error;

  List<Supermarket> _supermarketLocations = [];
  bool _isSupermarketsLoading = false;
  String? _supermarketsError;

  Position? get currentPosition => _currentPosition;
  bool get isTracking => _isTracking;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<Supermarket> get supermarketLocations => _supermarketLocations;
  bool get isSupermarketsLoading => _isSupermarketsLoading;
  String? get supermarketsError => _supermarketsError;

  List<Supermarket> get supermarketChains {
    final byChain = <String, Supermarket>{};
    for (final s in _supermarketLocations) {
      final chain = (s.source ?? '').trim().toLowerCase();
      if (chain.isEmpty) continue;
      byChain.putIfAbsent(
        chain,
        () => Supermarket(
          id: chain,
          source: chain,
          name: _nameForChain(chain),
          logo: _logoForChain(chain),
          rating: 4.5,
        ),
      );
    }
    final list = byChain.values.toList();
    list.sort((a, b) => a.name.compareTo(b.name));
    return list;
  }

  Future<bool> _ensurePermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _error = AppMessages.locationDisabled;
      return false;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _error = AppMessages.locationDenied;
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _error = AppMessages.locationPermanentlyDenied;
      return false;
    }

    return true;
  }

  Future<void> startTracking() async {
    if (_isTracking) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final ok = await _ensurePermission();
      if (!ok) return;

      _currentPosition = await Geolocator.getCurrentPosition();

      final settings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      );

      _positionSubscription = Geolocator.getPositionStream(
        locationSettings: settings,
      ).listen((pos) {
        _currentPosition = pos;
        _error = null;
        notifyListeners();
      }, onError: (e) {
        _error = '${AppMessages.locationError}$e';
        notifyListeners();
      });

      _isTracking = true;
    } catch (e) {
      _error = '${AppMessages.locationError}$e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> stopTracking() async {
    await _positionSubscription?.cancel();
    _positionSubscription = null;
    _isTracking = false;
    notifyListeners();
  }

  Future<void> loadSupermarketLocations() async {
    if (_isSupermarketsLoading) return;

    _isSupermarketsLoading = true;
    _supermarketsError = null;
    notifyListeners();

    try {
      final response = await _client
          .from('supermarket_locations')
          .select('id, chain, name, latitude, longitude, address')
          .order('chain')
          .order('name');

      final rows = (response is List) ? response : const [];

      _supermarketLocations = rows.map((row) {
        final chain = (row['chain'] ?? '').toString().trim().toLowerCase();
        final name = (row['name'] ?? '').toString().trim();
        final id = (row['id'] ?? '$chain-$name').toString();

        final lat = row['latitude'];
        final lng = row['longitude'];
        final latitude = lat is num ? lat.toDouble() : double.tryParse('$lat');
        final longitude = lng is num ? lng.toDouble() : double.tryParse('$lng');

        return Supermarket(
          id: id,
          source: chain,
          name: name.isEmpty ? chain : name,
          logo: _logoForChain(chain),
          rating: 4.5,
          latitude: latitude,
          longitude: longitude,
          address: (row['address'] ?? '').toString().trim().isEmpty
              ? null
              : (row['address'] ?? '').toString().trim(),
        );
      }).toList();
    } catch (e) {
      _supermarketsError = e.toString();
      _supermarketLocations = [];
    } finally {
      _isSupermarketsLoading = false;
      notifyListeners();
    }
  }

  String _logoForChain(String chain) {
    switch (chain) {
      case 'exito':
        return 'EX';
      case 'alkosto':
        return 'AK';
      case 'jumbo':
        return 'JU';
      default:
        return chain.isEmpty ? 'SM' : chain.substring(0, 1).toUpperCase();
    }
  }

  String _nameForChain(String chain) {
    switch (chain) {
      case 'exito':
        return 'Éxito';
      case 'alkosto':
        return 'Alkosto';
      case 'jumbo':
        return 'Jumbo';
      default:
        return chain;
    }
  }

  /// One-shot location (kept for compatibility)
  Future<void> determinePosition() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final ok = await _ensurePermission();
      if (!ok) return;

      _currentPosition = await Geolocator.getCurrentPosition();
    } catch (e) {
      _error = '${AppMessages.locationError}$e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  double distanceKmTo(double latitude, double longitude) {
    final pos = _currentPosition;
    if (pos == null) return double.infinity;
    return _calculateDistance(pos.latitude, pos.longitude, latitude, longitude);
  }

  double? distanceKmToChain(String chain) {
    final pos = _currentPosition;
    if (pos == null) return null;

    final normalized = chain.trim().toLowerCase();
    final candidates = _supermarketLocations.where((s) {
      final source = (s.source ?? '').trim().toLowerCase();
      return source == normalized;
    }).toList();
    if (candidates.isEmpty) return null;

    double? best;
    for (final s in candidates) {
      final lat = s.latitude;
      final lng = s.longitude;
      if (lat == null || lng == null) continue;
      final d = _calculateDistance(pos.latitude, pos.longitude, lat, lng);
      best = (best == null || d < best) ? d : best;
    }
    return best;
  }

  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    final p = 0.017453292519943295;
    final c = cos;
    final a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  List<Map<String, dynamic>> getNearbySupermarkets(
    List<Supermarket> supermarkets, {
    double? maxDistanceKm,
  }) {
    final pos = _currentPosition;
    if (pos == null) return [];

    final nearby = <Map<String, dynamic>>[];
    for (final shop in supermarkets) {
      final lat = shop.latitude;
      final lng = shop.longitude;
      if (lat == null || lng == null) continue;

      final distanceKm =
          _calculateDistance(pos.latitude, pos.longitude, lat, lng);
      if (maxDistanceKm != null && distanceKm > maxDistanceKm) continue;

      nearby.add({
        'supermarket': shop,
        'distanceKm': distanceKm,
      });
    }

    nearby.sort((a, b) =>
        (a['distanceKm'] as double).compareTo(b['distanceKm'] as double));
    return nearby;
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    super.dispose();
  }
}
