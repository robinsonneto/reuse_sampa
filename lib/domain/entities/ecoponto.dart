import 'package:equatable/equatable.dart';

/// ID fixo do único Ecoponto do Projeto Piloto. Centralizado aqui para que,
/// no dia de uma expansão, toda referência a "o Ecoponto" vire uma consulta
/// por ID real em vez de uma constante — grep por [kBresserEcopontoId] no
/// projeto mostra exatamente todos os pontos que precisarão de atenção.
const String kBresserEcopontoId = 'bresser';

/// Horário de funcionamento de um dia da semana.
class WeekdayHours extends Equatable {
  final String weekday; // ex.: "Segunda a sexta"
  final String hours; // ex.: "07h às 18h" ou "Fechado"

  const WeekdayHours(this.weekday, this.hours);

  @override
  List<Object?> get props => [weekday, hours];
}

/// Um Ecoponto com espaço Reuse Sampa.
///
/// No piloto existe apenas um registro (`id == kBresserEcopontoId`), mas a
/// entidade já é genérica o suficiente para múltiplas unidades no futuro.
class EcoPonto extends Equatable {
  final String id;
  final String name;
  final String address;
  final String neighborhood;
  final double latitude;
  final double longitude;
  final String phone;
  final List<WeekdayHours> openingHours;
  final String? facadePhotoUrl;
  final List<String> spacePhotoUrls;
  final String aboutSpace;
  final int itemsAvailableCount;

  const EcoPonto({
    required this.id,
    required this.name,
    required this.address,
    required this.neighborhood,
    required this.latitude,
    required this.longitude,
    required this.phone,
    required this.openingHours,
    this.facadePhotoUrl,
    this.spacePhotoUrls = const [],
    this.aboutSpace = '',
    this.itemsAvailableCount = 0,
  });

  EcoPonto copyWith({
    String? name,
    String? address,
    String? neighborhood,
    double? latitude,
    double? longitude,
    String? phone,
    List<WeekdayHours>? openingHours,
    String? facadePhotoUrl,
    List<String>? spacePhotoUrls,
    String? aboutSpace,
    int? itemsAvailableCount,
  }) {
    return EcoPonto(
      id: id,
      name: name ?? this.name,
      address: address ?? this.address,
      neighborhood: neighborhood ?? this.neighborhood,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      phone: phone ?? this.phone,
      openingHours: openingHours ?? this.openingHours,
      facadePhotoUrl: facadePhotoUrl ?? this.facadePhotoUrl,
      spacePhotoUrls: spacePhotoUrls ?? this.spacePhotoUrls,
      aboutSpace: aboutSpace ?? this.aboutSpace,
      itemsAvailableCount: itemsAvailableCount ?? this.itemsAvailableCount,
    );
  }

  @override
  List<Object?> get props => [id, name, address, neighborhood, latitude, longitude, phone];
}
