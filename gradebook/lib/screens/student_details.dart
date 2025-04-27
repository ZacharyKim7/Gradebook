import 'package:flutter/material.dart';
import '../models/student.dart';
import '../models/homeroom.dart';
import '../models/class.dart';
import '../services/class_service.dart';
import 'class_details.dart';

class StudentDetailsScreen extends StatefulWidget {
  final Student student;
  final Homeroom homeroom;

  const StudentDetailsScreen({
    super.key,
    required this.student,
    required this.homeroom,
  });

  @override
  State<StudentDetailsScreen> createState() => _StudentDetailsScreenState();
}

class _StudentDetailsScreenState extends State<StudentDetailsScreen>
    with SingleTickerProviderStateMixin {
  final ClassService _classService = ClassService();
  List<Class> _classes = [];
  List<Class> _enrolledClasses = [];
  Class? _selectedClass;
  bool _isLoading = true;
  String? _error;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _loadClasses();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadClasses() async {
    try {
      final classes = await _classService.getClasses();
      setState(() {
        _classes = classes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _enrollInClass() async {
    if (_selectedClass == null) return;

    try {
      await _classService.enrollStudent(_selectedClass!.id, widget.student.id);
      setState(() {
        _enrolledClasses.add(_selectedClass!);
        _classes.remove(_selectedClass);
        _selectedClass = null;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Student enrolled successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error enrolling student: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.student.name),
        actions: [
          MouseRegion(
            onEnter: (_) => _animationController.forward(),
            onExit: (_) => _animationController.reverse(),
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  // TODO: Implement delete functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Delete functionality coming soon!')),
                  );
                },
                tooltip: 'Delete Student',
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('Error: $_error'))
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Student Photo (Placeholder)
                        Center(
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            child: Text(
                              widget.student.name[0].toUpperCase(),
                              style: const TextStyle(
                                fontSize: 40,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Student Information',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 16),
                        _buildInfoRow('Name', widget.student.name),
                        _buildInfoRow(
                            'Grade Level', 'Grade ${widget.homeroom.grade}'),
                        _buildInfoRow('Homeroom', widget.homeroom.name),
                        const SizedBox(height: 24),
                        Text(
                          'Homeroom Teachers',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        ...widget.homeroom.teachers.map(
                          (teacher) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(teacher.name),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Enrolled Classes',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        ..._enrolledClasses.map(
                          (classData) => ListTile(
                            title: Text(classData.name),
                            subtitle: Text(classData.description),
                            trailing: IconButton(
                              icon: const Icon(Icons.info_outline),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ClassDetailsScreen(
                                        classData: classData),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Add to Class',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<Class>(
                                value: _selectedClass,
                                decoration: const InputDecoration(
                                  labelText: 'Select Class',
                                  border: OutlineInputBorder(),
                                ),
                                items: _classes.map((classData) {
                                  return DropdownMenuItem(
                                    value: classData,
                                    child: Text(classData.name),
                                  );
                                }).toList(),
                                onChanged: (Class? classData) {
                                  setState(() {
                                    _selectedClass = classData;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: _selectedClass != null
                                  ? _enrollInClass
                                  : null,
                              tooltip: 'Add to class',
                            ),
                          ],
                        ),
                      ],
                    ),
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
