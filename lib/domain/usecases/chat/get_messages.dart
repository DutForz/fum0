import 'package:fumo/core/usecases/usecase.dart';
import 'package:fumo/domain/entities/message_entity.dart';
import 'package:fumo/domain/repositories/chat_repository.dart';

class GetMessages extends StreamUseCase<List<MessageEntity>, GetMessagesParams> {
  GetMessages(this._repository);

  final ChatRepository _repository;

  @override
  Stream<List<MessageEntity>> call(GetMessagesParams params) {
    return _repository.getMessages(
      currentUserId: params.currentUserId,
      otherUserId: params.otherUserId,
    );
  }
}

class GetMessagesParams {
  const GetMessagesParams({
    required this.currentUserId,
    required this.otherUserId,
  });

  final String currentUserId;
  final String otherUserId;
}
