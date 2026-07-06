import 'package:equatable/equatable.dart';
import '../../core/constants/item_category.dart';

/// Estado de conservação do item.
enum ItemCondition { novo, otimo, bom, regular }

extension ItemConditionX on ItemCondition {
  String get label {
    switch (this) {
      case ItemCondition.novo:
        return 'Novo';
      case ItemCondition.otimo:
        return 'Ótimo estado';
      case ItemCondition.bom:
        return 'Bom estado';
      case ItemCondition.regular:
        return 'Estado regular';
    }
  }
}

/// Status atual de disponibilidade do item.
///
/// Simplificado para o piloto: como não há reserva automática (ver
/// domain/entities/interest.dart), um item está apenas [disponivel] ou
/// [retirado] — a equipe do Ecoponto marca como retirado manualmente pelo
/// painel administrativo assim que alguém leva o item presencialmente.
enum ItemStatus { disponivel, retirado }

extension ItemStatusX on ItemStatus {
  String get label {
    switch (this) {
      case ItemStatus.disponivel:
        return 'Disponível';
      case ItemStatus.retirado:
        return 'Retirado';
    }
  }
}

/// Dimensões físicas do item (em centímetros), quando aplicável.
class ItemDimensions extends Equatable {
  final double? heightCm;
  final double? widthCm;
  final double? depthCm;

  const ItemDimensions({this.heightCm, this.widthCm, this.depthCm});

  bool get hasData => heightCm != null || widthCm != null || depthCm != null;

  String get formatted {
    if (!hasData) return '—';
    final h = heightCm?.toStringAsFixed(0) ?? '?';
    final w = widthCm?.toStringAsFixed(0) ?? '?';
    final d = depthCm?.toStringAsFixed(0) ?? '?';
    return '$w × $h × $d cm (L × A × P)';
  }

  @override
  List<Object?> get props => [heightCm, widthCm, depthCm];
}

/// Entidade principal: um material disponível para reuso.
///
/// --- Nota sobre `ecopontoId` (Projeto Piloto — Ecoponto Bresser) ---
/// Hoje existe um único Ecoponto (`kBressoEcopontoId` = 'bresser'), então a
/// interface nunca mostra seleção de unidade. Mesmo assim, todo item carrega
/// `ecopontoId` (em vez de fixar a lógica para um único local) para que uma
/// futura expansão para outras unidades não exija migrar dados nem
/// refatorar a árvore de widgets — apenas passar a variar esse valor e
/// exibir a escolha na UI. Por isso não denormalizamos mais o nome do
/// Ecoponto aqui: a tela resolve o nome consultando o Ecoponto atual (ver
/// presentation/providers/ecoponto_providers.dart).
class ReuseItem extends Equatable {
  final String id;
  final String name;
  final ItemCategory category;
  final String description;
  final ItemCondition condition;
  final ItemDimensions dimensions;
  final double? weightKg;
  final DateTime entryDate;
  final String ecopontoId;
  final int quantityAvailable;
  final ItemStatus status;
  final List<String> photoUrls;
  final int viewCount;
  final int favoriteCount;

  /// IDs dos usuários que registraram "Tenho interesse" neste item —
  /// espelha o campo `interessados` da coleção `produtos` no Firestore.
  /// Os registros completos (com data/hora de cada manifestação) vivem à
  /// parte, no repositório de interesses, para consulta administrativa.
  final List<String> interestedUserIds;

  const ReuseItem({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.condition,
    required this.dimensions,
    this.weightKg,
    required this.entryDate,
    required this.ecopontoId,
    required this.quantityAvailable,
    required this.status,
    required this.photoUrls,
    this.viewCount = 0,
    this.favoriteCount = 0,
    this.interestedUserIds = const [],
  });

  String get coverPhoto => photoUrls.isNotEmpty ? photoUrls.first : '';

  bool get isAvailable => status == ItemStatus.disponivel && quantityAvailable > 0;

  int get interestCount => interestedUserIds.length;

  bool hasInterestFrom(String userId) => interestedUserIds.contains(userId);

  ReuseItem copyWith({
    String? id,
    String? name,
    ItemCategory? category,
    String? description,
    ItemCondition? condition,
    ItemDimensions? dimensions,
    double? weightKg,
    DateTime? entryDate,
    String? ecopontoId,
    int? quantityAvailable,
    ItemStatus? status,
    List<String>? photoUrls,
    int? viewCount,
    int? favoriteCount,
    List<String>? interestedUserIds,
  }) {
    return ReuseItem(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      description: description ?? this.description,
      condition: condition ?? this.condition,
      dimensions: dimensions ?? this.dimensions,
      weightKg: weightKg ?? this.weightKg,
      entryDate: entryDate ?? this.entryDate,
      ecopontoId: ecopontoId ?? this.ecopontoId,
      quantityAvailable: quantityAvailable ?? this.quantityAvailable,
      status: status ?? this.status,
      photoUrls: photoUrls ?? this.photoUrls,
      viewCount: viewCount ?? this.viewCount,
      favoriteCount: favoriteCount ?? this.favoriteCount,
      interestedUserIds: interestedUserIds ?? this.interestedUserIds,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        category,
        description,
        condition,
        dimensions,
        weightKg,
        entryDate,
        ecopontoId,
        quantityAvailable,
        status,
        photoUrls,
        viewCount,
        favoriteCount,
        interestedUserIds,
      ];
}
