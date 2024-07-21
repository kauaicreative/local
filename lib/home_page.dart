// Maps AIP Key AIzaSyDdtoNEA3bmTJnyBzE2WHuoZL5ENpev_ks
import 'dart:html' as html;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
  String _businessInfo = "";

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  void _getLocation() {
    html.window.navigator.geolocation.getCurrentPosition().then((position) {
      setState(() {
        _latitude = position.coords!.latitude as double?;
        _longitude = position.coords!.longitude as double?;
        _location = 'Latitude: $_latitude, Longitude: $_longitude';
      });
      _getBusinessInfo();
    }).catchError((error) {
      setState(() {
        _location = 'Error getting location: $error';
      });
    });
  }

  Future<void> _getBusinessInfo() async {
    if (_latitude == null || _longitude == null) return;

    const apiKey = 'AIzaSyDdtoNEA3bmTJnyBzE2WHuoZL5ENpev_ks';
    final url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$_latitude,$_longitude&radius=50&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['results'].isNotEmpty) {
          final place = data['results'][0];
          final placeId = place['place_id'];
          
          // Get place details
          final detailsUrl = 'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=name,opening_hours,website&key=$apiKey';
          final detailsResponse = await http.get(Uri.parse(detailsUrl));
          if (detailsResponse.statusCode == 200) {
            final detailsData = json.decode(detailsResponse.body);
            final result = detailsData['result'];
            setState(() {
              _businessInfo = 'Name: ${result['name']}\n';
              if (result['opening_hours'] != null) {
                _businessInfo += 'Hours: ${result['opening_hours']['weekday_text'].join(', ')}\n';
              }
              if (result['website'] != null) {
                _businessInfo += 'Website: ${result['website']}';
              }
            });
          }
        } else {
          setState(() {
            _businessInfo = 'No businesses found nearby.';
          });
        }
      } else {
        setState(() {
          _businessInfo = 'Error fetching business info.';
        });
      }
    } catch (e) {
      setState(() {
        _businessInfo = 'Error: $e';
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
            Text(
              'Business Info:',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SelectableText(
                _businessInfo,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
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