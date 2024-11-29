import 'package:flutter/material.dart';
import 'package:my_way_chat/Chat/Cubit/chat_cubit.dart';
import 'package:my_way_chat/Chat/Models/user.dart';
import 'package:my_way_chat/Chat/View/Screens/one_chat_screen.dart'; 
import 'package:my_way_chat/Chat/View/Widgets/user_image.dart';
import 'package:my_way_chat/Chat/temp/functions.dart';
import 'package:sizer/sizer.dart';

class ChatCard extends StatelessWidget {
  const ChatCard({
    super.key,
    required this.user,
    required this.chatCubit,
    required this.subjectId,
  });

  final ChatCubit chatCubit;

  final User user;
  final int subjectId;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
         Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => OneChatScreen(
            subjectId: subjectId,
            user: user,
            chatCubit: chatCubit,
          ),
        ));
      },
      contentPadding: EdgeInsets.symmetric(horizontal: 4.w),
      leading: UserImage(user: user),
      subtitle: user.lastMessageContent != null
          ? Text(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              user.lastMessageContent,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w300),
            )
          : Text(
              'التواصل مع المعلم',
              style: TextStyle(fontSize: 12.sp, color: const Color(0xFF1E7876)),
            ),
      title: Text(
        user.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            color: Colors.black, fontSize: 10.sp, fontWeight: FontWeight.bold),
      ),
      trailing: user.lastMessageContent != null
          ? Text(
              dateFormatted(user.lastMessageTime),
              style: TextStyle(fontSize: 8.sp, fontWeight: FontWeight.w400),
            )
          : null,
    );
  }
}
