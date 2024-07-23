import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../config.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<String> searchNearby({
  required double lat,
  required double lng,
}) async {
  var client = http.Client();

  String? apiKey = Config.googleMapsApiKey;
  // String? apiKey = String.fromEnvironment('GOOGLE_MAPS_API_KEY');
  // if (Uri.base.queryParameters['api'] != null) { apiKey = Uri.base.queryParameters['api']; }
  // if (apiKey == null) throw ArgumentError('API key is required');

  print("Searching at: Lat: $lat, Lng: $lng"); // Debug print

  // 'places.displayName,places.formattedAddress,places.types,places.websiteUri'
  var headers = {
    'Content-Type': 'application/json',
    'X-Goog-Api-Key': apiKey,
    'X-Goog-FieldMask': 'places.displayName,places.types,places.websiteUri'
  };
  var request = http.Request('POST',
      Uri.parse('https://places.googleapis.com/v1/places:searchNearby'));

  var body = {
    "includedTypes": ["restaurant", "bar"],
    "maxResultCount": 1,
    "locationRestriction": {
      "circle": {
        "center": {"latitude": lat, "longitude": lng},
        "radius": 50
      }
    }
  };

  request.body = json.encode(body);
  request.headers.addAll(headers);

  print("Request body: ${request.body}"); // Debug print
  // print("Request headers: ${request.headers}"); // Debug print with keys

  final response = await client.send(request);

  if (response.statusCode == 200) {
    var result = await response.stream.bytesToString();
    print("API Response: $result"); // Debug print

    // Map<String, dynamic> data = jsonDecode(result);

    Map<String, dynamic> data = jsonDecode(result);
    if (data.isEmpty) return 'Nothing Found at location';

    var place = data['places'][0];
    if (place == null) return "Error";
    print(place);

    String? displayName = place['displayName']['text'];
    String? websiteUri = place['websiteUri'];

    if (websiteUri == null) return "No Websute";

    print(displayName);
    print(websiteUri);
    _launchURL(websiteUri);
    client.close();
    return data.toString();
  } else {
    var errorBody = await response.stream.bytesToString();
    print("Error Response: $errorBody"); // Debug print
    return "Error: ${response.statusCode} ${response.reasonPhrase}\nBody: $errorBody";
  }
}

void _launchURL(String urlString) async {
  final Uri url = Uri.parse(urlString);
  try {
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $urlString';
    }
  } catch (e) {
    debugPrint('Error launching URL: $e');
  }
}
