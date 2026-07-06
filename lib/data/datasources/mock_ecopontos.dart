import '../../domain/entities/ecoponto.dart';

/// Dado fictício do único Ecoponto do Projeto Piloto, para desenvolvimento e
/// prototipagem visual.
///
/// IMPORTANTE: endereço, telefone e coordenadas são exemplos ilustrativos e
/// devem ser substituídos pelos dados reais do Ecoponto Bresser antes da
/// publicação.
final EcoPonto mockEcopontoBresser = EcoPonto(
  id: kBresserEcopontoId,
  name: 'Ecoponto Bresser',
  address: 'Rua Bresser, 1500 — Brás',
  neighborhood: 'Brás',
  latitude: -23.5540,
  longitude: -46.5980,
  phone: '(11) 2222-3344',
  openingHours: const [
    WeekdayHours('Segunda a sábado', '07h às 18h'),
    WeekdayHours('Domingo', 'Fechado'),
  ],
  facadePhotoUrl: 'https://picsum.photos/seed/ecopontobresserfachada/1200/800',
  spacePhotoUrls: [
    'https://picsum.photos/seed/reusesampaespaco1/900/700',
    'https://picsum.photos/seed/reusesampaespaco2/900/700',
    'https://picsum.photos/seed/reusesampaespaco3/900/700',
  ],
  aboutSpace:
      'O espaço Reuse Sampa dentro do Ecoponto Bresser reúne, organiza por '
      'categoria e disponibiliza gratuitamente materiais em bom estado que '
      'chegam até o Ecoponto — evitando que sigam para o aterro sanitário e '
      'dando a eles uma nova oportunidade de uso.',
  itemsAvailableCount: 0, // recalculado dinamicamente a partir dos itens
);

/// Mantido como lista para que os providers que já esperam `List<EcoPonto>`
/// (ex.: telas administrativas) continuem funcionando sem alterações,
/// mesmo com uma única unidade cadastrada.
final List<EcoPonto> mockEcopontos = [mockEcopontoBresser];
