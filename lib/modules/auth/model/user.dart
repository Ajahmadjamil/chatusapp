class UserModel {
  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.profileImage,
    required this.about,
    required this.isOnline,
    required this.createdAt,
    required this.lastActive,
    required this.pushToken,
  });

  final int? id;
  final String? name;
  final String? email;
  final String? profileImage;
  final String? about;
  final bool? isOnline;
  final DateTime? createdAt;
  final DateTime? lastActive;
  final String? pushToken;

  UserModel copyWith({
    int? id,
    String? name,
    String? email,
    String? profileImage,
    String? about,
    bool? isOnline,
    DateTime? createdAt,
    DateTime? lastActive,
    String? pushToken,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      about: about ?? this.about,
      isOnline: isOnline ?? this.isOnline,
      createdAt: createdAt ?? this.createdAt,
      lastActive: lastActive ?? this.lastActive,
      pushToken: pushToken ?? this.pushToken,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"],
      name: json["name"],
      email: json["email"],
      profileImage: json["profile_image"],
      about: json["about"],
      isOnline: json["is_online"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      lastActive: DateTime.tryParse(json["last_active"] ?? ""),
      pushToken: json["push_token"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "profile_image": profileImage,
    "about": about,
    "is_online": isOnline,
    "createdAt": createdAt?.toIso8601String(),
    "last_active": lastActive?.toIso8601String(),
    "push_token": pushToken,
  };

  @override
  String toString() {
    return "$id, $name, $email, $profileImage, $about, $isOnline, $createdAt, $lastActive, $pushToken, ";
  }
}

/*
{
	"id": 1,
	"name": "John Doe",
	"email": "john.doe@example.com",
	"profile_image": "https://example.com/profile.jpg",
	"about": "Hey! I am using this app.",
	"is_online": true,
	"createdAt": "2025-01-10T12:30:00.000Z",
	"last_active": "2025-01-10T15:45:00.000Z",
	"push_token": "fcm_push_token_123"
}*/
