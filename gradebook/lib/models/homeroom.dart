import 'student.dart';

class Homeroom {
  final String id;
  final String name;
  final int grade;
  final List<Student> students;
  final List<Teacher> teachers;

  Homeroom({
    required this.id,
    required this.name,
    required this.grade,
    required this.students,
    required this.teachers,
  });

  factory Homeroom.fromJson(Map<String, dynamic> json) {
    return Homeroom(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      grade: int.tryParse(json['grade']?.toString() ?? '0') ?? 0,
      students: (json['students'] as List?)
              ?.map((student) => Student.fromJson(student))
              .toList() ??
          [],
      teachers: (json['teachers'] as List?)
              ?.map((teacher) => Teacher.fromJson(teacher))
              .toList() ??
          [],
    );
  }
}

class Teacher {
  final String id;
  final String name;

  Teacher({
    required this.id,
    required this.name,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }
}
