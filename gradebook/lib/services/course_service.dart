import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/course.dart';

class CourseService {
  static const String baseUrl = 'https://gradebook-api-cyan.vercel.app/api';

  Future<List<Course>> getCourses() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/courses'));
      print('API Response: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Decoded Data: $data');

        if (data['courses'] == null) {
          return [];
        }

        return (data['courses'] as List).map((course) {
          print('Processing course: $course');
          return Course.fromJson(course);
        }).toList();
      } else {
        throw Exception('Failed to load courses');
      }
    } catch (e) {
      print('Error in getCourses: $e');
      throw Exception('Error fetching courses: $e');
    }
  }

  Future<void> enrollStudent(String courseId, String studentId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/courses/$courseId/enroll'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'studentId': studentId}),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to enroll student');
      }
    } catch (e) {
      throw Exception('Error enrolling student: $e');
    }
  }
}
