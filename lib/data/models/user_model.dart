import 'package:fumo/domain/entities/registration_method.dart';
import 'package:fumo/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.uid,
    required super.email,
    super.nickname,
    super.phone,
    super.bio,
    super.avatarUrl,
    super.registrationMethod,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String,
      email: map['email'] as String? ?? '',
      nickname: map['nickname'] as String?,
      phone: map['phone'] as String?,
      bio: map['bio'] as String?,
      avatarUrl: map['avatarUrl'] as String?,
      registrationMethod: RegistrationMethod.fromString(
        map['registrationMethod'] as String?,
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      if (nickname != null) 'nickname': nickname,
      if (phone != null) 'phone': phone,
      if (bio != null) 'bio': bio,
      if (avatarUrl != null) 'avatarUrl': avatarUrl,
      'registrationMethod': registrationMethod.toFirestoreValue(),
    };
  }

  UserModel copyWith({
    String? uid,
    String? email,
    String? nickname,
    String? phone,
    String? bio,
    String? avatarUrl,
    RegistrationMethod? registrationMethod,
    bool clearNickname = false,
    bool clearPhone = false,
    bool clearBio = false,
    bool clearAvatarUrl = false,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      nickname: clearNickname ? null : (nickname ?? this.nickname),
      phone: clearPhone ? null : (phone ?? this.phone),
      bio: clearBio ? null : (bio ?? this.bio),
      avatarUrl: clearAvatarUrl ? null : (avatarUrl ?? this.avatarUrl),
      registrationMethod: registrationMethod ?? this.registrationMethod,
    );
  }
}
