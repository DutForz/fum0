import 'package:fumo/core/errors/exceptions.dart';
import 'package:fumo/core/errors/failures.dart';
import 'package:fumo/data/datasources/auth_remote_datasource.dart';
import 'package:fumo/data/models/user_model.dart';
import 'package:fumo/domain/entities/user_entity.dart';
import 'package:fumo/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({required AuthRemoteDataSource remoteDataSource}) : _remoteDataSource = remoteDataSource;
  final AuthRemoteDataSource _remoteDataSource;
  UserEntity? _mapUser(dynamic user) { if (user == null) return null; return UserModel(uid: user.uid as String, email: user.email as String? ?? ''); }
  @override Stream<UserEntity?> get authStateChanges => _remoteDataSource.authStateChanges.map(_mapUser);
  @override UserEntity? get currentUser => _mapUser(_remoteDataSource.currentUser);
  @override Future<UserEntity> signInWithEmailAndPassword({required String email, required String password}) async {
    try { final credential = await _remoteDataSource.signInWithEmailAndPassword(email: email, password: password); return UserModel(uid: credential.user!.uid, email: credential.user!.email ?? email); }
    on AuthException catch (e) { throw AuthFailure(e.code); } on ServerException { throw const ServerFailure(); }
  }
  @override Future<UserEntity> signUpWithEmailAndPassword({required String email, required String password}) async {
    try { final credential = await _remoteDataSource.signUpWithEmailAndPassword(email: email, password: password); return UserModel(uid: credential.user!.uid, email: credential.user!.email ?? email); }
    on AuthException catch (e) { throw AuthFailure(e.code); } on ServerException { throw const ServerFailure(); }
  }
  @override Future<void> signOut() async { try { await _remoteDataSource.signOut(); } on AuthException catch (e) { throw AuthFailure(e.code); } }
}
