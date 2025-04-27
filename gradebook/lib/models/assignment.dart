class Assignment {
  final String id;
  final String name;
  final String standardId;
  final DateTime dueDate;
  final String description;
  final int maxScore;

  Assignment({
    required this.id,
    required this.name,
    required this.standardId,
    required this.dueDate,
    required this.description,
    this.maxScore = 4,
  });

  factory Assignment.fromJson(Map<String, dynamic> json) {
    return Assignment(
      id: json['id'],
      name: json['name'],
      standardId: json['standardId'],
      dueDate: DateTime.parse(json['dueDate']),
      description: json['description'],
      maxScore: json['maxScore'] ?? 4,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'standardId': standardId,
      'dueDate': dueDate.toIso8601String(),
      'description': description,
      'maxScore': maxScore,
    };
  }
}
