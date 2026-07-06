import 'package:flutter/material.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import 'widgets/admin_drawer.dart';

/// Gestão de usuários — versão inicial com dados fictícios.
///
/// Em produção, popular a partir da coleção `users` no Firestore
/// (id, nome, e-mail, provedor de login, data de cadastro, nº de reservas).
/// Ações administrativas típicas: suspender conta por abuso (reservas sem
/// retirada recorrentes), promover um usuário a funcionário/admin.
class AdminUsersScreen extends StatelessWidget {
  const AdminUsersScreen({super.key});

  static const _mockUsers = [
    (name: 'Ana Beatriz Souza', email: 'ana.souza@gmail.com', reservas: 4),
    (name: 'Carlos Eduardo Lima', email: 'carlos.lima@icloud.com', reservas: 1),
    (name: 'Fernanda Ribeiro', email: 'fernanda.r@servidor.gov.br', reservas: 7),
    (name: 'João Pedro Alves', email: 'jp.alves@gmail.com', reservas: 2),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.beige,
      appBar: AppBar(title: Text('Usuários', style: AppTextStyles.headlineLarge)),
      drawer: const AdminDrawer(currentRoute: AppRoutes.adminUsers),
      body: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        itemCount: _mockUsers.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.xs),
        itemBuilder: (context, index) {
          final user = _mockUsers[index];
          return Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: AppColors.beigeDark),
            ),
            child: Row(
              children: [
                CircleAvatar(backgroundColor: AppColors.beigeSoft, child: Text(user.name[0], style: const TextStyle(color: AppColors.darkGreen))),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.name, style: AppTextStyles.titleMedium),
                      Text(user.email, style: AppTextStyles.bodySmall),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('${user.reservas}', style: AppTextStyles.titleMedium),
                    Text('reservas', style: AppTextStyles.caption),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
