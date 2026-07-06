import '../../core/constants/item_category.dart';
import '../../domain/entities/ecoponto.dart';
import '../../domain/entities/reuse_item.dart';

/// Dados fictícios de itens do Ecoponto Bresser, para desenvolvimento e
/// prototipagem visual.
///
/// As fotos usam um serviço de placeholder (picsum.photos) apenas para que
/// as telas fiquem visualmente completas durante o desenvolvimento. Na
/// implementação real, `photoUrls` deve apontar para arquivos no Firebase
/// Storage (bucket `produtos/{itemId}/{n}.jpg`), enviados pelo painel
/// administrativo.
List<String> _photos(String seed, int count) =>
    List.generate(count, (i) => 'https://picsum.photos/seed/$seed$i/900/900');

final DateTime _now = DateTime.now();

final List<ReuseItem> mockItems = [
  ReuseItem(
    id: 'item_001',
    name: 'Estante de livros em madeira maciça',
    category: ItemCategory.moveis,
    description:
        'Estante de 5 prateleiras em madeira de demolição, ideal para sala ou '
        'home office. Pequenos sinais de uso, estrutura firme e sem cupim.',
    condition: ItemCondition.bom,
    dimensions: const ItemDimensions(heightCm: 180, widthCm: 90, depthCm: 30),
    weightKg: 22,
    entryDate: _now.subtract(const Duration(days: 1)),
    ecopontoId: kBresserEcopontoId,
    quantityAvailable: 1,
    status: ItemStatus.disponivel,
    photoUrls: _photos('estante', 4),
    viewCount: 132,
    favoriteCount: 18,
    interestedUserIds: const ['user_google_demo', 'user_email_demo'],
  ),
  ReuseItem(
    id: 'item_002',
    name: 'Caixa com 15 livros infantis',
    category: ItemCategory.livros,
    description:
        'Coleção variada de livros infantis ilustrados, para crianças de 3 a 8 '
        'anos. Capas em bom estado, ótimos para escolas e bibliotecas '
        'comunitárias.',
    condition: ItemCondition.bom,
    dimensions: const ItemDimensions(),
    weightKg: 4.5,
    entryDate: _now.subtract(const Duration(hours: 5)),
    ecopontoId: kBresserEcopontoId,
    quantityAvailable: 1,
    status: ItemStatus.disponivel,
    photoUrls: _photos('livros', 3),
    viewCount: 88,
    favoriteCount: 12,
  ),
  ReuseItem(
    id: 'item_003',
    name: 'Bicicleta infantil aro 16',
    category: ItemCategory.brinquedos,
    description:
        'Bicicleta aro 16 com rodinhas de apoio, para crianças de 4 a 6 anos. '
        'Pneus calibrados, freios revisados na triagem do Ecoponto.',
    condition: ItemCondition.otimo,
    dimensions: const ItemDimensions(heightCm: 70, widthCm: 45, depthCm: 100),
    weightKg: 8,
    entryDate: _now.subtract(const Duration(days: 2)),
    ecopontoId: kBresserEcopontoId,
    quantityAvailable: 1,
    status: ItemStatus.disponivel,
    photoUrls: _photos('bike', 5),
    viewCount: 210,
    favoriteCount: 41,
    interestedUserIds: const ['user_google_demo', 'user_apple_demo', 'user_email_demo'],
  ),
  ReuseItem(
    id: 'item_004',
    name: 'Kit de panelas antiaderentes (5 peças)',
    category: ItemCategory.utensiliosDomesticos,
    description:
        'Jogo de panelas com cabos de baquelite, sem amassados, aderência '
        'ainda boa. Inclui frigideira, caçarola média e panela de pressão.',
    condition: ItemCondition.bom,
    dimensions: const ItemDimensions(),
    weightKg: 3.2,
    entryDate: _now.subtract(const Duration(hours: 20)),
    ecopontoId: kBresserEcopontoId,
    quantityAvailable: 1,
    status: ItemStatus.disponivel,
    photoUrls: _photos('panelas', 3),
    viewCount: 64,
    favoriteCount: 9,
  ),
  ReuseItem(
    id: 'item_005',
    name: 'Casaco de inverno unissex, tam. M',
    category: ItemCategory.roupas,
    description:
        'Casaco acolchoado, forro térmico, zíper funcionando perfeitamente. '
        'Lavado e higienizado antes da doação.',
    condition: ItemCondition.otimo,
    dimensions: const ItemDimensions(),
    weightKg: 0.8,
    entryDate: _now.subtract(const Duration(hours: 3)),
    ecopontoId: kBresserEcopontoId,
    quantityAvailable: 2,
    status: ItemStatus.disponivel,
    photoUrls: _photos('casaco', 4),
    viewCount: 156,
    favoriteCount: 27,
    interestedUserIds: const ['user_email_demo'],
  ),
  ReuseItem(
    id: 'item_006',
    name: 'Furadeira elétrica 500W',
    category: ItemCategory.ferramentas,
    description:
        'Furadeira de impacto, testada e funcionando. Acompanha 3 brocas. '
        'Ideal para pequenos reparos domésticos.',
    condition: ItemCondition.bom,
    dimensions: const ItemDimensions(),
    weightKg: 1.6,
    entryDate: _now.subtract(const Duration(days: 3)),
    ecopontoId: kBresserEcopontoId,
    quantityAvailable: 1,
    status: ItemStatus.disponivel,
    photoUrls: _photos('furadeira', 3),
    viewCount: 97,
    favoriteCount: 15,
  ),
  ReuseItem(
    id: 'item_007',
    name: 'Luminária de piso articulada',
    category: ItemCategory.decoracao,
    description: 'Luminária de piso com haste articulada, cúpula em tecido bege, fiação revisada.',
    condition: ItemCondition.otimo,
    dimensions: const ItemDimensions(heightCm: 150, widthCm: 35, depthCm: 35),
    weightKg: 3.5,
    entryDate: _now.subtract(const Duration(hours: 30)),
    ecopontoId: kBresserEcopontoId,
    quantityAvailable: 1,
    status: ItemStatus.disponivel,
    photoUrls: _photos('luminaria', 4),
    viewCount: 121,
    favoriteCount: 22,
  ),
  ReuseItem(
    id: 'item_008',
    name: 'Tijolos ecológicos (lote de 40)',
    category: ItemCategory.materiaisConstrucao,
    description: 'Sobra de obra, tijolos ecológicos intactos, empilhados e prontos para retirada.',
    condition: ItemCondition.bom,
    dimensions: const ItemDimensions(),
    weightKg: 120,
    entryDate: _now.subtract(const Duration(days: 6)),
    ecopontoId: kBresserEcopontoId,
    quantityAvailable: 40,
    status: ItemStatus.disponivel,
    photoUrls: _photos('tijolos', 2),
    viewCount: 29,
    favoriteCount: 2,
  ),
  ReuseItem(
    id: 'item_009',
    name: 'Quebra-cabeça de madeira 500 peças',
    category: ItemCategory.brinquedos,
    description: 'Jogo completo, conferido peça a peça pela equipe do Ecoponto.',
    condition: ItemCondition.otimo,
    dimensions: const ItemDimensions(),
    weightKg: 1.1,
    entryDate: _now.subtract(const Duration(hours: 14)),
    ecopontoId: kBresserEcopontoId,
    quantityAvailable: 1,
    status: ItemStatus.disponivel,
    photoUrls: _photos('quebracabeca', 3),
    viewCount: 52,
    favoriteCount: 7,
  ),
  ReuseItem(
    id: 'item_010',
    name: 'Sofá de 2 lugares, tecido cinza',
    category: ItemCategory.moveis,
    description:
        'Sofá retrátil, estofado em bom estado, sem manchas visíveis. Estrutura '
        'de madeira firme. Necessário 2 pessoas para o transporte.',
    condition: ItemCondition.regular,
    dimensions: const ItemDimensions(heightCm: 85, widthCm: 150, depthCm: 90),
    weightKg: 35,
    entryDate: _now.subtract(const Duration(days: 1, hours: 6)),
    ecopontoId: kBresserEcopontoId,
    quantityAvailable: 1,
    status: ItemStatus.disponivel,
    photoUrls: _photos('sofa', 5),
    viewCount: 189,
    favoriteCount: 33,
    interestedUserIds: const ['user_google_demo'],
  ),
  ReuseItem(
    id: 'item_011',
    name: 'Caixa organizadora com miudezas',
    category: ItemCategory.outros,
    description: 'Diversos itens úteis: ganchos, prendedores, pequenas ferramentas de escritório.',
    condition: ItemCondition.bom,
    dimensions: const ItemDimensions(),
    weightKg: 2,
    entryDate: _now.subtract(const Duration(hours: 40)),
    ecopontoId: kBresserEcopontoId,
    quantityAvailable: 1,
    status: ItemStatus.disponivel,
    photoUrls: _photos('miudezas', 2),
    viewCount: 21,
    favoriteCount: 1,
  ),
  ReuseItem(
    id: 'item_012',
    name: 'Cabos e fiação elétrica variados',
    category: ItemCategory.outros,
    description: 'Rolos de fio 2,5mm e 4mm, sobras de instalação. Ideal para pequenos reparos.',
    condition: ItemCondition.bom,
    dimensions: const ItemDimensions(),
    weightKg: 5,
    entryDate: _now.subtract(const Duration(days: 5)),
    ecopontoId: kBresserEcopontoId,
    quantityAvailable: 1,
    status: ItemStatus.retirado,
    photoUrls: _photos('cabos', 2),
    viewCount: 45,
    favoriteCount: 3,
  ),
];
