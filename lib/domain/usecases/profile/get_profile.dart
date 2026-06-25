import 'package:fumo/core/usecases/usecase.dart';
import 'package:fumo/domain/entities/user_entity.dart';
import 'package:fumo/domain/repositories/profile_repository.dart';

class GetProfile extends UseCase<UserEntity, GetProfileParams> {
  GetProfile(this._repository);

  final ProfileRepository _repository;

  @override
  Future<UserEntity> call(GetProfileParams params) {
    return _repository.getProfile(params.uid);
  }
}

class GetProfileParams {
  const GetProfileParams({required this.uid});

  final String uid;
}
