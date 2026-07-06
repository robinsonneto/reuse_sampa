import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// --- Firebase (descomentar após rodar `flutterfire configure`) ---
// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';

import 'core/theme/app_theme.dart';
import 'presentation/providers/theme_provider.dart';
import 'presentation/router/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ---------------------------------------------------------------------
  // TODO(equipe-backend): habilitar Firebase antes de publicar.
  //
  // 1. Instalar a FlutterFire CLI e rodar `flutterfire configure` na raiz
  //    do projeto — isso gera `lib/firebase_options.dart` automaticamente
  //    com as chaves dos apps iOS/Android/Web cadastrados no console.
  // 2. Descomentar os imports acima e a chamada abaixo.
  // 3. Trocar as implementações Mock pelas implementações Firestore nos
  //    providers em lib/presentation/providers/repository_providers.dart.
  //
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // ---------------------------------------------------------------------

  runApp(const ProviderScope(child: ReuseSampaApp()));
}

class ReuseSampaApp extends ConsumerWidget {
  const ReuseSampaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'Reuse Sampa',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: router,
      // Acessibilidade: respeita a configuração do sistema para escala de
      // texto, com um teto para não quebrar layouts (WCAG pede suporte a
      // texto maior, não texto ilimitado).
      builder: (context, child) {
        final mediaQuery = MediaQuery.of(context);
        final clampedScale = mediaQuery.textScaler.clamp(minScaleFactor: 0.9, maxScaleFactor: 1.4);
        return MediaQuery(
          data: mediaQuery.copyWith(textScaler: clampedScale),
          child: child!,
        );
      },
    );
  }
}
