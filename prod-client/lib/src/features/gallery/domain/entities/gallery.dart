import 'package:equatable/equatable.dart';

class Gallery extends Equatable {
  final String id;
  final String name;
  final String iconUrl;
  final String description;
  final String userId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Gallery({
    required this.id,
    required this.name,
    required this.iconUrl,
    required this.description,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  Gallery.empty()
      : this(
          id: '1',
          name: '_empty.name',
          iconUrl: '_empty.iconUrl',
          description: '_empty.description',
          userId: '_empty.userId',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

  @override
  List<Object?> get props => [id, name];
}
