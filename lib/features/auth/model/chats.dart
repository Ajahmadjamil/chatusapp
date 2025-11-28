class Chats {
  Chats({
    required this.id,
    required this.chatName,
    required this.chatImage,
    required this.createdAt,
    required this.lastMessage,
    required this.updatedAt,
  });

  final String? id;
  final String? chatName;
  final String? chatImage;
  final String? createdAt;
  final String? lastMessage;
  final String? updatedAt;

  Chats copyWith({
    String? id,
    String? chatName,
    String? chatImage,
    String? createdAt,
    String? lastMessage,
    String? updatedAt,
  }) {
    return Chats(
      id: id ?? this.id,
      chatName: chatName ?? this.chatName,
      chatImage: chatImage ?? this.chatImage,
      createdAt: createdAt ?? this.createdAt,
      lastMessage: lastMessage ?? this.lastMessage,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Chats.fromJson(Map<String, dynamic> json) {
    return Chats(
      id: json["id"],
      chatName: json["chat_name"],
      chatImage: json["chat_image"],
      createdAt: json["created_at"],
      lastMessage: json["last_message"],
      updatedAt: json["updated_at"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "chat_name": chatName,
    "chat_image": chatImage,
    "created_at": createdAt,
    "last_message": lastMessage,
    "updated_at": updatedAt,
  };

  @override
  String toString() {
    return "$id, $chatName, $chatImage, $createdAt, $lastMessage, $updatedAt, ";
  }
}

/*
{
	"id": "uuid",
	"chat_name": "string | null",
	"chat_image": "string | null",
	"created_at": "timestamp",
	"last_message": "string | null",
	"updated_at": "timestamp"
}*/
