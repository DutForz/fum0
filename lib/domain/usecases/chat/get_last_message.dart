import 'package:fumo/core/usecases/usecase.dart';
import 'package:fumo/domain/repositories/chat_repository.dart';

class GetLastMessage extends StreamUseCase<String?, GetLastMessageParams> {
  GetLastMessage(this._repository);
  final ChatRepository _repository;
  @override
  Stream<String?> call(GetLastMessageParams params) =>
      _repository.getLastMessage(
        currentUserId: params.currentUserId,
        otherUserId: params.otherUserId,
      );
}

class GetLastMessageParams {
  const GetLastMessageParams({
    required this.currentUserId,
    required this.otherUserId,
  });
  final String currentUserId;
  final String otherUserId;
}
