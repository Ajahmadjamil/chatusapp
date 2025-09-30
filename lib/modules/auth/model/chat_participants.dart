class ChatParticipants {
  ChatParticipants({required this.chatId, required this.userId, required this.addedAt});

  final String? chatId;
  final String? userId;
  final DateTime? addedAt;

  ChatParticipants copyWith({String? chatId, String? userId, DateTime? addedAt}) {
    return ChatParticipants(
      chatId: chatId ?? this.chatId,
      userId: userId ?? this.userId,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  factory ChatParticipants.fromJson(Map<String, dynamic> json) {
    return ChatParticipants(
      chatId: json["chat_id"],
      userId: json["user_id"],
      addedAt: DateTime.tryParse(json["added_at"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {"chat_id": chatId, "user_id": userId, "added_at": addedAt?.toIso8601String()};

  @override
  String toString() {
    return "$chatId, $userId, $addedAt, ";
  }
}

/*
{
	"chat_id": "e21f9d30-437c-4e77-8889-abbaf1345678",
	"user_id": "9f1b6f20-7cda-4a4c-94ab-d440d1234567",
	"added_at": "2025-01-10T15:00:10Z"
}*/
