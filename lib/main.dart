import 'package:flutter/material.dart';
import 'package:location/location.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Lokasi saat ini', home: LocationScreen());
  }
}

class LocationScreen extends StatefulWidget {
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  Location location = Location();
  LocationData? _currentLocation;
  bool _serviceEnabled = true;
  PermissionStatus? _permissionGranted;

  Future<void> _getLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) return;
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) return;
    }

    final locationData = await location.getLocation();

    setState(() {
      _currentLocation = locationData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lokasi Saat Ini')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_currentLocation != null)
              Text(
                'Latitude: ${_currentLocation?.latitude ?? 'N/A'},\nLongitude: ${_currentLocation?.longitude ?? 'N/A'}',
              )
            else
              Text('Tekan tombol untuk mendapatkan lokasi'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getLocation,
              child: Text('Ambil Lokasi'),
            ),
          ],
        ),
      ),
    );
  }
}
