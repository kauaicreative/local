import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<Map<String, dynamic>> searchNearby({
  required double lat,
  required double lng,
  required int radius,
}) async {
  var client = http.Client();

  String? apiKey = Config.googleMapsApiKey;
  // String? apiKey = String.fromEnvironment('GOOGLE_MAPS_API_KEY');
  // if (Uri.base.queryParameters['api'] != null) { apiKey = Uri.base.queryParameters['api']; }
  // if (apiKey == null) throw ArgumentError('API key is required');

  print("Searching at: Lat,lng: $lat, $lng radius: $radius"); // Debug print

  // 'places.displayName,places.formattedAddress,places.types,places.websiteUri'
  var headers = {
    'Content-Type': 'application/json',
    'X-Goog-Api-Key': apiKey,
    'X-Goog-FieldMask': 'places.displayName,places.websiteUri'
  };
  var request = http.Request('POST',
      Uri.parse('https://places.googleapis.com/v1/places:searchNearby'));

  var body = {
    "includedTypes": ["restaurant", "bar"],
    "maxResultCount": 1,
    "locationRestriction": {
      "circle": {
        "center": {"latitude": lat, "longitude": lng},
        "radius": radius
      }
    }
  };

  request.body = json.encode(body);
  request.headers.addAll(headers);

  final response = await client.send(request);

  if (response.statusCode == 200) {
    var result = await response.stream.bytesToString();
    Map<String, dynamic> data = jsonDecode(result);
    if (data.isEmpty) return {'error': 'Nothing Found at location'};

    var place = data['places'][0];
    if (place == null) return {'error': 'Error'};

    String? displayName = place['displayName']['text'];
    String? websiteUri = place['websiteUri'];

    if (websiteUri == null) return {'error': 'No Website'};

    client.close();

    return {
      'websiteUri': websiteUri,
      'displayName': displayName,
      'data': data,
    };
  } else {
    var errorBody = await response.stream.bytesToString();
    print("Error Response: $errorBody");
    return {
      'error':
          "Error: ${response.statusCode} ${response.reasonPhrase}\nBody: $errorBody"
    };
  }
}
