import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/services/services.dart';

class ServicesApi {
  static const String apiUrl = 'https://chatdesk-prod.dialafrika.com/webchat/1/process'; // Replace with your API endpoint

  static Future<List<Services>> fetchServices() async {
    final Map<String, dynamic> requestPayload = {
      "route": "SERVICES",
    };

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(requestPayload),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      if (jsonResponse['success'] == true) {
        final List<dynamic> data = jsonResponse['data']['payload']['data'];
        return data.map((item) => Services.fromJson(item)).toList();
      }
    }

    return [];
  }
}