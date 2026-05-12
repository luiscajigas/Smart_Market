import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/product_model.dart';
import '../../../data/providers/location_provider.dart';

class SupermarketMapScreen extends StatefulWidget {
  const SupermarketMapScreen({super.key});

  @override
  State<SupermarketMapScreen> createState() => _SupermarketMapScreenState();
}

class _SupermarketMapScreenState extends State<SupermarketMapScreen> {
  final MapController _mapController = MapController();
  bool _listenerAttached = false;
  bool _followingUser = true;
  double _currentZoom = 14;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final provider = context.read<LocationProvider>();
      provider.startTracking();
      provider.loadSupermarketLocations();
      provider.addListener(_onLocationChanged);
      _listenerAttached = true;
    });
  }

  void _onLocationChanged() {
    if (!_followingUser) return;
    final pos = context.read<LocationProvider>().currentPosition;
    if (pos == null) return;
    _mapController.move(
      LatLng(pos.latitude, pos.longitude),
      _currentZoom,
    );
  }

  List<Marker> _buildMarkers(Position? userPosition, List<Supermarket> shops) {
    final markers = <Marker>[];

    if (userPosition != null) {
      markers.add(
        Marker(
          point: LatLng(userPosition.latitude, userPosition.longitude),
          width: 44,
          height: 44,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.18),
              shape: BoxShape.circle,
            ),
            child: Container(
              width: 18,
              height: 18,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      );
    }

    for (final shop in shops) {
      final lat = shop.latitude;
      final lng = shop.longitude;
      if (lat == null || lng == null) continue;

      final distanceKm = userPosition == null
          ? null
          : context.read<LocationProvider>().distanceKmTo(lat, lng);

      markers.add(Marker(
        point: LatLng(lat, lng),
        width: 44,
        height: 44,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => _showSupermarketSheet(
            shop: shop,
            distanceKm: distanceKm,
          ),
          child: const Icon(
            Icons.location_on,
            color: Colors.blue,
            size: 40,
          ),
        ),
      ));
    }
    return markers;
  }

  @override
  Widget build(BuildContext context) {
    final locationProvider = context.watch<LocationProvider>();
    final pos = locationProvider.currentPosition;
    final shops = locationProvider.supermarketLocations;
    final supermarketsError = locationProvider.supermarketsError;
    final isSupermarketsLoading = locationProvider.isSupermarketsLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Supermercados Cercanos',
            style: TextStyle(color: AppColors.textPrimary)),
        backgroundColor: AppColors.background,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: LatLng(
                pos?.latitude ?? 3.4516,
                pos?.longitude ?? -76.5320,
              ),
              initialZoom: _currentZoom,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all,
              ),
              onPositionChanged: (camera, hasGesture) {
                _currentZoom = camera.zoom ?? _currentZoom;
                if (hasGesture && _followingUser) {
                  setState(() => _followingUser = false);
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.smark_market',
              ),
              MarkerLayer(markers: _buildMarkers(pos, shops)),
            ],
          ),
          if (locationProvider.isLoading && pos == null)
            const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          Positioned(
            left: 12,
            right: 12,
            top: 12,
            child: _TopStatusCard(
              position: pos,
              error: locationProvider.error,
              onEnable: () async {
                await Geolocator.openLocationSettings();
              },
              onPermissions: () async {
                await Geolocator.openAppSettings();
              },
            ),
          ),
          Positioned(
            left: 12,
            right: 12,
            top: 58,
            child: _SupermarketsStatusCard(
              isLoading: isSupermarketsLoading,
              error: supermarketsError,
              count: shops.length,
              onRetry: () => context.read<LocationProvider>().loadSupermarketLocations(),
            ),
          ),
          Positioned(
            right: 14,
            bottom: 18,
            child: FloatingActionButton(
              heroTag: 'recenter_user',
              backgroundColor: AppColors.primary,
              onPressed: () async {
                setState(() => _followingUser = true);
                final p = context.read<LocationProvider>().currentPosition;
                if (p != null) {
                  _currentZoom = 16;
                  _mapController.move(
                    LatLng(p.latitude, p.longitude),
                    _currentZoom,
                  );
                }
              },
              child: const Icon(Icons.my_location, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openDirections({
    required double destinationLat,
    required double destinationLng,
  }) async {
    final origin = context.read<LocationProvider>().currentPosition;
    final uri = origin == null
        ? Uri.parse(
            'https://www.google.com/maps/dir/?api=1&destination=$destinationLat,$destinationLng&travelmode=driving',
          )
        : Uri.parse(
            'https://www.google.com/maps/dir/?api=1&origin=${origin.latitude},${origin.longitude}&destination=$destinationLat,$destinationLng&travelmode=driving',
          );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _showSupermarketSheet({
    required Supermarket shop,
    required double? distanceKm,
  }) {
    final lat = shop.latitude;
    final lng = shop.longitude;
    if (lat == null || lng == null) return;

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  shop.name,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.titleMedium?.color,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (shop.source != null && shop.source!.trim().isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    'Cadena: ${shop.source}',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodySmall?.color,
                      fontSize: 12,
                    ),
                  ),
                ],
                if (shop.address != null &&
                    shop.address!.trim().isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    shop.address!,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodySmall?.color,
                      fontSize: 12,
                    ),
                  ),
                ],
                const SizedBox(height: 6),
                Text(
                  'Lat/Lng: ${lat.toStringAsFixed(5)}, ${lng.toStringAsFixed(5)}',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  distanceKm == null
                      ? 'Distancia: —'
                      : 'Distancia: ${distanceKm.toStringAsFixed(1)} km',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _openDirections(
                      destinationLat: lat,
                      destinationLng: lng,
                    ),
                    child: const Text('Cómo llegar'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    if (_listenerAttached) {
      context.read<LocationProvider>().removeListener(_onLocationChanged);
    }
    super.dispose();
  }
}

class _TopStatusCard extends StatelessWidget {
  final Position? position;
  final String? error;
  final VoidCallback onEnable;
  final VoidCallback onPermissions;

  const _TopStatusCard({
    required this.position,
    required this.error,
    required this.onEnable,
    required this.onPermissions,
  });

  @override
  Widget build(BuildContext context) {
    final hasError = error != null && error!.isNotEmpty;
    final textColor =
        hasError ? Colors.red : Theme.of(context).textTheme.bodySmall?.color;

    final text = hasError
        ? error!
        : position == null
            ? 'Buscando tu ubicación...'
            : 'Ubicación: ${position!.latitude.toStringAsFixed(5)}, ${position!.longitude.toStringAsFixed(5)} (±${position!.accuracy.toStringAsFixed(0)}m)';

    return Material(
      color: Theme.of(context).colorScheme.surface.withOpacity(0.92),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Icon(
              hasError ? Icons.error_outline : Icons.gps_fixed,
              color: hasError ? Colors.red : AppColors.primary,
              size: 18,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: textColor, fontSize: 11),
              ),
            ),
            if (hasError) ...[
              const SizedBox(width: 10),
              TextButton(
                onPressed: onEnable,
                child: const Text('GPS'),
              ),
              TextButton(
                onPressed: onPermissions,
                child: const Text('Permiso'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SupermarketsStatusCard extends StatelessWidget {
  final bool isLoading;
  final String? error;
  final int count;
  final VoidCallback onRetry;

  const _SupermarketsStatusCard({
    required this.isLoading,
    required this.error,
    required this.count,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final hasError = error != null && error!.trim().isNotEmpty;
    final text = isLoading
        ? 'Cargando supermercados...'
        : hasError
            ? error!
            : 'Supermercados cargados: $count';

    return Material(
      color: Theme.of(context).colorScheme.surface.withOpacity(0.92),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Icon(
              hasError ? Icons.error_outline : Icons.store_mall_directory_outlined,
              color: hasError ? Colors.red : AppColors.primary,
              size: 18,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: hasError ? Colors.red : Theme.of(context).textTheme.bodySmall?.color,
                  fontSize: 11,
                ),
              ),
            ),
            if (hasError)
              TextButton(
                onPressed: onRetry,
                child: const Text('Reintentar'),
              ),
          ],
        ),
      ),
    );
  }
}
