import 'package:flutter/material.dart';
import '../models/student.dart';
import '../models/homeroom.dart';
import '../services/student_service.dart';
import 'student_details.dart';

class StudentsDashboard extends StatefulWidget {
  const StudentsDashboard({super.key});

  @override
  State<StudentsDashboard> createState() => _StudentsDashboardState();
}

class _StudentsDashboardState extends State<StudentsDashboard> {
  final StudentService _studentService = StudentService();
  List<Homeroom> _homerooms = [];
  bool _isLoading = true;
  String? _error;
  bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
    _loadHomerooms();
  }

  Future<void> _loadHomerooms() async {
    try {
      final homerooms = await _studentService.getHomerooms();
      setState(() {
        _homerooms = homerooms;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  List<Student> _getAllStudents() {
    return _homerooms.expand((homeroom) => homeroom.students).toList();
  }

  void _sortStudents() {
    setState(() {
      _sortAscending = !_sortAscending;
      for (var homeroom in _homerooms) {
        homeroom.students.sort((a, b) {
          final lastNameA = a.name.split(' ').last;
          final lastNameB = b.name.split(' ').last;
          return _sortAscending
              ? lastNameA.compareTo(lastNameB)
              : lastNameB.compareTo(lastNameA);
        });
      }
    });
  }

  Future<void> _deleteStudent(Student student) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Student'),
        content: Text('Are you sure you want to delete ${student.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _studentService.deleteStudent(student.id);
        setState(() {
          for (var homeroom in _homerooms) {
            homeroom.students.removeWhere((s) => s.id == student.id);
          }
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Student deleted successfully')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error deleting student: $e')),
          );
        }
      }
    }
  }

  int _getStudentGrade(String homeroomId) {
    final homeroom = _homerooms.firstWhere(
      (h) => h.id == homeroomId,
      orElse: () => Homeroom(
        id: '',
        name: '',
        grade: 0,
        students: [],
        teachers: [],
      ),
    );
    return homeroom.grade;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Students'),
        actions: [
          IconButton(
            icon: Icon(
                _sortAscending ? Icons.arrow_upward : Icons.arrow_downward),
            onPressed: _sortStudents,
            tooltip: 'Sort by last name',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('Error: $_error'))
              : ListView.builder(
                  itemCount: _homerooms.expand((h) => h.students).length,
                  itemBuilder: (context, index) {
                    final student = _getAllStudents()[index];
                    final grade = _getStudentGrade(student.homeroomId);
                    return MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: ListTile(
                        title: Text(
                          student.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text('Grade $grade'),
                        onTap: () {
                          final homeroom = _homerooms.firstWhere(
                            (h) => h.id == student.homeroomId,
                            orElse: () => Homeroom(
                              id: '',
                              name: '',
                              grade: 0,
                              students: [],
                              teachers: [],
                            ),
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StudentDetailsScreen(
                                student: student,
                                homeroom: homeroom,
                              ),
                            ),
                          );
                        },
                        trailing: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _deleteStudent(student),
                            tooltip: 'Delete student',
                            iconSize: 24,
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
