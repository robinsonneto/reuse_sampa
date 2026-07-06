/// Formata uma data como tempo relativo em português — usado nos cards de
/// item para mostrar "há quanto tempo" o material entrou no catálogo, sem
/// depender de pacotes extras de i18n para um formato tão simples.
String timeAgo(DateTime date) {
  final diff = DateTime.now().difference(date);

  if (diff.inMinutes < 1) return 'agora mesmo';
  if (diff.inMinutes < 60) return 'há ${diff.inMinutes} min';
  if (diff.inHours < 24) return 'há ${diff.inHours} h';
  if (diff.inDays == 1) return 'há 1 dia';
  if (diff.inDays < 7) return 'há ${diff.inDays} dias';
  if (diff.inDays < 30) return 'há ${(diff.inDays / 7).floor()} semana(s)';
  return 'há ${(diff.inDays / 30).floor()} mês(es)';
}
