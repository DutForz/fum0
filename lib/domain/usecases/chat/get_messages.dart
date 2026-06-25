import 'package:fumo/core/usecases/usecase.dart';
import 'package:fumo/domain/entities/message_entity.dart';
import 'package:fumo/domain/repositories/chat_repository.dart';
import 'package:pointycastle/export.dart';

class GetMessages extends StreamUseCase<List<MessageEntity>, GetMessagesParams> {
  GetMessages(this._repository);
  final ChatRepository _repository;
  @override Stream<List<MessageEntity>> call(GetMessagesParams params) => _repository.getMessages(currentUserId: params.currentUserId, otherUserId: params.otherUserId, myPrivateKey: params.myPrivateKey);
}

class GetMessagesParams {
  const GetMessagesParams({required this.currentUserId, required this.otherUserId, this.myPrivateKey});
  final String currentUserId;
  final String otherUserId;
  final RSAPrivateKey? myPrivateKey;
}
