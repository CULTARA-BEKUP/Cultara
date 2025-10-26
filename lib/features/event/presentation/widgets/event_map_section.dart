import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class EventMapSection extends StatelessWidget {
  final double latitude;
  final double longitude;

  const EventMapSection({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  @override
  Widget build(BuildContext context) {
    final LatLng eventLocation = LatLng(latitude, longitude);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Peta Lokasi',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 250,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(15),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: eventLocation,
                  initialZoom: 15.0,
                  minZoom: 5.0,
                  maxZoom: 18.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.cultara',
                    maxNativeZoom: 19,
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: eventLocation,
                        width: 40,
                        height: 40,
                        child: const Icon(
                          Icons.location_pin,
                          color: Colors.red,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
