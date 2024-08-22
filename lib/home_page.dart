import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'services/places_service.dart';
import 'services/location_service.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:convert';
import 'package:package_info_plus/package_info_plus.dart';
import 'utils/url_launcher.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PackageInfo _packageInfo = PackageInfo(
    version: 'Unknown',
    appName: 'Unknown',
    packageName: 'Unknown',
    buildNumber: 'Unknown',
  );

  String _location = "";
  String _infoTitle = 'Info:';
  String _info = "";
  String _url = "";
  double _radius = 50.0;
  bool _autoOpen = false;

  final Widget logo = SvgPicture.asset(
    'assets/logo.svg',
    semanticsLabel: 'Qclick Logo',
  );

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
    _loadSettings();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _autoOpen = prefs.getBool('autoOpen') ?? false;
    });

    if (_autoOpen) {
      _init();
    }
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('autoOpen', _autoOpen);
  }

  Future _init([double? lat, double? lng]) async {
    if (lat == null) {
      setState(() {
        _location = "Getting location...";
        _info = '';
      });
      final location = await LocationService.getLocation();
      lat = location['lat'];
      lng = location['lng'];
    }

    if (lat == null || lng == null) {
      setState(() {
        _location = 'Cannot get location $lat, $lng';
      });
    } else {
      setState(() {
        _location = '$lat, $lng';
      });

      Map<String, dynamic> result =
          await searchNearby(lat: lat, lng: lng, radius: _radius.round());

      if (result.containsKey('error')) {
        setState(() {
          _info = result['error'];
        });
      } else {
        String info = JsonEncoder.withIndent('   ')
            .convert(json.decode(jsonEncode(result)));

        setState(() {
          _info = info;
          _infoTitle = result['displayName'];
          _url = result['websiteUri'];
        });

        launchURL(_url);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Text(
          'Version: ${_packageInfo.appName} ${_packageInfo.version} ${_packageInfo.buildNumber}',
          style: Theme.of(context).textTheme.bodyMedium),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 20),

                    // logo
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click, // Changes cursor to pointer
                          child: GestureDetector(
                            onTap: _init,
                            child: logo,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    // auto open
                    SwitchListTile(
                      title: Text("Enable Auto-Open"),
                      value: _autoOpen,
                      onChanged: (bool value) {
                        setState(() {
                          _autoOpen = value;
                        });
                        _saveSettings();
                      },
                    ),

                    SizedBox(height: 20),

                    // radius
                    Text('Radius: ${_radius.round()} meters',
                        style: Theme.of(context).textTheme.headlineSmall),
                    Slider(
                      value: _radius,
                      min: 1.0,
                      max: 100.0,
                      divisions: 99,
                      label: _radius.round().toString(),
                      onChanged: (double value) {
                        setState(() {
                          _radius = value;
                        });
                      },
                    ),

                    SizedBox(height: 20),

                    // location
                    Text('Location:',
                        style: Theme.of(context).textTheme.headlineSmall),
                    SelectableText(
                      _location,
                    ),
                    
                    SizedBox(height: 20),

                    // info
                    Text(_infoTitle,
                        style: Theme.of(context).textTheme.headlineSmall),
                    SelectableText(
                      _info,
                    ),

                    SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            onPressed: _url == ""
                ? () {
                    setState(() {
                      _info = "No URL to open";
                    });
                  }
                : () {
                    setState(() {
                      _info = "$_info open";
                    });
                    launchURL(_url);
                  },
            tooltip: "Open URL: $_url",
            child: const Icon(Icons.launch),
          ),
          SizedBox(width: 10),
          FloatingActionButton(
            onPressed: () {
              _init(36.2033473, -81.6687935);
            },
            tooltip: 'AMB',
            child: const Icon(Icons.local_pizza_outlined),
          ),
          SizedBox(width: 10),
          FloatingActionButton(
            onPressed: () {
              _init(36.219124, -81.683365);
            },
            tooltip: 'Lost Province',
            child: const Icon(Icons.local_pizza),
          ),
        ],
      ),
    );
  }
}
