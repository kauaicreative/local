import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart';

Future<void> launchURL(String urlString) async {
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
