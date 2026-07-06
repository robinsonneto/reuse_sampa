/// Nomes e caminhos de rota centralizados — evita strings soltas espalhadas
/// pelas telas e facilita deep-linking (ex.: abrir um item a partir de uma
/// push notification ou de um QR Code).
class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';

  // --- Menu inferior ---
  static const String home = '/home';
  static const String ecoponto = '/ecoponto';
  static const String favorites = '/favorites';
  static const String impact = '/impact';
  static const String profile = '/profile';

  static const String search = '/search';
  static const String catalog = '/catalog';
  static const String category = '/category/:categoryId';
  static const String itemDetail = '/item/:itemId';
  static const String notifications = '/notifications';
  static const String qrScan = '/qr-scan';

  // --- Institucionais ---
  static const String howItWorks = '/how-it-works';
  static const String aboutProject = '/about-project';
  static const String circularEconomy = '/circular-economy';
  static const String faq = '/faq';
  static const String contact = '/contact';
  static const String usagePolicy = '/usage-policy';

  static const String adminLogin = '/admin/login';
  static const String adminDashboard = '/admin';
  static const String adminItems = '/admin/items';
  static const String adminItemForm = '/admin/items/form';
  static const String adminInterests = '/admin/interests';
  static const String adminUsers = '/admin/users';

  static String categoryPath(String categoryId) => '/category/$categoryId';
  static String itemDetailPath(String itemId) => '/item/$itemId';
}
