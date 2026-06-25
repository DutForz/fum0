import 'package:fumo/core/usecases/usecase.dart';
import 'package:fumo/domain/entities/user_entity.dart';
import 'package:fumo/domain/repositories/auth_repository.dart';

class SignUpWithEmail extends UseCase<UserEntity, SignUpParams> {
  SignUpWithEmail(this._repository);

  final AuthRepository _repository;

  @override
  Future<UserEntity> call(SignUpParams params) {
    return _repository.signUpWithEmailAndPassword(
      email: params.email,
      password: params.password,
    );
  }
}

class SignUpParams {
  const SignUpParams({required this.email, required this.password});

  final String email;
  final String password;
}
