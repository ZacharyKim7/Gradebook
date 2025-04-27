import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/class.dart';

class ClassService {
  static const String baseUrl = 'https://gradebook-api-cyan.vercel.app/api';

  Future<List<Class>> getClasses() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/classes'));
      print('API Response: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Decoded Data: $data');

        if (data['classes'] == null) {
          return [];
        }

        return (data['classes'] as List).map((classData) {
          print('Processing class: $classData');
          return Class.fromJson(classData);
        }).toList();
      } else {
        throw Exception('Failed to load classes');
      }
    } catch (e) {
      print('Error in getClasses: $e');
      throw Exception('Error fetching classes: $e');
    }
  }

  Future<Class> getClassById(String classId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/classes/$classId'));
      print('API Response: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Class.fromJson(data);
      } else {
        throw Exception('Failed to load class');
      }
    } catch (e) {
      print('Error in getClassById: $e');
      throw Exception('Error fetching class: $e');
    }
  }

  Future<void> enrollStudent(String classId, String studentId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/classes/$classId/students'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'studentId': studentId}),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to enroll student: ${response.body}');
      }
    } catch (e) {
      print('Error in enrollStudent: $e');
      throw Exception('Error enrolling student: $e');
    }
  }
}
