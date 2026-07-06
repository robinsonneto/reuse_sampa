import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../providers/auth_providers.dart';
import '../../../providers/repository_providers.dart';

/// Menu lateral do painel administrativo, com as funções listadas no
/// briefing (seção PAINEL ADMINISTRATIVO).
class AdminDrawer extends ConsumerWidget {
  final String currentRoute;

  const AdminDrawer({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    Widget item(IconData icon, String label, String route) {
      final selected = currentRoute == route;
      return ListTile(
        leading: Icon(icon, color: selected ? AppColors.mediumGreen : Colors.white70),
        title: Text(label,
            style: AppTextStyles.bodyLarge
                .copyWith(color: selected ? AppColors.mediumGreen : Colors.white, fontWeight: selected ? FontWeight.w700 : FontWeight.w400)),
        selected: selected,
        selectedTileColor: Colors.white.withOpacity(0.06),
        onTap: () {
          Navigator.of(context).pop();
          if (!selected) context.go(route);
        },
      );
    }

    return Drawer(
      backgroundColor: AppColors.darkGreen,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.person_rounded, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user?.name ?? 'Equipe Ecoponto',
                            style: AppTextStyles.titleMedium.copyWith(color: Colors.white)),
                        Text('Painel administrativo',
                            style: AppTextStyles.caption.copyWith(color: Colors.white60)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.white24, height: 1),
            item(Icons.dashboard_outlined, 'Estatísticas', AppRoutes.adminDashboard),
            item(Icons.inventory_2_outlined, 'Itens', AppRoutes.adminItems),
            item(Icons.thumb_up_alt_outlined, 'Interessados', AppRoutes.adminInterests),
            item(Icons.people_outline_rounded, 'Usuários', AppRoutes.adminUsers),
            const Spacer(),
            const Divider(color: Colors.white24, height: 1),
            ListTile(
              leading: const Icon(Icons.storefront_outlined, color: Colors.white70),
              title: Text('Voltar ao app do cidadão', style: AppTextStyles.bodyMedium.copyWith(color: Colors.white70)),
              onTap: () => context.go(AppRoutes.home),
            ),
            ListTile(
              leading: const Icon(Icons.logout_rounded, color: Colors.white70),
              title: Text('Sair', style: AppTextStyles.bodyMedium.copyWith(color: Colors.white70)),
              onTap: () async {
                await ref.read(authRepositoryProvider).signOut();
                if (context.mounted) context.go(AppRoutes.adminLogin);
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
