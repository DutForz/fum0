import 'package:fumo/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Stream<UserEntity?> get authStateChanges;
  UserEntity? get currentUser;
  Future<UserEntity> signInWithEmailAndPassword({required String email, required String password});
  Future<UserEntity> signUpWithEmailAndPassword({required String email, required String password});
  Future<void> signOut();
}
