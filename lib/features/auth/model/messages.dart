class Messages {
  Messages({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.receiverId,
    required this.msg,
    required this.imgUrl,
    required this.voiceNote,
    required this.msgStatus,
    required this.createdAt,
  });

  final String? id;
  final String? chatId;
  final String? senderId;
  final String? receiverId;
  final String? msg;
  final dynamic imgUrl;
  final dynamic voiceNote;
  final String? msgStatus;
  final DateTime? createdAt;

  Messages copyWith({
    String? id,
    String? chatId,
    String? senderId,
    String? receiverId,
    String? msg,
    dynamic? imgUrl,
    dynamic? voiceNote,
    String? msgStatus,
    DateTime? createdAt,
  }) {
    return Messages(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      msg: msg ?? this.msg,
      imgUrl: imgUrl ?? this.imgUrl,
      voiceNote: voiceNote ?? this.voiceNote,
      msgStatus: msgStatus ?? this.msgStatus,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory Messages.fromJson(Map<String, dynamic> json) {
    return Messages(
      id: json["id"],
      chatId: json["chat_id"],
      senderId: json["sender_id"],
      receiverId: json["receiver_id"],
      msg: json["msg"],
      imgUrl: json["img_url"],
      voiceNote: json["voice_note"],
      msgStatus: json["msg_status"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "chat_id": chatId,
    "sender_id": senderId,
    "receiver_id": receiverId,
    "msg": msg,
    "img_url": imgUrl,
    "voice_note": voiceNote,
    "msg_status": msgStatus,
    "created_at": createdAt?.toIso8601String(),
  };

  @override
  String toString() {
    return "$id, $chatId, $senderId, $receiverId, $msg, $imgUrl, $voiceNote, $msgStatus, $createdAt, ";
  }
}

/*
{
	"id": "d90f8a10-2b5e-4e18-bfc7-1a2efde23456",
	"chat_id": "e21f9d30-437c-4e77-8889-abbaf1345678",
	"sender_id": "9f1b6f20-7cda-4a4c-94ab-d440d1234567",
	"receiver_id": "13a27d99-6df2-4a5e-b89f-ab2acfc12345",
	"msg": "Hello!",
	"img_url": null,
	"voice_note": null,
	"msg_status": "sent",
	"created_at": "2025-01-10T15:01:00Z"
}*/
