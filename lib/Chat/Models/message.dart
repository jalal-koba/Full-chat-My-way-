class Message {
  bool isLocal;
  bool isError;
  int id;
  final int subjectId;
  final int? messageId;
  final String? content;
  String? file;
  final String type;
  final DateTime? readAt;
  final DateTime createdAt;
  bool? isSentByAuthUser;
  final Message? reply;

  Message({
    this.isLocal = false,
    this.isError = false,
    required this.id,
    required this.subjectId,
    this.messageId,
    this.content,
    this.file,
    required this.type,
    this.readAt,
    required this.createdAt,
    this.isSentByAuthUser,
    this.reply,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json["id"],
        subjectId: json["subject_id"],
        messageId: json["message_id"],
        content: json["content"],
        file: json["file"],
        type: json["type"],
        readAt:
            json["read_at"] != null ? DateTime.parse(json["read_at"]) : null,
        createdAt: DateTime.parse(json["created_at"]),
        isSentByAuthUser: json["is_sent_by_auth_user"],
        reply: json["reply"] == null ? null : Message.fromJson(json["reply"]),
      );
}
