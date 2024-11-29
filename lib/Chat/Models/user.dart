class User {
  final int id;
  final String name;
  final String image;
  final DateTime lastActiveAt;
  final dynamic lastMessageTime;
  final dynamic lastMessageContent;
  final bool isOnline;

  User({
    required this.id,
    required this.name,
    required this.image,
    required this.lastActiveAt,
    required this.lastMessageTime,
    required this.lastMessageContent,
    required this.isOnline,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        lastActiveAt: DateTime.parse(json["last_active_at"]),
        lastMessageTime: json["last_message_time"],
        lastMessageContent: json["last_message_content"],
        isOnline: json["is_online"],
      );
}
