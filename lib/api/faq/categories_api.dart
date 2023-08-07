import 'dart:convert';

import '../../models/faq/category.dart';
import 'package:http/http.dart' as http;

class CategoriesApi {
  static const String apiUrl = 'https://chatdesk-prod.dialafrika.com/webchat/1/process'; // Replace with your API endpoint

  static Future<List<Categories>> fetchCategories() async {
    final Map<String, dynamic> requestPayload = {
      "route": "CATEGORIES",
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
        return data.map((item) => Categories.fromJson(item)).toList();
      }
    }

    return [];
  }
}