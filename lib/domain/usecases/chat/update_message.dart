import 'package:fumo/core/usecases/usecase.dart';
import 'package:fumo/domain/repositories/chat_repository.dart';

class UpdateMessage extends UseCase<void, UpdateMessageParams> {
  UpdateMessage(this._repository);
  final ChatRepository _repository;
  @override Future<void> call(UpdateMessageParams params) => _repository.updateMessage(currentUserId: params.currentUserId, otherUserId: params.otherUserId, messageId: params.messageId, newMessage: params.newMessage);
}

class UpdateMessageParams {
  const UpdateMessageParams({required this.currentUserId, required this.otherUserId, required this.messageId, required this.newMessage});
  final String currentUserId;
  final String otherUserId;
  final String messageId;
  final String newMessage;
}