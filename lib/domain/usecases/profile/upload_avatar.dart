import 'package:fumo/core/usecases/usecase.dart';
import 'package:fumo/domain/repositories/profile_repository.dart';

class UploadAvatar extends UseCase<String, UploadAvatarParams> {
  UploadAvatar(this._repository);
  final ProfileRepository _repository;
  @override
  Future<String> call(UploadAvatarParams params) =>
      _repository.uploadAvatar(uid: params.uid, filePath: params.filePath);
}

class UploadAvatarParams {
  const UploadAvatarParams({required this.uid, required this.filePath});
  final String uid;
  final String filePath;
}
