import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_routes.dart';
import '../../core/constants/item_category.dart';
import '../providers/auth_providers.dart';
import '../screens/admin/admin_dashboard_screen.dart';
import '../screens/admin/admin_interests_screen.dart';
import '../screens/admin/admin_item_form_screen.dart';
import '../screens/admin/admin_items_list_screen.dart';
import '../screens/admin/admin_login_screen.dart';
import '../screens/admin/admin_users_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/category/category_items_screen.dart';
import '../screens/catalog/all_items_screen.dart';
import '../screens/ecoponto/ecoponto_screen.dart';
import '../screens/favorites/favorites_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/impact/impact_screen.dart';
import '../screens/institutional/about_project_screen.dart';
import '../screens/institutional/circular_economy_screen.dart';
import '../screens/institutional/contact_screen.dart';
import '../screens/institutional/faq_screen.dart';
import '../screens/institutional/how_it_works_screen.dart';
import '../screens/institutional/usage_policy_screen.dart';
import '../screens/item/item_detail_screen.dart';
import '../screens/item/qr_scan_screen.dart';
import '../screens/notifications/notifications_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/search/search_screen.dart';
import '../screens/splash/splash_screen.dart';
import '../widgets/main_shell.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: false,
    redirect: (context, state) {
      // Exemplo de guarda de rota simples para a área administrativa.
      // A validação "de verdade" (checar custom claim `admin: true` no
      // Firebase Auth) deve ocorrer aqui e/ou nas regras do Firestore.
      final goingToAdmin = state.matchedLocation.startsWith('/admin') &&
          state.matchedLocation != AppRoutes.adminLogin;
      if (goingToAdmin) {
        final user = ref.read(currentUserProvider);
        if (user == null || !user.isAdmin) {
          return AppRoutes.adminLogin;
        }
      }
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),

      // --- Shell principal com menu inferior: Início / Ecoponto / Favoritos / Impacto / Perfil ---
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(path: AppRoutes.home, builder: (context, state) => const HomeScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: AppRoutes.ecoponto, builder: (context, state) => const EcopontoScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
                path: AppRoutes.favorites, builder: (context, state) => const FavoritesScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: AppRoutes.impact, builder: (context, state) => const ImpactScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: AppRoutes.profile, builder: (context, state) => const ProfileScreen()),
          ]),
        ],
      ),

      // --- Rotas empilhadas fora do shell (telas de detalhe / fluxo) ---
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.search,
        builder: (context, state) => const SearchScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.catalog,
        builder: (context, state) => const AllItemsScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.category,
        builder: (context, state) {
          final categoryId = state.pathParameters['categoryId']!;
          final category = ItemCategoryX.fromFirestoreId(categoryId);
          return CategoryItemsScreen(category: category);
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.itemDetail,
        builder: (context, state) {
          final itemId = state.pathParameters['itemId']!;
          return ItemDetailScreen(itemId: itemId);
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.notifications,
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.qrScan,
        builder: (context, state) => const QrScanScreen(),
      ),

      // --- Páginas institucionais ---
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.howItWorks,
        builder: (context, state) => const HowItWorksScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.aboutProject,
        builder: (context, state) => const AboutProjectScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.circularEconomy,
        builder: (context, state) => const CircularEconomyScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.faq,
        builder: (context, state) => const FaqScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.contact,
        builder: (context, state) => const ContactScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.usagePolicy,
        builder: (context, state) => const UsagePolicyScreen(),
      ),

      // --- Painel administrativo ---
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.adminLogin,
        builder: (context, state) => const AdminLoginScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.adminDashboard,
        builder: (context, state) => const AdminDashboardScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.adminItems,
        builder: (context, state) => const AdminItemsListScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.adminItemForm,
        builder: (context, state) {
          final itemId = state.uri.queryParameters['itemId'];
          return AdminItemFormScreen(itemId: itemId);
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.adminInterests,
        builder: (context, state) => const AdminInterestsScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.adminUsers,
        builder: (context, state) => const AdminUsersScreen(),
      ),
    ],
  );
});
