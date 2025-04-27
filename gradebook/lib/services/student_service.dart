import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/student.dart';
import '../models/homeroom.dart';

class StudentService {
  static const String baseUrl = 'https://gradebook-api-cyan.vercel.app/api';

  Future<List<Homeroom>> getHomerooms() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/homerooms'));
      // print('API Response: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // print('Decoded Data: $data');

        if (data['homerooms'] == null) {
          return [];
        }

        return (data['homerooms'] as List).map((homeroom) {
          // print('Processing homeroom: $homeroom');
          return Homeroom.fromJson(homeroom);
        }).toList();
      } else {
        throw Exception('Failed to load homerooms');
      }
    } catch (e) {
      // print('Error in getHomerooms: $e');
      throw Exception('Error fetching homerooms: $e');
    }
  }

  Future<void> deleteStudent(String studentId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/students/$studentId'),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete student');
      }
    } catch (e) {
      throw Exception('Error deleting student: $e');
    }
  }
}
