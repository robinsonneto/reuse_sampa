import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../providers/ecoponto_providers.dart';
import 'widgets/institutional_widgets.dart';

class ContactScreen extends ConsumerWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ecopontoAsync = ref.watch(currentEcopontoProvider);
    final phone = ecopontoAsync.valueOrNull?.phone ?? '(11) 2222-3344';

    return InstitutionalScaffold(
      title: 'Contato',
      headerIcon: Icons.mail_outline_rounded,
      headerSubtitle: 'Fale com a equipe do Reuse Sampa — Ecoponto Bresser',
      children: [
        _ContactTile(
          icon: Icons.call_outlined,
          label: phone,
          onTap: () => launchUrl(Uri(scheme: 'tel', path: phone.replaceAll(RegExp(r'[^0-9]'), ''))),
        ),
        _ContactTile(
          icon: Icons.email_outlined,
          label: 'reusesampa@prefeitura.sp.gov.br',
          onTap: () => launchUrl(Uri(scheme: 'mailto', path: 'reusesampa@prefeitura.sp.gov.br')),
        ),
        _ContactTile(
          icon: Icons.language_outlined,
          label: 'prefeitura.sp.gov.br/reusesampa',
          onTap: () => launchUrl(Uri.parse('https://prefeitura.sp.gov.br')),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Dúvidas sobre um item específico, sugestões ou elogios? Fale com a equipe presencialmente '
          'no Ecoponto Bresser durante o horário de funcionamento, ou utilize os canais acima.',
          style: AppTextStyles.bodyMedium,
        ),
      ],
    );
  }
}

class _ContactTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ContactTile({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.beigeDark),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.mediumGreen),
        title: Text(label, style: AppTextStyles.bodyMedium),
        trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.greyText),
        onTap: onTap,
      ),
    );
  }
}
