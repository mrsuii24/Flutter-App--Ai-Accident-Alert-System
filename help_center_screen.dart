import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../widget/consts.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  _HelpCenterScreenState createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  Position? _currentPosition;
  String? _nearestLocation;
  LatLng myCurrentLocation = const LatLng(27.7172, 85.3240);
  late GoogleMapController googleMapController;
  Set<Marker> markers = {}; // Keep all markers in this set
  late StreamSubscription<Position> positionStream;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _startTrackingLocation();
    _addLocationMarkers(); // Add location markers initially
  }

  Future<void> _startTrackingLocation() async {
    positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((Position position) {
      setState(() {
        myCurrentLocation = LatLng(position.latitude, position.longitude);
        // Don't clear existing markers, just add the new current location
        markers.add(
          Marker(
            markerId: const MarkerId('currentLocation'),
            position: myCurrentLocation,
          ),
        );
      });

      googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: myCurrentLocation,
            zoom: 14,
          ),
        ),
      );
    });
  }

  void _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location services are disabled.')),
      );
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are denied.')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Location permissions are permanently denied.')),
      );
      return;
    }

    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _currentPosition = position;
      _nearestLocation = _findNearestLocation(position);
      myCurrentLocation = LatLng(position.latitude, position.longitude);
      markers.add(
        Marker(
          markerId: const MarkerId('currentLocation'),
          position: myCurrentLocation,
        ),
      );
    });

    googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: myCurrentLocation,
          zoom: 14,
        ),
      ),
    );
  }

  String _findNearestLocation(Position currentPosition) {
    double calculateDistance(
        double lat1, double lon1, double lat2, double lon2) {
      const double p = 0.017453292519943295; // pi / 180
      final double a = 0.5 -
          cos((lat2 - lat1) * p) / 2 +
          cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
      return 12742 * asin(sqrt(a)); // 2 * R * asin...
    }

    String nearestLocation = Consts().locations.first['name'] as String;
    double minDistance = calculateDistance(
      currentPosition.latitude,
      currentPosition.longitude,
      Consts().locations.first['latitude'] as double,
      Consts().locations.first['longitude'] as double,
    );

    for (var location in Consts().locations) {
      final distance = calculateDistance(
        currentPosition.latitude,
        currentPosition.longitude,
        location['latitude'] as double,
        location['longitude'] as double,
      );

      if (distance < minDistance) {
        minDistance = distance;
        nearestLocation = location['name'] as String;
      }
    }

    return nearestLocation;
  }

  // Method to add blue markers for all locations
  void _addLocationMarkers() {
    for (var location in Consts().locations) {
      final marker = Marker(
        markerId: MarkerId(location['name'] as String),
        position: LatLng(
          location['latitude'] as double,
          location['longitude'] as double,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueBlue), // Set the marker color to blue
      );

      setState(() {
        markers.add(marker);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        automaticallyImplyLeading: false,
        title: const Text(
          'Help Centers',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        elevation: 8.0,
      ),
      body: Container(
        color: Colors.grey[800],
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20.0),
              const Text(
                'Nearest Help Center:',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10.0),
              DropdownButtonFormField<String>(
                value: _nearestLocation,
                items: Consts()
                    .locations
                    .map((location) => DropdownMenuItem<String>(
                          value: location['name'] as String,
                          child: Text(
                            location['name'] as String,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ))
                    .toList(),
                onChanged: null, // User cannot change the dropdown value
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[900],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                disabledHint: Text(
                  _nearestLocation ?? 'Fetching nearest location...',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                height: 500, // Set the height to the desired size
                width: double
                    .infinity, // Set the width to fill the available space
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                      16.0), // Set the roundness of the corners
                  border: Border.all(
                      color: Colors.white,
                      width: 2), // Optional: Add a border color and width
                ),
                child: GoogleMap(
                  myLocationButtonEnabled: false,
                  markers: markers,
                  onMapCreated: (GoogleMapController controller) {
                    googleMapController = controller;
                  },
                  initialCameraPosition: CameraPosition(
                    target: myCurrentLocation,
                    zoom: 14,
                  ),
                ),
              ),
              const Spacer(),
              const Text(
                '''This feature helps you find the nearest help center based on your current location.''',
                style: TextStyle(color: Colors.white70, fontSize: 12.0),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
