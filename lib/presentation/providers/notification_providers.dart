import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/mock_notifications.dart';
import '../../domain/entities/app_notification.dart';

/// Em produção, migrar para Firestore (`users/{uid}/notifications`),
/// populada por Cloud Functions disparadas nos eventos de:
/// * criação de item (gatilho: onCreate em `items`)
/// * item criado em categoria que o usuário segue
/// * job agendado que varre reservas a poucos minutos de expirar
class NotificationsNotifier extends StateNotifier<List<AppNotification>> {
  NotificationsNotifier() : super(List.of(mockNotifications));

  void markAllRead() {
    state = [for (final n in state) AppNotification(
      id: n.id, type: n.type, title: n.title, body: n.body,
      createdAt: n.createdAt, read: true, relatedItemId: n.relatedItemId,
    )];
  }
}

final notificationsProvider =
    StateNotifierProvider<NotificationsNotifier, List<AppNotification>>((ref) {
  return NotificationsNotifier();
});

final unreadNotificationsCountProvider = Provider<int>((ref) {
  return ref.watch(notificationsProvider).where((n) => !n.read).length;
});
