import 'package:fumo/core/usecases/usecase.dart';
import 'package:fumo/domain/repositories/chat_repository.dart';

class SendMessage extends UseCase<void, SendMessageParams> {
  SendMessage(this._repository);

  final ChatRepository _repository;

  @override
  Future<void> call(SendMessageParams params) {
    return _repository.sendMessage(
      receiverId: params.receiverId,
      message: params.message,
    );
  }
}

class SendMessageParams {
  const SendMessageParams({
    required this.receiverId,
    required this.message,
  });

  final String receiverId;
  final String message;
}
