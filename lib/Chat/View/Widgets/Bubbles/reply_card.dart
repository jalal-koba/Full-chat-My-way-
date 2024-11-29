// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:my_way_chat/Chat/Cubit/chat_cubit.dart';
import 'package:my_way_chat/Chat/Models/message.dart';
import 'package:my_way_chat/Chat/View/Widgets/Public/cached_image.dart';
import 'package:sizer/sizer.dart';

class ReplyCard extends StatelessWidget {
  const ReplyCard(
      {super.key,
      required this.message,
  
      this.isTextMessage = false,
      required this.chatCubit});
  final Message message;
  final bool isTextMessage;
 
  final ChatCubit chatCubit;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        chatCubit.scrollToMessage(id:   message.reply!.id);
      },
      child: Container(
        clipBehavior: Clip.hardEdge,
        constraints: BoxConstraints(minWidth: 25.w),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
        width: isTextMessage
            ? message.content.toString().length > 10
                ? double.infinity
                : null
            : double.infinity,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          border: const Border(left: BorderSide(color: Colors.green, width: 3)),
          borderRadius: BorderRadius.circular(8),
          color: Colors.black.withOpacity(0.05),
        ),
        child: message.reply!.type == "text"
            ? Text(
                message.reply!.content!,
                style: TextStyle(fontSize: 10.sp),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              )
            : message.reply!.type == 'image'
                ? Align(
                    alignment: message.reply!.isSentByAuthUser == null
                        ? Alignment.centerLeft
                        : Alignment.center,
                    child: Container(
                      width: 25.w,
                      clipBehavior: Clip.hardEdge,
                      height: 7.h,
                      decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(5)),
                      child: CachedImage(
                        image: message.reply!.file!,
                      ),
                    ),
                  )
                : Text(message.reply!.type == 'audio' ? 'رسالة صوتية' : "ملف"),
      ),
    );
  }
}
