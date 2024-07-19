// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _location = "Getting location...";
  double? _latitude;
  double? _longitude;

  @override
  void initState() {
    super.initState();
    _getLocation();  // Automatically get the location when the app starts
  }

  void _getLocation() {
    html.window.navigator.geolocation.getCurrentPosition().then((position) {
      setState(() {
        _latitude = position.coords!.latitude as double?;
        _longitude = position.coords!.longitude as double?;
        _location = 'Latitude: $_latitude, Longitude: $_longitude';
      });
    }).catchError((error) {
      setState(() {
        _location = 'Error getting location: $error';
      });
    });
  }

  void _openGoogleMaps() {
    if (_latitude != null && _longitude != null) {
      final url = 'https://maps.google.com/?q=$_latitude,$_longitude';
      html.window.open(url, '_blank');
    } else {
      setState(() {
        _location = 'Location not available. Please get location first.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Location:',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SelectableText(
                _location,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _openGoogleMaps,  // Button to open Google Maps
              child: Text('Open in Google Maps'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getLocation,  // Floating Action Button to manually get location
        tooltip: 'Get Location',
        child: const Icon(Icons.location_on),
      ),
    );
  }
}
