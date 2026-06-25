import 'package:equatable/equatable.dart';
import 'package:fumo/domain/entities/message_entity.dart';

class ChatRoomEntity extends Equatable {
  const ChatRoomEntity({
    required this.id,
    required this.participantIds,
    this.lastMessage,
  });

  final String id;
  final List<String> participantIds;
  final MessageEntity? lastMessage;

  @override
  List<Object?> get props => [id, participantIds, lastMessage];
}
