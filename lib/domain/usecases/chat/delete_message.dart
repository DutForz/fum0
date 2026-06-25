import 'package:fumo/core/usecases/usecase.dart';
import 'package:fumo/domain/repositories/chat_repository.dart';

class DeleteMessage extends UseCase<void, DeleteMessageParams> {
  DeleteMessage(this._repository);
  final ChatRepository _repository;
  @override Future<void> call(DeleteMessageParams params) => _repository.deleteMessage(currentUserId: params.currentUserId, otherUserId: params.otherUserId, messageId: params.messageId);
}

class DeleteMessageParams {
  const DeleteMessageParams({required this.currentUserId, required this.otherUserId, required this.messageId});
  final String currentUserId;
  final String otherUserId;
  final String messageId;
}