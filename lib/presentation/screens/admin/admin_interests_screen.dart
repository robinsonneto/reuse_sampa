import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../providers/interest_providers.dart';
import 'widgets/admin_drawer.dart';

/// "Consultar interessados" — lista todas as manifestações de "Tenho
/// interesse" registradas pelos cidadãos, mais recentes primeiro.
class AdminInterestsScreen extends ConsumerWidget {
  const AdminInterestsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final interestsAsync = ref.watch(allInterestsProvider);
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm', 'pt_BR');

    return Scaffold(
      backgroundColor: AppColors.beige,
      appBar: AppBar(title: Text('Interessados', style: AppTextStyles.headlineLarge)),
      drawer: const AdminDrawer(currentRoute: AppRoutes.adminInterests),
      body: interestsAsync.when(
        data: (interests) {
          if (interests.isEmpty) {
            return const EmptyState(
              icon: Icons.thumb_up_alt_outlined,
              title: 'Nenhum interesse registrado ainda',
              message: 'Assim que um cidadão tocar em "Tenho interesse" em um item,\no registro aparecerá aqui.',
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            itemCount: interests.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.xs),
            itemBuilder: (context, index) {
              final interest = interests[index];
              return Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(color: AppColors.beigeDark),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(color: AppColors.beigeSoft, shape: BoxShape.circle),
                      child: const Icon(Icons.person_outline_rounded, color: AppColors.darkGreen),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(interest.itemName, style: AppTextStyles.titleMedium.copyWith(fontSize: 14)),
                          Text(interest.userName, style: AppTextStyles.bodySmall),
                        ],
                      ),
                    ),
                    Text(dateFormat.format(interest.createdAt), style: AppTextStyles.caption),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const LoadingIndicator(),
        error: (e, _) => const ErrorState(),
      ),
    );
  }
}
