import 'package:flutter/material.dart';
import 'screens/students_dashboard.dart';
import 'services/homeroom_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gradebook',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const StudentsDashboard(),
    );
  }
}

class HomeroomListPage extends StatefulWidget {
  const HomeroomListPage({super.key});

  @override
  State<HomeroomListPage> createState() => _HomeroomListPageState();
}

class _HomeroomListPageState extends State<HomeroomListPage> {
  final HomeroomService _homeroomService = HomeroomService();
  List<dynamic> _homerooms = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadHomerooms();
  }

  Future<void> _loadHomerooms() async {
    try {
      final homerooms = await _homeroomService.getHomerooms();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Homerooms'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('Error: $_error'))
              : ListView.builder(
                  itemCount: _homerooms.length,
                  itemBuilder: (context, index) {
                    final homeroom = _homerooms[index];
                    return ListTile(
                      title: Text(homeroom['name']),
                      subtitle: Text('Grade ${homeroom['grade']}'),
                      trailing: Text('${homeroom['students'].length} students'),
                    );
                  },
                ),
    );
  }
}
