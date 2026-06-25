import 'package:equatable/equatable.dart';
import 'package:fumo/domain/entities/registration_method.dart';

class UserEntity extends Equatable {
  const UserEntity({
    required this.uid,
    required this.email,
    this.nickname,
    this.phone,
    this.bio,
    this.avatarUrl,
    this.registrationMethod = RegistrationMethod.email,
  });

  final String uid;
  final String email;
  final String? nickname;
  final String? phone;
  final String? bio;
  final String? avatarUrl;
  final RegistrationMethod registrationMethod;

  String get displayName {
    if (nickname != null && nickname!.trim().isNotEmpty) {
      return nickname!.trim();
    }
    return email;
  }

  @override
  List<Object?> get props => [
        uid,
        email,
        nickname,
        phone,
        bio,
        avatarUrl,
        registrationMethod,
      ];
}
