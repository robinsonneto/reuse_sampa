import 'package:equatable/equatable.dart';

enum AuthProvider { google, apple, govBr, email }

enum UserRole { citizen, admin }

class AppUser extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final AuthProvider provider;
  final UserRole role;
  final List<String> favoriteCategoryIds;

  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    required this.provider,
    this.role = UserRole.citizen,
    this.favoriteCategoryIds = const [],
  });

  bool get isAdmin => role == UserRole.admin;

  @override
  List<Object?> get props => [id, name, email, provider, role];
}
