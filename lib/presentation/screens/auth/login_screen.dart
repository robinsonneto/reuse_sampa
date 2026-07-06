import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../providers/repository_providers.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _loading = false;
  bool _showEmailForm = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _signIn(Future<void> Function() action) async {
    setState(() => _loading = true);
    try {
      await action();
      if (mounted) {
        // Se a tela de login foi empilhada sobre outra (ex.: ao tentar
        // reservar um item sem estar logado), volta para ela com `true`
        // para que o fluxo original continue de onde parou. Caso contrário
        // (login aberto direto, ex.: pela aba Perfil), vai para a Home.
        if (context.canPop()) {
          context.pop(true);
        } else {
          context.go(AppRoutes.home);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Não foi possível entrar: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.read(authRepositoryProvider);

    return Scaffold(
      backgroundColor: AppColors.beige,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => context.canPop() ? context.pop() : context.go(AppRoutes.home),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text('Entrar no Reuse Sampa', style: AppTextStyles.displayMedium),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Entre para reservar itens e receber notificações de novidades.',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.greyText),
              ),
              const SizedBox(height: AppSpacing.xl),
              if (!_showEmailForm) ...[
                _SocialButton(
                  label: 'Continuar com Google',
                  icon: Icons.g_mobiledata_rounded,
                  onPressed: _loading ? null : () => _signIn(() => auth.signInWithGoogle()),
                ),
                const SizedBox(height: AppSpacing.sm),
                _SocialButton(
                  label: 'Continuar com Apple',
                  icon: Icons.apple_rounded,
                  onPressed: _loading ? null : () => _signIn(() => auth.signInWithApple()),
                ),
                const SizedBox(height: AppSpacing.sm),
                _SocialButton(
                  label: 'Continuar com gov.br',
                  icon: Icons.account_balance_rounded,
                  backgroundColor: AppColors.info,
                  foregroundColor: Colors.white,
                  onPressed: _loading ? null : () => _signIn(() => auth.signInWithGovBr()),
                ),
                const SizedBox(height: AppSpacing.sm),
                _SocialButton(
                  label: 'Continuar com e-mail',
                  icon: Icons.mail_outline_rounded,
                  onPressed: _loading ? null : () => setState(() => _showEmailForm = true),
                ),
              ] else ...[
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'E-mail', hintText: 'voce@email.com'),
                ),
                const SizedBox(height: AppSpacing.sm),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Senha'),
                ),
                const SizedBox(height: AppSpacing.md),
                PrimaryButton(
                  label: 'Entrar',
                  isLoading: _loading,
                  onPressed: () => _signIn(() => auth.signInWithEmail(
                        email: _emailController.text,
                        password: _passwordController.text,
                      )),
                ),
                const SizedBox(height: AppSpacing.xs),
                TextButton(
                  onPressed: () => setState(() => _showEmailForm = false),
                  child: const Text('Voltar às outras opções'),
                ),
              ],
              const Spacer(),
              Center(
                child: Text(
                  'Ao continuar, você concorda com os Termos de Uso\ne a Política de Privacidade da Prefeitura de São Paulo.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.caption,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const _SocialButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: foregroundColor ?? AppColors.charcoal),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor ?? Colors.white,
          foregroundColor: foregroundColor ?? AppColors.charcoal,
          side: const BorderSide(color: AppColors.greyBorder),
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
        ),
      ),
    );
  }
}
