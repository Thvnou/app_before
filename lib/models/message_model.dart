/// A single chat message inside a matched conversation.
class Message {
  final String id;
  final String matchId;
  final String senderId;
  final String senderPrenom;
  final bool isMe;
  final String contenu;
  final bool lu;
  final DateTime createdAt;

  const Message({
    required this.id,
    required this.matchId,
    required this.senderId,
    required this.senderPrenom,
    required this.isMe,
    required this.contenu,
    this.lu = false,
    required this.createdAt,
  });

  Message copyWith({bool? lu}) {
    return Message(
      id: id,
      matchId: matchId,
      senderId: senderId,
      senderPrenom: senderPrenom,
      isMe: isMe,
      contenu: contenu,
      lu: lu ?? this.lu,
      createdAt: createdAt,
    );
  }
}
