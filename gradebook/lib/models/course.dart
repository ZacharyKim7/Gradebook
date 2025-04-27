class Course {
  final String id;
  final String name;
  final String subject;
  final String description;
  final String teacherId;
  final int gradeLevel;

  Course({
    required this.id,
    required this.name,
    required this.subject,
    required this.description,
    required this.teacherId,
    required this.gradeLevel,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      subject: json['subject']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      teacherId: json['teacherId']?.toString() ?? '',
      gradeLevel: int.tryParse(json['gradeLevel']?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'subject': subject,
      'description': description,
      'teacherId': teacherId,
      'gradeLevel': gradeLevel,
    };
  }
}
