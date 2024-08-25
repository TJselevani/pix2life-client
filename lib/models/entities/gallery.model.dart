class Gallery {
  final String id;
  final String name;
  final String iconUrl;
  final String description;
  final String userId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Gallery({
    required this.id,
    required this.name,
    required this.iconUrl,
    required this.description,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Gallery.fromJson(Map<String, dynamic> json) {
    return Gallery(
      id: json['id'],
      name: json['name'],
      iconUrl: json['iconUrl'] ?? '',
      description: json['description'] ?? '',
      userId: json['userId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}