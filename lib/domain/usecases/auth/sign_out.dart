import 'package:fumo/core/usecases/usecase.dart';
import 'package:fumo/domain/repositories/auth_repository.dart';

class SignOut extends UseCase<void, NoParams> {
  SignOut(this._repository);
  final AuthRepository _repository;
  @override Future<void> call(NoParams params) => _repository.signOut();
}
