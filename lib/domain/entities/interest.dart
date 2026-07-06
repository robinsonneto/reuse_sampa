import 'package:equatable/equatable.dart';

/// Registro de "Tenho interesse" em um item.
///
/// Piloto Ecoponto Bresser: NÃO há reserva automática nem prazo de
/// retirada. Este registro serve apenas para fins estatísticos e para a
/// equipe do Ecoponto consultar, no painel administrativo, quem demonstrou
/// interesse em cada item (seção "Consultar interessados"). A retirada em
/// si acontece presencialmente, por ordem de chegada.
class Interest extends Equatable {
  final String id;
  final String itemId;
  final String itemName;
  final String userId;
  final String userName;
  final String ecopontoId;
  final DateTime createdAt;

  const Interest({
    required this.id,
    required this.itemId,
    required this.itemName,
    required this.userId,
    required this.userName,
    required this.ecopontoId,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, itemId, userId, ecopontoId, createdAt];
}
