import 'package:fumo/core/errors/exceptions.dart';
import 'package:fumo/core/errors/failures.dart';
import 'package:fumo/data/datasources/profile_remote_datasource.dart';
import 'package:fumo/data/models/user_model.dart';
import 'package:fumo/domain/entities/user_entity.dart';
import 'package:fumo/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl({required ProfileRemoteDataSource remoteDataSource}) : _remoteDataSource = remoteDataSource;
  final ProfileRemoteDataSource _remoteDataSource;
  @override Future<UserEntity> getProfile(String uid) async { try { return await _remoteDataSource.getProfile(uid); } on ServerException catch (e) { throw ServerFailure(e.message ?? 'Failed to load profile'); } }
  @override Future<UserEntity> updateProfile(UserEntity profile) async {
    try { return await _remoteDataSource.updateProfile(UserModel(uid: profile.uid, email: profile.email, nickname: profile.nickname, phone: profile.phone, bio: profile.bio, avatarUrl: profile.avatarUrl, registrationMethod: profile.registrationMethod)); }
    on NicknameTakenException { throw const NicknameTakenFailure(); } on AuthException catch (e) { throw AuthFailure(e.code); } on ServerException catch (e) { throw ServerFailure(e.message ?? 'Failed to update profile'); }
  }
  @override Future<String> uploadAvatar({required String uid, required String filePath}) async { try { return await _remoteDataSource.uploadAvatar(uid: uid, filePath: filePath); } on ServerException catch (e) { throw ServerFailure(e.message ?? 'Failed to upload avatar'); } }
}
