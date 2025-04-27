class Grade {
  final String id;
  final String studentId;
  final String assignmentId;
  final int score;
  final DateTime date;
  final bool isRetake;
  final String? notes;

  Grade({
    required this.id,
    required this.studentId,
    required this.assignmentId,
    required this.score,
    required this.date,
    this.isRetake = false,
    this.notes,
  });

  factory Grade.fromJson(Map<String, dynamic> json) {
    return Grade(
      id: json['id'],
      studentId: json['studentId'],
      assignmentId: json['assignmentId'],
      score: json['score'],
      date: DateTime.parse(json['date']),
      isRetake: json['isRetake'] ?? false,
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'assignmentId': assignmentId,
      'score': score,
      'date': date.toIso8601String(),
      'isRetake': isRetake,
      'notes': notes,
    };
  }
}
