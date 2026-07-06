import '../../domain/entities/app_notification.dart';

final DateTime _now = DateTime.now();

/// Notificações fictícias representando os gatilhos do piloto: novo item
/// cadastrado, novidade em categoria favorita e confirmação de interesse
/// registrado.
final List<AppNotification> mockNotifications = [
  AppNotification(
    id: 'notif_1',
    type: NotificationType.interesseConfirmado,
    title: 'Interesse registrado!',
    body: 'Seu interesse em "Bicicleta infantil aro 16" foi registrado. A retirada é por ordem '
        'de chegada no Ecoponto Bresser.',
    createdAt: _now.subtract(const Duration(minutes: 20)),
  ),
  AppNotification(
    id: 'notif_2',
    type: NotificationType.categoriaFavorita,
    title: 'Novidades em Móveis',
    body: 'Chegaram 3 novos itens na categoria Móveis que você segue.',
    createdAt: _now.subtract(const Duration(hours: 3)),
  ),
  AppNotification(
    id: 'notif_3',
    type: NotificationType.novoItem,
    title: 'Novo item disponível',
    body: '"Estante de livros em madeira maciça" acabou de ser cadastrada no Ecoponto Bresser.',
    createdAt: _now.subtract(const Duration(hours: 20)),
    read: true,
  ),
  AppNotification(
    id: 'notif_4',
    type: NotificationType.geral,
    title: 'Bem-vindo(a) ao Reuse Sampa!',
    body: 'Explore os itens disponíveis nos Ecopontos da cidade e dê uma nova vida a eles.',
    createdAt: _now.subtract(const Duration(days: 3)),
    read: true,
  ),
];
