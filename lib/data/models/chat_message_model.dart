enum MessageSender { user, landlord, system }

class ChatMessageModel {
  final String id;
  final String pgId;
  final String text;
  final MessageSender sender;
  final DateTime timestamp;
  final bool isRead;

  const ChatMessageModel({
    required this.id,
    required this.pgId,
    required this.text,
    required this.sender,
    required this.timestamp,
    this.isRead = true,
  });

  ChatMessageModel copyWith({
    String? id,
    String? pgId,
    String? text,
    MessageSender? sender,
    DateTime? timestamp,
    bool? isRead,
  }) {
    return ChatMessageModel(
      id: id ?? this.id,
      pgId: pgId ?? this.pgId,
      text: text ?? this.text,
      sender: sender ?? this.sender,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
    );
  }
}
