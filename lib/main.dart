import 'package:flutter/material.dart';
import 'dart:html' as html;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Localr',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Localr'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String _location = "Tap the button to get location";
  double? _latitude;
  double? _longitude;

  void _getLocation() {
    setState(() {
      _counter++;
    });
    setState(() {
      _location = 'Getting location...';
    });
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
              '$_counter',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            SizedBox(height: 20),
            Text('Your location:',
                style: Theme.of(context).textTheme.headlineSmall),
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
              onPressed: _openGoogleMaps,
              child: Text('Open in Google Maps'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getLocation,
        tooltip: 'Get Location',
        child: const Icon(Icons.location_on),
      ),
    );
  }
}
