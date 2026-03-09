import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = "http://localhost:8000/api/v1";

  Future<Map<String, dynamic>> fetchSearchResults(String query) async {
    try {
      final response = await http
          .post(
            Uri.parse("$_baseUrl/search"),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({"query": query}),
          )
          .timeout(const Duration(seconds: 15)); // 타임아웃 추가

      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes));
      } else {
        throw Exception("Server Error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Connection Failed: $e");
    }
  }
}
