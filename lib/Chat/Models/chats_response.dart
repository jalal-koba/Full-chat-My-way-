import 'package:my_way_chat/Chat/Models/user.dart';

class ChatsResponse {
  final Data data;
  final int code;

  ChatsResponse({
    required this.data,
    required this.code,
  });

  factory ChatsResponse.fromJson(Map<String, dynamic> json) => ChatsResponse(
        data: Data.fromJson(json["data"]),
        code: json["code"],
      );
}

class Data {
  final List<User> data;

  Data({
    required this.data,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        data: List<User>.from(json["data"].map((x) => User.fromJson(x))),
      );
}
