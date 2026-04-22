import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/mock_data.dart';

class SupermarketMapScreen extends StatefulWidget {
  const SupermarketMapScreen({super.key});

  @override
  State<SupermarketMapScreen> createState() => _SupermarketMapScreenState();
}

class _SupermarketMapScreenState extends State<SupermarketMapScreen> {
  late GoogleMapController _mapController;
  Position? _currentPosition;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _determinePosition();
    _loadMarkers();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    final position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = position;
    });

    if (_currentPosition != null) {
      _mapController.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        ),
      );
    }
  }

  void _loadMarkers() {
    for (var shop in MockData.supermarkets) {
      if (shop.latitude != null && shop.longitude != null) {
        _markers.add(
          Marker(
            markerId: MarkerId(shop.id),
            position: LatLng(shop.latitude!, shop.longitude!),
            infoWindow: InfoWindow(
                title: shop.name, snippet: '${shop.distance} km de ti'),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueAzure),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Supermercados Cercanos',
            style: TextStyle(color: AppColors.textPrimary)),
        backgroundColor: AppColors.background,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(3.4516, -76.5320), // Centro de Cali como default
              zoom: 14,
            ),
            onMapCreated: (controller) => _mapController = controller,
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            style: _mapStyle,
          ),
          if (_currentPosition == null)
            const Center(
                child: CircularProgressIndicator(color: AppColors.primary)),
        ],
      ),
    );
  }

  // Estilo oscuro para el mapa (opcional)
  final String _mapStyle = '''
  [
    {
      "elementType": "geometry",
      "stylers": [{"color": "#242f3e"}]
    },
    {
      "elementType": "labels.text.fill",
      "stylers": [{"color": "#746855"}]
    },
    {
      "elementType": "labels.text.stroke",
      "stylers": [{"color": "#242f3e"}]
    }
  ]
  ''';
}
