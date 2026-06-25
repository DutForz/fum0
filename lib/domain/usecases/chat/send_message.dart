import 'package:fumo/core/usecases/usecase.dart';
import 'package:fumo/domain/repositories/chat_repository.dart';
import 'package:pointycastle/export.dart';

class SendMessage extends UseCase<void, SendMessageParams> {
  SendMessage(this._repository);
  final ChatRepository _repository;
  @override Future<void> call(SendMessageParams params) => _repository.sendMessage(receiverId: params.receiverId, message: params.message, recipientPublicKey: params.recipientPublicKey);
}

class SendMessageParams {
  const SendMessageParams({required this.receiverId, required this.message, this.recipientPublicKey});
  final String receiverId;
  final String message;
  final RSAPublicKey? recipientPublicKey;
}
