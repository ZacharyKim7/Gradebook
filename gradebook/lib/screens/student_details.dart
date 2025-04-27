import 'package:flutter/material.dart';
import '../models/student.dart';
import '../models/homeroom.dart';

class StudentDetailsScreen extends StatelessWidget {
  final Student student;
  final Homeroom homeroom;

  const StudentDetailsScreen({
    super.key,
    required this.student,
    required this.homeroom,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(student.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Student Information',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Name', student.name),
            _buildInfoRow('Grade Level', 'Grade ${homeroom.grade}'),
            _buildInfoRow('Homeroom', homeroom.name),
            const SizedBox(height: 24),
            Text(
              'Homeroom Teachers',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            ...homeroom.teachers.map(
              (teacher) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(teacher.name),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
