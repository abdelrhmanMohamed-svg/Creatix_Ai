import 'package:equatable/equatable.dart';

class Profile extends Equatable {
  final String id;
  final String userId;
  final String? fullName;
  final String? avatarUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Profile({
    required this.id,
    required this.userId,
    this.fullName,
    this.avatarUrl,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props =>
      [id, userId, fullName, avatarUrl, createdAt, updatedAt];
}
