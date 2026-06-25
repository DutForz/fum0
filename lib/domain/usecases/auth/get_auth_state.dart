import 'package:fumo/core/usecases/usecase.dart';
import 'package:fumo/domain/entities/user_entity.dart';
import 'package:fumo/domain/repositories/auth_repository.dart';

class GetAuthState extends StreamUseCase<UserEntity?, NoParams> {
  GetAuthState(this._repository);
  final AuthRepository _repository;
  @override
  Stream<UserEntity?> call(NoParams params) => _repository.authStateChanges;
}

class GetCurrentUser {
  GetCurrentUser(this._repository);
  final AuthRepository _repository;
  UserEntity? call() => _repository.currentUser;
}
