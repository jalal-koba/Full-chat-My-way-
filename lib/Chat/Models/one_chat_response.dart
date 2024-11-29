import 'package:my_way_chat/Chat/Models/message.dart';
import 'package:my_way_chat/Chat/Models/user.dart';

class OneChatResponse {
  final Data data;
  final User user;

  OneChatResponse({
    required this.data,
    required this.user,
  });

  factory OneChatResponse.fromJson(Map<String, dynamic> json) =>
      OneChatResponse(
        data: Data.fromJson(json["data"]),
        user: User.fromJson(json["user"]),
      );
}

class Data {
  final List<Message> data;

  Data({
    required this.data,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        data: List<Message>.from(json["data"].map((x) => Message.fromJson(x))),
      );
}
