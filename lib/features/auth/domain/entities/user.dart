import 'package:equatable/equatable.dart';

class AppUser extends Equatable {
  final String id;
  final String email;
  final String? createdAt;
  final String? updatedAt;
  final String? emailConfirmedAt;

  const AppUser({
    required this.id,
    required this.email,
    this.createdAt,
    this.updatedAt,
    this.emailConfirmedAt,
  });

  @override
  List<Object?> get props =>
      [id, email, createdAt, updatedAt, emailConfirmedAt];
}
