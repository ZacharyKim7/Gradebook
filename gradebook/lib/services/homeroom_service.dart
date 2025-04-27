import 'dart:convert';
import 'package:http/http.dart' as http;

class HomeroomService {
  static const String baseUrl = 'https://gradebook-api-cyan.vercel.app/api';

  Future<List<dynamic>> getHomerooms() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/homerooms'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['homerooms'];
      } else {
        throw Exception('Failed to load homerooms');
      }
    } catch (e) {
      throw Exception('Error fetching homerooms: $e');
    }
  }
}
