import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../domain/entities/app_notification.dart';
import '../../providers/notification_providers.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  IconData _iconFor(NotificationType type) {
    switch (type) {
      case NotificationType.novoItem:
        return Icons.new_releases_outlined;
      case NotificationType.categoriaFavorita:
        return Icons.star_border_rounded;
      case NotificationType.interesseConfirmado:
        return Icons.thumb_up_alt_outlined;
      case NotificationType.geral:
        return Icons.eco_outlined;
    }
  }

  Color _colorFor(NotificationType type) {
    switch (type) {
      case NotificationType.novoItem:
        return AppColors.mediumGreen;
      case NotificationType.categoriaFavorita:
        return AppColors.orange;
      case NotificationType.interesseConfirmado:
        return AppColors.info;
      case NotificationType.geral:
        return AppColors.darkGreen;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationsProvider);
    final dateFormat = DateFormat('dd/MM HH:mm', 'pt_BR');

    return Scaffold(
      backgroundColor: AppColors.beige,
      appBar: AppBar(
        title: Text('Notificações', style: AppTextStyles.headlineLarge),
        actions: [
          if (notifications.any((n) => !n.read))
            TextButton(
              onPressed: () => ref.read(notificationsProvider.notifier).markAllRead(),
              child: const Text('Marcar tudo como lido'),
            ),
        ],
      ),
      body: notifications.isEmpty
          ? const EmptyState(
              icon: Icons.notifications_none_rounded,
              title: 'Sem notificações',
              message: 'Avisos sobre novos itens, categorias favoritas e reservas\naparecerão aqui.',
            )
          : ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              itemCount: notifications.length,
              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.xs),
              itemBuilder: (context, index) {
                final n = notifications[index];
                return Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: n.read ? Colors.white : AppColors.beigeSoft,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    border: Border.all(color: AppColors.beigeDark),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: _colorFor(n.type).withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(_iconFor(n.type), size: 18, color: _colorFor(n.type)),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(n.title, style: AppTextStyles.titleMedium.copyWith(fontSize: 14)),
                            const SizedBox(height: 2),
                            Text(n.body, style: AppTextStyles.bodySmall),
                            const SizedBox(height: 4),
                            Text(dateFormat.format(n.createdAt), style: AppTextStyles.caption),
                          ],
                        ),
                      ),
                      if (!n.read)
                        Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.only(top: 4),
                          decoration: const BoxDecoration(color: AppColors.orange, shape: BoxShape.circle),
                        ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
