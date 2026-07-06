import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Sistema tipográfico do Reuse Sampa.
///
/// Poppins (geométrica, arredondada, amigável) para títulos e elementos de
/// destaque — transmite modernidade e acolhimento. Inter para corpo de texto
/// — alta legibilidade em telas pequenas e em textos longos (descrições de
/// itens, instruções). Essa dupla evita a "cara de template" de usar uma
/// única família para tudo e reforça a identidade "moderna + acolhedora"
/// pedida no briefing.
class AppTextStyles {
  AppTextStyles._();

  static TextStyle get _display => GoogleFonts.poppins();
  static TextStyle get _body => GoogleFonts.inter();

  // --- Display / Headlines ---
  static TextStyle get displayLarge => _display.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 1.15,
        letterSpacing: -0.5,
        color: AppColors.charcoal,
      );

  static TextStyle get displayMedium => _display.copyWith(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        height: 1.2,
        letterSpacing: -0.3,
        color: AppColors.charcoal,
      );

  static TextStyle get headlineLarge => _display.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        height: 1.25,
        color: AppColors.charcoal,
      );

  static TextStyle get headlineMedium => _display.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.3,
        color: AppColors.charcoal,
      );

  static TextStyle get titleMedium => _display.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.3,
        color: AppColors.charcoal,
      );

  // --- Corpo ---
  static TextStyle get bodyLarge => _body.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: AppColors.charcoal,
      );

  static TextStyle get bodyMedium => _body.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: AppColors.charcoal,
      );

  static TextStyle get bodySmall => _body.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.4,
        color: AppColors.greyText,
      );

  // --- Utilitário ---
  static TextStyle get label => _body.copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        height: 1.3,
        letterSpacing: 0.2,
        color: AppColors.charcoal,
      );

  static TextStyle get caption => _body.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        height: 1.3,
        letterSpacing: 0.3,
        color: AppColors.greyText,
      );

  static TextStyle get button => _display.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
      );

  static TextStyle get overline => _body.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.1,
        color: AppColors.mediumGreen,
      );
}
