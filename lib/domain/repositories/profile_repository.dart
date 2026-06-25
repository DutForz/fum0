import 'package:fumo/domain/entities/user_entity.dart';

abstract class ProfileRepository {
  Future<UserEntity> getProfile(String uid);
  Future<UserEntity> updateProfile(UserEntity profile);
  Future<String> uploadAvatar({required String uid, required String filePath});
}
