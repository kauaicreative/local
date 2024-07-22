import 'package:flutter/material.dart';
import 'services/places_service.dart';
import 'services/location_service.dart';
import 'package:url_launcher/url_launcher.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _location = "";
  String _businessInfo = "";

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future _init() async {
    _location = "Getting location...";
    final location = await LocationService.getLocation();
    double? lat = location['lat'];
    double? lng = location['lng'];

    lat = 36.219124;
    lng = -81.683365;

    setState(() {
      _location = 'Latitude: $lat, Longitude: $lng';
    });

    String result = await searchNearby(lat: lat, lng: lng);

    setState(() {
      _businessInfo = result;
    });

    

    // print(result.places.websiteUri);
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
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _init,
        tooltip: 'Get Location',
        child: const Icon(Icons.location_on),
      ),
    );
  }
}
