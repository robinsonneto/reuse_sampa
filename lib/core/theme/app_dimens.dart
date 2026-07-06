/// Tokens de espaçamento e forma. Usar sempre estes valores em vez de
/// números "mágicos" mantém a consistência visual (bastante espaço em
/// branco, cantos suaves, hierarquia clara) pedida no briefing.
class AppSpacing {
  AppSpacing._();

  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
  static const double xxxl = 64;

  /// Margem horizontal padrão das telas.
  static const double screenPadding = 20;
}

class AppRadius {
  AppRadius._();

  static const double sm = 8;
  static const double md = 14;
  static const double lg = 20;
  static const double xl = 28;
  static const double pill = 999;
}

class AppDurations {
  AppDurations._();

  static const heroTransition = Duration(milliseconds: 400);
  static const fast = Duration(milliseconds: 180);
  static const medium = Duration(milliseconds: 320);
  static const bannerAutoplay = Duration(seconds: 5);
}
