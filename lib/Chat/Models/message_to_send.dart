class MessageToSend {
  final String type;
  final String? file;
  final String? content;
  final int uniqueId;
  bool isError;
  final int? messageToReplyId;
  MessageToSend({
    this.file,
    this.isError = false,
    required this.type,
    required this.uniqueId,
    required this.messageToReplyId,
    this.content,
  });
}
