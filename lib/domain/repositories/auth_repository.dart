import '../entities/app_user.dart';

abstract class AuthRepository {
  Stream<AppUser?> authStateChanges();

  AppUser? get currentUser;

  Future<AppUser> signInWithGoogle();

  Future<AppUser> signInWithApple();

  Future<AppUser> signInWithGovBr();

  Future<AppUser> signInWithEmail({required String email, required String password});

  /// Login da área administrativa (funcionários dos Ecopontos).
  /// Em produção, validar contra a custom claim `admin: true` no Firebase
  /// Auth — nunca decidir o papel do usuário só pelo formulário de login.
  Future<AppUser> signInAdmin({required String email, required String password});

  Future<void> signOut();
}
