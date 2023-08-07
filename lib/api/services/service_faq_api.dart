import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../models/faq/faq.dart';

class ServiceFaqApi {
  static const String apiUrl = 'https://chatdesk-prod.dialafrika.com/webchat/1/process';

  static Future<List<FaqModel>> fetchFaqs(String serviceValue) async {
    final Map<String, dynamic> requestPayload = {
      "route": "FAQS",
      "payload": {
        "service": serviceValue,
      },
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
        return data.map((item) => FaqModel.fromJson(item)).toList();
      }
    }

    return [];
  }
}
