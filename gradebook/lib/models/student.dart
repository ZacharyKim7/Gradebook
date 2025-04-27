class Student {
  final String id;
  final String name;
  final String homeroomId;

  Student({
    required this.id,
    required this.name,
    required this.homeroomId,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      homeroomId: json['homeroom']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'homeroom': homeroomId,
    };
  }
}
