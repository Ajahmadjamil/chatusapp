class Profile {
  Profile({
    required this.id,
    required this.name,
    required this.email,
    required this.profileImage,
    required this.about,
    required this.isOnline,
    required this.lastActive,
    required this.pushToken,
    required this.createdAt,
  });

  final String? id;
  final String? name;
  final String? email;
  final String? profileImage;
  final String? about;
  final bool? isOnline;
  final DateTime? lastActive;
  final String? pushToken;
  final DateTime? createdAt;

  Profile copyWith({
    String? id,
    String? name,
    String? email,
    String? profileImage,
    String? about,
    bool? isOnline,
    DateTime? lastActive,
    String? pushToken,
    DateTime? createdAt,
  }) {
    return Profile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      about: about ?? this.about,
      isOnline: isOnline ?? this.isOnline,
      lastActive: lastActive ?? this.lastActive,
      pushToken: pushToken ?? this.pushToken,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json["id"],
      name: json["name"],
      email: json["email"],
      profileImage: json["profile_image"],
      about: json["about"],
      isOnline: json["is_online"],
      lastActive: DateTime.tryParse(json["last_active"] ?? ""),
      pushToken: json["push_token"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "profile_image": profileImage,
    "about": about,
    "is_online": isOnline,
    "last_active": lastActive?.toIso8601String(),
    "push_token": pushToken,
    "created_at": createdAt?.toIso8601String(),
  };

  @override
  String toString() {
    return "$id, $name, $email, $profileImage, $about, $isOnline, $lastActive, $pushToken, $createdAt, ";
  }
}

/*
{
	"id": "9f1b6f20-7cda-4a4c-94ab-d440d1234567",
	"name": "John Doe",
	"email": "john@example.com",
	"profile_image": "https://example.com/john.jpg",
	"about": "Hey there! I am using this app.",
	"is_online": true,
	"last_active": "2025-01-15T12:30:00Z",
	"push_token": "fcm_token_here",
	"created_at": "2025-01-01T10:00:00Z"
}*/
