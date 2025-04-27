class Class {
  final String id;
  final String name;
  final String description;

  Class({
    required this.id,
    required this.name,
    required this.description,
  });

  factory Class.fromJson(Map<String, dynamic> json) {
    return Class(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }
}
