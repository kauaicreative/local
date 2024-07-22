import 'package:flutter/material.dart';
import 'services/places_service.dart';
import 'services/location_service.dart';
// import 'package:logger_screen/logger_screen.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:flutter_json_view/flutter_json_view.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _location = "";
  String _info = "";

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future _init([double? lat, double? lng]) async {
    if (lat == null) {
      setState(() {
        _location = "Getting location...";
      });
      final location = await LocationService.getLocation();
      lat = location['lat'];
      lng = location['lng'];
    }

    setState(() {
      _location = '$lat, $lng';
    });

    String result = await searchNearby(lat: lat, lng: lng);

    setState(() {
      _info = result;
    });

    // print(result.places.websiteUri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),

      // body: TalkerScreen(talker: widget.talker),

      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Location:',
                  style: Theme.of(context).textTheme.headlineSmall),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SelectableText(_location,
                    style: Theme.of(context).textTheme.bodyMedium),
              ),
              SizedBox(height: 20),
              Text('Business:',
                  style: Theme.of(context).textTheme.headlineSmall),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SelectableText(
                  _info,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontFamily: 'RobotoMono'),
                ),
              ),
              SizedBox(height: 20), // Add spacing between text and buttons
            ],
          ),
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.startFloat, // This is the key line
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          FloatingActionButton(
            onPressed: _init,
            tooltip: 'Current Location',
            child: const Icon(Icons.location_on),
          ),
          SizedBox(width: 20), // Add spacing between buttons
          FloatingActionButton(
            onPressed: () {
              _init(36.219124, -81.683365);
            },
            tooltip: 'Lost Province',
            child: const Icon(Icons.local_pizza),
          ),
          SizedBox(width: 20), // Add spacing between buttons
          FloatingActionButton(
            onPressed: () {
              _init(36.2033473, -81.6687935);
            },
            tooltip: 'AMB',
            child: const Icon(Icons.local_drink),
          ),
        ],
      ),
    );
  }
}
