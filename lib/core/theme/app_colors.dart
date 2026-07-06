import 'package:flutter/material.dart';

/// Paleta oficial da marca Reuse Sampa.
///
/// Os tons abaixo foram extraídos diretamente do quadro de identidade visual
/// fornecido (logo + guia de marca). Eles são muito próximos dos hexadecimais
/// citados no briefing em texto — usamos aqui os valores do quadro por serem
/// a fonte mais precisa (inclui também o cinza-quase-preto usado em textos).
class AppColors {
  AppColors._();

  // --- Cores de marca ---
  static const Color darkGreen = Color(0xFF2E5E3E); // verde escuro (primária)
  static const Color mediumGreen = Color(0xFF67A65B); // verde médio (secundária)
  static const Color lightGreen = Color(0xFFA3C16E); // verde claro (apoio)
  static const Color orange = Color(0xFFE07A3F); // laranja (destaque/CTA)
  static const Color beige = Color(0xFFF2E9D8); // bege (fundo)
  static const Color charcoal = Color(0xFF333333); // texto principal

  // --- Neutros derivados (para superfícies, bordas, estados) ---
  static const Color white = Color(0xFFFFFFFF);
  static const Color beigeSoft = Color(0xFFFAF7F1); // bege mais claro, para cards
  static const Color beigeDark = Color(0xFFE7DCC7); // bege para bordas/divisores
  static const Color greyText = Color(0xFF6B6B63); // texto secundário sobre bege
  static const Color greyBorder = Color(0xFFDAD3C4);

  // --- Estados semânticos ---
  static const Color success = mediumGreen;
  static const Color warning = orange;
  static const Color error = Color(0xFFC0463A);
  static const Color info = Color(0xFF3B7EA8);

  // Status de item
  static const Color statusAvailable = mediumGreen;
  static const Color statusTaken = Color(0xFF9B9488);

  // --- Modo escuro ---
  static const Color darkBackground = Color(0xFF14231A);
  static const Color darkSurface = Color(0xFF1C3226);
  static const Color darkSurfaceAlt = Color(0xFF223A2B);
  static const Color darkBorder = Color(0xFF2E4A38);
  static const Color darkTextPrimary = Color(0xFFF2E9D8);
  static const Color darkTextSecondary = Color(0xFFBFC7BC);

  // --- Gradientes de apoio (banners, hero) ---
  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [darkGreen, mediumGreen],
  );

  static const LinearGradient orangeGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFE07A3F), Color(0xFFF0A868)],
  );

  /// Cor por categoria — usada em ícones/tags para dar identidade visual
  /// a cada tipo de material sem fugir da paleta da marca.
  static const List<Color> categoryPalette = [
    darkGreen,
    mediumGreen,
    lightGreen,
    orange,
    Color(0xFF7A9E99),
    Color(0xFFB08968),
  ];
}
