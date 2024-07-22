import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:url_launcher/url_launcher.dart';

Future<String> searchNearby({
  required double? lat,
  required double? lng,
}) async {
  var client = http.Client();

  try {
    String? apiKey = dotenv.env['GOOGLE_MAPS_API'];
    if (apiKey == null) {
      throw ArgumentError('API key is required');
    }

    if (lat == null || lng == null) {
      throw ArgumentError('Latitude and longitude are required');
    }

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

      Map<String, dynamic> data = jsonDecode(result);
      var place = data['places'][0];
      String displayName = place['displayName']['text'].toString();
      String websiteUri = place['websiteUri'];
      print(displayName);
      print(websiteUri);
      _launchURL(websiteUri);

      return result;
    } else {
      var errorBody = await response.stream.bytesToString();
      print("Error Response: $errorBody"); // Debug print
      return "Error: ${response.statusCode} ${response.reasonPhrase}\nBody: $errorBody";
    }
  } catch (e) {
    print("Exception occurred: $e"); // Debug print
    return "An error occurred: $e";
  } finally {
    client.close();
  }
}

void _launchURL(String urlString) async {
  final Uri url = Uri.parse(urlString);
  try {
    // Check if the URL can be launched
    if (await canLaunchUrl(url)) {
      // Launch the URL
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $urlString';
    }
  } catch (e) {
    // Handle errors
    debugPrint('Error launching URL: $e');
  }
}
