import '../core/constants/game_status.dart';

class GameModel {
  final String id;
  final String ownerId;
  final String ownerName;
  final String title;
  final String description;
  final String platform;
  final GameStatus status;
  final String? coverImageUrl;
  final DateTime addedDate;
  final List<TodoItem> todos;

  GameModel({
    required this.id,
    required this.ownerId,
    required this.ownerName,
    required this.title,
    required this.description,
    required this.platform,
    required this.status,
    this.coverImageUrl,
    required this.addedDate,
    this.todos = const [],
  });

  factory GameModel.fromJson(Map<String, dynamic> json) {
    return GameModel(
      id: json['id'] ?? '',
      ownerId: json['ownerId'] ?? '',
      ownerName: json['ownerName'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      platform: json['platform'] ?? '',
      status: GameStatus.values[json['status'] ?? 0],
      coverImageUrl: json['coverImageUrl'],
      addedDate: DateTime.parse(json['addedDate'] ?? DateTime.now().toIso8601String()),
      todos: (json['todos'] as List?)?.map((e) => TodoItem.fromJson(e)).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ownerId': ownerId,
      'ownerName': ownerName,
      'title': title,
      'description': description,
      'platform': platform,
      'status': status.index,
      'coverImageUrl': coverImageUrl,
      'addedDate': addedDate.toIso8601String(),
      'todos': todos.map((e) => e.toJson()).toList(),
    };
  }
}

class TodoItem {
  final String id;
  final String text;
  final bool isCompleted;

  TodoItem({
    required this.id,
    required this.text,
    this.isCompleted = false,
  });

  factory TodoItem.fromJson(Map<String, dynamic> json) {
    return TodoItem(
      id: json['id'] ?? '',
      text: json['text'] ?? '',
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'isCompleted': isCompleted,
    };
  }
}
