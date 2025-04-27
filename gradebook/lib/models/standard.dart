class Standard {
  final String id;
  final String subject;
  final String code;
  final String description;
  final int gradeLevel;

  Standard({
    required this.id,
    required this.subject,
    required this.code,
    required this.description,
    required this.gradeLevel,
  });

  factory Standard.fromJson(Map<String, dynamic> json) {
    return Standard(
      id: json['id'],
      subject: json['subject'],
      code: json['code'],
      description: json['description'],
      gradeLevel: json['gradeLevel'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subject': subject,
      'code': code,
      'description': description,
      'gradeLevel': gradeLevel,
    };
  }
}
