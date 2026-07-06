import 'package:equatable/equatable.dart';

enum NotificationType { novoItem, categoriaFavorita, interesseConfirmado, geral }

class AppNotification extends Equatable {
  final String id;
  final NotificationType type;
  final String title;
  final String body;
  final DateTime createdAt;
  final bool read;
  final String? relatedItemId;

  const AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.createdAt,
    this.read = false,
    this.relatedItemId,
  });

  @override
  List<Object?> get props => [id, type, title, body, createdAt, read];
}
