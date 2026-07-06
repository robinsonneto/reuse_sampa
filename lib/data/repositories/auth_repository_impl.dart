import 'dart:async';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';

/// Implementação MOCK de autenticação, usada para prototipagem de telas sem
/// depender de credenciais reais do Firebase/Google/Apple/Gov.br.
///
/// --- Como migrar para produção ---
/// * Google  -> pacote `google_sign_in` + `firebase_auth`
///   (GoogleAuthProvider.credential).
/// * Apple   -> pacote `sign_in_with_apple` + `firebase_auth`
///   (OAuthProvider('apple.com')). Obrigatório na App Store se houver
///   outros logins sociais.
/// * Gov.br  -> Gov.br usa OAuth2/OpenID Connect próprio (não é um provedor
///   nativo do Firebase Auth). Fluxo sugerido: abrir WebView/Custom Tabs
///   para o endpoint de autorização do Gov.br, trocar o `code` por tokens
///   em uma Cloud Function (client secret nunca deve ficar no app), e then
///   trocar o token por um Firebase Custom Token
///   (`admin.auth().createCustomToken`) para logar no `firebase_auth`.
/// * E-mail  -> `FirebaseAuth.instance.signInWithEmailAndPassword`.
class MockAuthRepository implements AuthRepository {
  AppUser? _currentUser;
  final _controller = StreamController<AppUser?>.broadcast();

  @override
  AppUser? get currentUser => _currentUser;

  @override
  Stream<AppUser?> authStateChanges() => _controller.stream;

  Future<AppUser> _signIn(AppUser user) async {
    await Future.delayed(const Duration(milliseconds: 600));
    _currentUser = user;
    _controller.add(user);
    return user;
  }

  @override
  Future<AppUser> signInWithGoogle() => _signIn(const AppUser(
        id: 'user_google_demo',
        name: 'Cidadão Paulistano',
        email: 'cidadao@gmail.com',
        provider: AuthProvider.google,
      ));

  @override
  Future<AppUser> signInWithApple() => _signIn(const AppUser(
        id: 'user_apple_demo',
        name: 'Cidadão Paulistano',
        email: 'cidadao@icloud.com',
        provider: AuthProvider.apple,
      ));

  @override
  Future<AppUser> signInWithGovBr() => _signIn(const AppUser(
        id: 'user_govbr_demo',
        name: 'Cidadão Paulistano',
        email: 'cidadao@servidor.gov.br',
        provider: AuthProvider.govBr,
      ));

  @override
  Future<AppUser> signInWithEmail({required String email, required String password}) => _signIn(
        AppUser(
          id: 'user_email_demo',
          name: 'Cidadão Paulistano',
          email: email,
          provider: AuthProvider.email,
        ),
      );

  @override
  Future<AppUser> signInAdmin({required String email, required String password}) => _signIn(
        AppUser(
          id: 'user_admin_demo',
          name: 'Equipe Ecoponto',
          email: email,
          provider: AuthProvider.email,
          role: UserRole.admin,
        ),
      );

  @override
  Future<void> signOut() async {
    _currentUser = null;
    _controller.add(null);
  }
}
