import 'package:fumo/core/usecases/usecase.dart';
import 'package:fumo/domain/entities/user_entity.dart';
import 'package:fumo/domain/repositories/auth_repository.dart';

class SignInWithEmail extends UseCase<UserEntity, SignInParams> {
  SignInWithEmail(this._repository);
  final AuthRepository _repository;
  @override Future<UserEntity> call(SignInParams params) => _repository.signInWithEmailAndPassword(email: params.email, password: params.password);
}

class SignInParams {
  const SignInParams({required this.email, required this.password});
  final String email;
  final String password;
}
