import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../providers/auth_providers.dart';
import '../../providers/repository_providers.dart';
import '../../providers/theme_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      backgroundColor: AppColors.beige,
      appBar: AppBar(title: Text('Perfil', style: AppTextStyles.headlineLarge)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        children: [
          if (user != null)
            _UserHeader(name: user.name, email: user.email, photoUrl: user.photoUrl)
          else
            _GuestHeader(onLogin: () => context.push(AppRoutes.login)),
          const SizedBox(height: AppSpacing.lg),
          _SectionCard(
            children: [
              _ProfileTile(
                icon: Icons.favorite_border_rounded,
                label: 'Favoritos',
                onTap: () => context.go(AppRoutes.favorites),
              ),
              _ProfileTile(
                icon: Icons.place_outlined,
                label: 'Ecoponto Bresser',
                onTap: () => context.go(AppRoutes.ecoponto),
              ),
              _ProfileTile(
                icon: Icons.notifications_none_rounded,
                label: 'Notificações',
                onTap: () => context.push(AppRoutes.notifications),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _SectionCard(
            children: [
              _ProfileTile(
                icon: Icons.dark_mode_outlined,
                label: 'Modo escuro',
                trailing: Switch(
                  value: themeMode == ThemeMode.dark,
                  activeThumbColor: AppColors.mediumGreen,
                  onChanged: (value) => ref
                      .read(themeModeProvider.notifier)
                      .set(value ? ThemeMode.dark : ThemeMode.light),
                ),
              ),
              _ProfileTile(
                icon: Icons.text_fields_rounded,
                label: 'Acessibilidade',
                subtitle: 'Texto ampliado e alto contraste seguem as\nconfigurações do seu aparelho',
                onTap: null,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _SectionCard(
            children: [
              _ProfileTile(
                icon: Icons.help_outline_rounded,
                label: 'Como funciona?',
                onTap: () => context.push(AppRoutes.howItWorks),
              ),
              _ProfileTile(
                icon: Icons.info_outline_rounded,
                label: 'Sobre o Projeto',
                onTap: () => context.push(AppRoutes.aboutProject),
              ),
              _ProfileTile(
                icon: Icons.autorenew_rounded,
                label: 'Economia Circular',
                onTap: () => context.push(AppRoutes.circularEconomy),
              ),
              _ProfileTile(
                icon: Icons.quiz_outlined,
                label: 'Perguntas Frequentes',
                onTap: () => context.push(AppRoutes.faq),
              ),
              _ProfileTile(
                icon: Icons.mail_outline_rounded,
                label: 'Contato',
                onTap: () => context.push(AppRoutes.contact),
              ),
              _ProfileTile(
                icon: Icons.description_outlined,
                label: 'Política de Uso',
                onTap: () => context.push(AppRoutes.usagePolicy),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _SectionCard(
            children: [
              _ProfileTile(
                icon: Icons.admin_panel_settings_outlined,
                label: 'Painel administrativo',
                subtitle: 'Acesso restrito a funcionários do Ecoponto',
                onTap: () => context.push(AppRoutes.adminLogin),
              ),
            ],
          ),
          if (user != null) ...[
            const SizedBox(height: AppSpacing.md),
            _SectionCard(
              children: [
                _ProfileTile(
                  icon: Icons.logout_rounded,
                  label: 'Sair da conta',
                  iconColor: AppColors.error,
                  labelColor: AppColors.error,
                  onTap: () => ref.read(authRepositoryProvider).signOut(),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _UserHeader extends StatelessWidget {
  final String name;
  final String email;
  final String? photoUrl;

  const _UserHeader({required this.name, required this.email, this.photoUrl});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: AppColors.mediumGreen,
          backgroundImage: photoUrl != null ? NetworkImage(photoUrl!) : null,
          child: photoUrl == null ? const Icon(Icons.person_rounded, color: Colors.white, size: 30) : null,
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: AppTextStyles.headlineMedium),
              Text(email, style: AppTextStyles.bodySmall),
            ],
          ),
        ),
      ],
    );
  }
}

class _GuestHeader extends StatelessWidget {
  final VoidCallback onLogin;
  const _GuestHeader({required this.onLogin});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(color: AppColors.darkGreen, borderRadius: BorderRadius.circular(AppRadius.lg)),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 26,
            backgroundColor: Colors.white24,
            child: Icon(Icons.person_outline_rounded, color: Colors.white),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Você ainda não entrou', style: AppTextStyles.titleMedium.copyWith(color: Colors.white)),
                Text('Entre para demonstrar interesse em itens', style: AppTextStyles.bodySmall.copyWith(color: Colors.white70)),
              ],
            ),
          ),
          TextButton(
            onPressed: onLogin,
            style: TextButton.styleFrom(backgroundColor: Colors.white, foregroundColor: AppColors.darkGreen),
            child: const Text('Entrar'),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final List<Widget> children;
  const _SectionCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.beigeDark),
      ),
      child: Column(children: children),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;
  final Color? iconColor;
  final Color? labelColor;

  const _ProfileTile({
    required this.icon,
    required this.label,
    this.subtitle,
    this.onTap,
    this.trailing,
    this.iconColor,
    this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? AppColors.darkGreen),
      title: Text(label, style: AppTextStyles.bodyLarge.copyWith(color: labelColor)),
      subtitle: subtitle != null ? Text(subtitle!, style: AppTextStyles.caption) : null,
      trailing: trailing ?? (onTap != null ? const Icon(Icons.chevron_right_rounded, color: AppColors.greyText) : null),
      onTap: onTap,
    );
  }
}
