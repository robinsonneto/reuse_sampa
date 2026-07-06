import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// As 9 categorias de materiais do Projeto Piloto Reuse Sampa (Ecoponto
/// Bresser). Escopo reduzido em relação à versão inicial (cidade toda) —
/// ver README, seção "Piloto Ecoponto Bresser".
enum ItemCategory {
  roupas,
  livros,
  brinquedos,
  moveis,
  utensiliosDomesticos,
  materiaisConstrucao,
  decoracao,
  ferramentas,
  outros,
}

extension ItemCategoryX on ItemCategory {
  /// Rótulo em português exibido na interface.
  String get label {
    switch (this) {
      case ItemCategory.roupas:
        return 'Roupas';
      case ItemCategory.livros:
        return 'Livros';
      case ItemCategory.brinquedos:
        return 'Brinquedos';
      case ItemCategory.moveis:
        return 'Móveis';
      case ItemCategory.utensiliosDomesticos:
        return 'Utensílios';
      case ItemCategory.materiaisConstrucao:
        return 'Materiais de construção';
      case ItemCategory.decoracao:
        return 'Objetos decorativos';
      case ItemCategory.ferramentas:
        return 'Ferramentas';
      case ItemCategory.outros:
        return 'Outros';
    }
  }

  /// Ícone Material representando a categoria (as versões finais de design
  /// podem trocar por um SVG customizado da marca em assets/icons/).
  IconData get icon {
    switch (this) {
      case ItemCategory.roupas:
        return Icons.checkroom_rounded;
      case ItemCategory.livros:
        return Icons.menu_book_rounded;
      case ItemCategory.brinquedos:
        return Icons.toys_rounded;
      case ItemCategory.moveis:
        return Icons.chair_rounded;
      case ItemCategory.utensiliosDomesticos:
        return Icons.kitchen_rounded;
      case ItemCategory.materiaisConstrucao:
        return Icons.foundation_rounded;
      case ItemCategory.decoracao:
        return Icons.image_rounded;
      case ItemCategory.ferramentas:
        return Icons.build_rounded;
      case ItemCategory.outros:
        return Icons.inventory_2_rounded;
    }
  }

  Color get color => AppColors.categoryPalette[index % AppColors.categoryPalette.length];

  /// Identificador estável usado no Firestore (nunca renomear — quebra dados
  /// já cadastrados). Se novas categorias forem criadas, adicionar ao final.
  ///
  /// Histórico: a versão piloto removeu `calcados`, `bolsas`,
  /// `materiais_hidraulicos` e `materiais_eletricos`, que existiam na
  /// concepção original (cidade toda). Os IDs ficam reservados — não
  /// reaproveitar para outra categoria caso o app volte a crescer.
  String get firestoreId {
    switch (this) {
      case ItemCategory.roupas:
        return 'roupas';
      case ItemCategory.livros:
        return 'livros';
      case ItemCategory.brinquedos:
        return 'brinquedos';
      case ItemCategory.moveis:
        return 'moveis';
      case ItemCategory.utensiliosDomesticos:
        return 'utensilios_domesticos';
      case ItemCategory.materiaisConstrucao:
        return 'materiais_construcao';
      case ItemCategory.decoracao:
        return 'decoracao';
      case ItemCategory.ferramentas:
        return 'ferramentas';
      case ItemCategory.outros:
        return 'outros';
    }
  }

  static ItemCategory fromFirestoreId(String id) {
    return ItemCategory.values.firstWhere(
      (c) => c.firestoreId == id,
      orElse: () => ItemCategory.outros,
    );
  }
}
