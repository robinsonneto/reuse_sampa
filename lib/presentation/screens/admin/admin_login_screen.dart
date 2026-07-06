import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../domain/entities/app_user.dart';
import '../../providers/repository_providers.dart';

/// Login separado para funcionários dos Ecopontos / equipe administrativa.
///
/// Em produção, a separação entre "cidadão" e "funcionário" deve ser feita
/// por Custom Claims no Firebase Auth (`admin: true`), definidas apenas por
/// uma Cloud Function administrada pela equipe de TI — nunca pelo client.
/// As regras do Firestore/Storage também devem checar essa claim antes de
/// permitir escrita nas coleções `items`, `ecopontos` etc.
class AdminLoginScreen extends ConsumerStatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  ConsumerState<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends ConsumerState<AdminLoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;

  Future<void> _login() async {
    setState(() => _loading = true);
    try {
      // MOCK: qualquer credencial autentica como admin para fins de
      // demonstração do painel. Trocar por validação real de custom claim.
      await ref.read(authRepositoryProvider).signInAdmin(
            email: _emailController.text.isEmpty ? 'funcionario@prefeitura.sp.gov.br' : _emailController.text,
            password: _passwordController.text,
          );
      if (mounted) context.go(AppRoutes.adminDashboard);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkGreen,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.admin_panel_settings_rounded, color: Colors.white, size: 56),
              const SizedBox(height: AppSpacing.md),
              Text('Painel administrativo',
                  style: AppTextStyles.displayMedium.copyWith(color: Colors.white), textAlign: TextAlign.center),
              const SizedBox(height: AppSpacing.xs),
              Text('Acesso restrito a funcionários dos Ecopontos',
                  style: AppTextStyles.bodyMedium.copyWith(color: Colors.white70), textAlign: TextAlign.center),
              const SizedBox(height: AppSpacing.xl),
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.lg)),
                child: Column(
                  children: [
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'E-mail funcional'),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Senha'),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    PrimaryButton(label: 'Entrar', isLoading: _loading, onPressed: _login),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              TextButton(
                onPressed: () => context.go(AppRoutes.home),
                child: const Text('Voltar para o app do cidadão', style: TextStyle(color: Colors.white70)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
