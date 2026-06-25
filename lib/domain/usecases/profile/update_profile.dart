import 'package:fumo/core/usecases/usecase.dart';
import 'package:fumo/domain/entities/user_entity.dart';
import 'package:fumo/domain/repositories/profile_repository.dart';

class UpdateProfile extends UseCase<UserEntity, UpdateProfileParams> {
  UpdateProfile(this._repository);

  final ProfileRepository _repository;

  @override
  Future<UserEntity> call(UpdateProfileParams params) {
    return _repository.updateProfile(params.profile);
  }
}

class UpdateProfileParams {
  const UpdateProfileParams({required this.profile});

  final UserEntity profile;
}
